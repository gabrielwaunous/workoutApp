// test/core/parser/routine_parser_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_app/core/parser/routine_parser.dart';

void main() {
  final parser = RoutineParser();

  group('NxM pattern', () {
    test('parses "press plano 4x8"', () {
      final result = parser.parse('press plano 4x8');
      expect(result.exercises.length, 1);
      expect(result.exercises.first.name, 'press plano');
      expect(result.exercises.first.sets.length, 4);
      expect(result.exercises.first.sets.first.reps, 8);
      expect(result.exercises.first.sets.first.weight, isNull);
    });

    test('parses "press plano 4x8 60kg" with weight', () {
      final result = parser.parse('press plano 4x8 60kg');
      expect(result.exercises.first.sets.first.weight, 60.0);
    });

    test('parses "prensa 45gds 4x8 Max peso" ignoring trailing text', () {
      final result = parser.parse('prensa 45gds 4x8 Max peso');
      expect(result.exercises.length, 1);
      expect(result.exercises.first.name, 'prensa 45gds');
      expect(result.exercises.first.sets.length, 4);
      expect(result.exercises.first.sets.first.reps, 8);
    });

    test('parses "bíceps barra 4x12 SP" with last set is_partial', () {
      final result = parser.parse('bíceps barra 4x12 SP');
      final s = result.exercises.first.sets;
      expect(s.length, 4);
      expect(s.last.isPartial, isTrue);
      expect(s.first.isPartial, isFalse);
    });

    test('is case-insensitive', () {
      final result = parser.parse('Sentadillas 3X16');
      expect(result.exercises.length, 1);
    });
  });

  group('dot pattern', () {
    test('parses "sentadillas 12.10.8.6"', () {
      final result = parser.parse('sentadillas 12.10.8.6');
      expect(result.exercises.first.name, 'sentadillas');
      final reps = result.exercises.first.sets.map((s) => s.reps).toList();
      expect(reps, [12, 10, 8, 6]);
    });

    test('parses "Femorales camilla 12.12.10.10"', () {
      final result = parser.parse('Femorales camilla 12.12.10.10');
      expect(result.exercises.first.name, 'Femorales camilla');
      expect(result.exercises.first.sets.length, 4);
    });
  });

  group('failure pattern', () {
    test('parses "dominadas asistidas 4xfallo"', () {
      final result = parser.parse('dominadas asistidas 4xfallo');
      expect(result.exercises.first.sets.length, 4);
      expect(result.exercises.first.sets.first.toFailure, isTrue);
      expect(result.exercises.first.sets.first.reps, isNull);
    });

    test('parses "dominadas asistidas 4xfallo 6-10 reps SP" with last partial', () {
      final result = parser.parse('dominadas asistidas 4xfallo 6-10 reps SP');
      final s = result.exercises.first.sets;
      expect(s.last.isPartial, isTrue);
    });
  });

  group('unrecognized lines', () {
    test('complex circuit line goes to unrecognized', () {
      final line = 'sentadillas 3 + 3 saltos C/caída del cajón + 5 saltos';
      final result = parser.parse(line);
      expect(result.exercises, isEmpty);
      expect(result.unrecognized.length, 1);
      expect(result.unrecognized.first.original, line);
    });

    test('empty lines are skipped', () {
      final result = parser.parse('\n\n');
      expect(result.exercises, isEmpty);
      expect(result.unrecognized, isEmpty);
    });

    test('section headers like "Femorales camilla 12.12.10.10" before empty line', () {
      final input = 'sentadillas 4x8\n\nremo 3x10';
      final result = parser.parse(input);
      expect(result.exercises.length, 2);
    });
  });

  group('multi-line input', () {
    test('parses full routine from Brainstorming examples', () {
      const input = '''
sentadillas 12.10.8.6
estocadas c/barra 3x16
prensa 45gds 4x8 Max peso
Femorales camilla 12.12.10.10
Femorales con Swiss ball 4x8
''';
      final result = parser.parse(input);
      expect(result.exercises.length, 5);
      expect(result.unrecognized, isEmpty);
    });
  });
}
