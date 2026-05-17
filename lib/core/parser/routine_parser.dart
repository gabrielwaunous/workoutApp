// lib/core/parser/routine_parser.dart
import 'parsed_models.dart';

class RoutineParser {
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

  // "4xfallo" or "4Xfallo"
  static final _failureRe = RegExp(
    r'^(.+?)\s+(\d+)[xX]fallo',
    caseSensitive: false,
  );

  // Trigger: "+" surrounded by spaces — "4 sentadillas + 4 saltos", "6 + 6", etc.
  static final _compoundTrigger = RegExp(r'\s\+\s');

  // Parenthesised metadata: "(hacer 3 vueltas c/2 min de pausa)"
  static final _parenRe = RegExp(r'\(([^)]+)\)');
  static final _restMinRe = RegExp(r'c/\s*(\d+)\s*min', caseSensitive: false);
  static final _roundsRe = RegExp(r'(\d+)\s*vuelta', caseSensitive: false);

  // Component parsers: "3 Saltos c/caida" vs "Sentadillas 3"
  static final _numFirstRe = RegExp(r'^(\d+)\s+(.+)$');
  static final _namFirstRe = RegExp(r'^(.+?)\s+(\d+)$');

  ParseResult parse(String text) {
    final exercises = <ParsedExercise>[];
    final unrecognized = <UnrecognizedLine>[];

    for (final raw in text.split('\n')) {
      final line = raw.trim();
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

    // Failure pattern first (before NxM, since "xfallo" would also loosely match NxM)
    final failMatch = _failureRe.firstMatch(line);
    if (failMatch != null) {
      final name = failMatch.group(1)!.trim();
      final count = int.parse(failMatch.group(2)!);
      return ParsedExercise(
        name: name,
        sets: List.generate(
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
      return ParsedExercise(
        name: name,
        sets: List.generate(
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
      return ParsedExercise(
        name: name,
        sets: repsList.map((r) => ParsedSet(reps: r)).toList(),
      );
    }

    // Compound / circuit pattern: "6 + 6 ...", "3 + 3 + 5 ... (3 vueltas c/2 min)"
    if (_compoundTrigger.hasMatch(line)) {
      return _parseCompound(line);
    }

    return null;
  }

  ParsedExercise _parseCompound(String line) {
    int? restSeconds;
    int rounds = 1;

    // Extract paren block for rounds and rest metadata
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

    return ParsedExercise(
      name: names.join(' + '),
      sets: List.generate(
        rounds,
        (_) => ParsedSet(reps: totalReps > 0 ? totalReps : null),
      ),
      restSeconds: restSeconds,
    );
  }
}
