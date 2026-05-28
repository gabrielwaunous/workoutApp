// lib/core/parser/routine_parser.dart
import 'parsed_models.dart';
import '../muscle_group_detector.dart';

class RoutineParser {
  // Strip leading WhatsApp bullet chars (* bullet) and invisible Unicode
  // chars like U+2060 (word joiner) that WhatsApp prepends to list items.
  static final _bulletRe = RegExp(r'^[\s*•⁠﻿ ]+');

  // "4x8" or "3X16" — NxM anywhere in line (partial match, allows trailing text)
  static final _nxmRe = RegExp(
    r'^(.+?)\s+(\d+)[xX](\d+)(?:\s+(\d+\.?\d*)\s*kg)?',
    caseSensitive: false,
  );

  // "12.10.8.6" — dot-separated reps, must be end of line
  static final _dotRe = RegExp(
    r'^(.+?)\s+([\d]+(?:\.[\d]+)+)\s*$',
    caseSensitive: false,
  );

  // "4xfallo" or "4 x fallo" — spaces around x are optional
  static final _failureRe = RegExp(
    r'^(.+?)\s+(\d+)\s*[xX]\s*fallo',
    caseSensitive: false,
  );

  // "N [qualifier] y N [qualifier]"
  // e.g. "bíceps c mancuernas 8 comunes y 8 martillo en simultáneo"
  static final _yCompoundRe = RegExp(
    r'^(.+?)\s+(\d+)\s+\w[\w\s]*?y\s+(\d+)(?:\s+(.+))?$',
    caseSensitive: false,
  );

  // "+" between compound parts — "6 + 6", "8+8", "sentadillas + saltos"
  // Matches: digit±space+±space digit  OR  space+space (exercise names without nums)
  static final _compoundTrigger = RegExp(r'(?:\d\s*\+\s*\d|\s\+\s)');

  // Parenthesised metadata: "(hacer 3 vueltas c/2 min de pausa)"
  static final _parenRe = RegExp(r'\(([^)]+)\)');
  static final _restMinRe = RegExp(r'c/\s*(\d+)\s*min', caseSensitive: false);
  static final _roundsRe = RegExp(r'(\d+)\s*vuelta', caseSensitive: false);

  // Component parsers for compound: "3 Saltos c/caida" vs "Sentadillas 3"
  static final _numFirstRe = RegExp(r'^(\d+)\s+(.+)$');
  static final _namFirstRe = RegExp(r'^(.+?)\s+(\d+)$');

  // "30 seg bici" — duration-first format (HIIT/cardio)
  static final _timeFirstRe = RegExp(r'^(\d+)\s+seg\s+(.+)$', caseSensitive: false);

  static String _cleanLine(String line) =>
      line.replaceFirst(_bulletRe, '').trim();

  ParseResult parse(String text) {
    final exercises = <ParsedExercise>[];
    final unrecognized = <UnrecognizedLine>[];

    for (final raw in text.split('\n')) {
      final line = _cleanLine(raw);
      if (line.isEmpty) continue;

      final exercise = _tryParse(line);
      if (exercise != null) {
        exercises.add(exercise);
      } else {
        unrecognized.add(UnrecognizedLine(original: line));
      }
    }

    return ParseResult(exercises: exercises, unrecognized: unrecognized);
  }

