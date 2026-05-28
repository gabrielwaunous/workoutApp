// lib/core/parser/parsed_models.dart

class ParsedSet {
  final int? reps;
  final double? weight;
  final bool toFailure;
  final bool isPartial;
  final int? durationSeconds;

  const ParsedSet({
    this.reps,
    this.weight,
    this.toFailure = false,
    this.isPartial = false,
    this.durationSeconds,
  });
}

class ParsedExercise {
  final String name;
  final List<ParsedSet> sets;
  final int? restSeconds;
  final String? muscleGroup;

  const ParsedExercise({
    required this.name,
    required this.sets,
    this.restSeconds,
    this.muscleGroup,
  });
}

class UnrecognizedLine {
  final String original;
  String edited;

  UnrecognizedLine({required this.original}) : edited = original;
}

class ParseResult {
  final List<ParsedExercise> exercises;
  final List<UnrecognizedLine> unrecognized;

  const ParseResult({required this.exercises, required this.unrecognized});
}
