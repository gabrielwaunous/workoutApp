// lib/core/parser/parsed_models.dart

class ParsedSet {
  final int? reps;
  final double? weight;
  final bool toFailure;
  final bool isPartial;

  const ParsedSet({
    this.reps,
    this.weight,
    this.toFailure = false,
    this.isPartial = false,
  });
}

class ParsedExercise {
  final String name;
  final List<ParsedSet> sets;

  const ParsedExercise({required this.name, required this.sets});
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