  ParsedExercise? _tryParse(String line) {
    final upper = line.toUpperCase();
    final hasSp = upper.contains(' SP');

    // Failure first — "4xfallo" or "4 x fallo"
    final failMatch = _failureRe.firstMatch(line);
    if (failMatch != null) {
      final name = failMatch.group(1)!.trim();
      final count = int.parse(failMatch.group(2)!);
      return _build(
        name,
        List.generate(
          count,
          (i) => ParsedSet(
            toFailure: true,
            isPartial: hasSp && i == count - 1,
          ),
        ),
      );
    }

    // NxM pattern
    final nxmMatch = _nxmRe.firstMatch(line);
    if (nxmMatch != null) {
      final name = nxmMatch.group(1)!.trim();
      final n = int.parse(nxmMatch.group(2)!);
      final m = int.parse(nxmMatch.group(3)!);
      final weight = nxmMatch.group(4) != null
          ? double.tryParse(nxmMatch.group(4)!)
          : null;
      return _build(
        name,
        List.generate(
          n,
          (i) => ParsedSet(
            reps: m,
            weight: weight,
            isPartial: hasSp && i == n - 1,
          ),
        ),
      );
    }

    // Dot pattern
    final dotMatch = _dotRe.firstMatch(line);
    if (dotMatch != null) {
      final name = dotMatch.group(1)!.trim();
      final repsList = dotMatch.group(2)!.split('.').map(int.parse).toList();
      return _build(name, repsList.map((r) => ParsedSet(reps: r)).toList());
    }

    // "N qualifier y N qualifier" compound
    final yMatch = _yCompoundRe.firstMatch(line);
    if (yMatch != null) {
      final name = yMatch.group(1)!.trim();
      final reps = int.parse(yMatch.group(2)!) + int.parse(yMatch.group(3)!);
      return _build(name, [ParsedSet(reps: reps)]);
    }

    // "+" compound / circuit
    if (_compoundTrigger.hasMatch(line)) {
      return _parseCompound(line);
    }

    // "30 seg bici" — duration-first (HIIT/cardio)
    final timeMatch = _timeFirstRe.firstMatch(line);
    if (timeMatch != null) {
      final duration = int.parse(timeMatch.group(1)!);
      final name = timeMatch.group(2)!.trim();
      return _build(name, [ParsedSet(durationSeconds: duration)]);
    }

    // "8 saltos laterales al step" — reps-first format
    final numFirst = _numFirstRe.firstMatch(line);
    if (numFirst != null) {
      final reps = int.parse(numFirst.group(1)!);
      final name = numFirst.group(2)!.trim();
      return _build(name, [ParsedSet(reps: reps)]);
    }

    return null;
  }

  ParsedExercise _parseCompound(String line) {
    int? restSeconds;
    int rounds = 1;

    final parenMatch = _parenRe.firstMatch(line);
    if (parenMatch != null) {
      final paren = parenMatch.group(1)!;
      final roundsMatch = _roundsRe.firstMatch(paren);
      if (roundsMatch != null) rounds = int.parse(roundsMatch.group(1)!);
      final restMatch = _restMinRe.firstMatch(paren);
      if (restMatch != null) restSeconds = int.parse(restMatch.group(1)!) * 60;
      line = line.replaceAll(_parenRe, '').trim();
    }

    final parts = line.split(RegExp(r'\s*\+\s*'));
    int totalReps = 0;
    final names = <String>[];

    for (final part in parts) {
      final p = part.trim();
      if (p.isEmpty) continue;
      final numFirst = _numFirstRe.firstMatch(p);
      final namFirst = _namFirstRe.firstMatch(p);
      if (numFirst != null) {
        totalReps += int.parse(numFirst.group(1)!);
        names.add(numFirst.group(2)!.trim());
      } else if (namFirst != null) {
        names.add(namFirst.group(1)!.trim());
        totalReps += int.parse(namFirst.group(2)!);
      } else {
        names.add(p);
      }
    }

    return _build(
      names.join(' + '),
      List.generate(
        rounds,
        (_) => ParsedSet(reps: totalReps > 0 ? totalReps : null),
      ),
      restSeconds: restSeconds,
    );
  }

  ParsedExercise _build(String name, List<ParsedSet> sets,
          {int? restSeconds}) =>
      ParsedExercise(
        name: name,
        sets: sets,
        restSeconds: restSeconds,
        muscleGroup: MuscleGroupDetector.detect(name),
      );
}
