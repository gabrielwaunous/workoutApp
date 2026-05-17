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

    return null;
  }
}
