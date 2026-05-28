import 'package:flutter_test/flutter_test.dart';
import 'package:workout_app/core/muscle_group_detector.dart';

void main() {
  group('MuscleGroupDetector', () {
    test('press plano → Pecho', () {
      expect(MuscleGroupDetector.detect('press plano'), 'Pecho');
    });

    test('press militar → Hombros (multi-word wins over single-word)', () {
      expect(MuscleGroupDetector.detect('press militar'), 'Hombros');
    });

    test('Bíceps barra → Biceps (accent-insensitive)', () {
      expect(MuscleGroupDetector.detect('Bíceps barra'), 'Biceps');
    });

    test('dominadas asistidas → Espalda', () {
      expect(MuscleGroupDetector.detect('dominadas asistidas'), 'Espalda');
    });

    test('sentadillas → Piernas', () {
      expect(MuscleGroupDetector.detect('sentadillas'), 'Piernas');
    });

    test('tríceps paralelas → Triceps (not Espalda)', () {
      expect(MuscleGroupDetector.detect('tríceps paralelas'), 'Triceps');
    });

    test('hip trust (misspelling) → Piernas', () {
      expect(MuscleGroupDetector.detect('hip trust'), 'Piernas');
    });

    test('elevación de pelvis → Piernas', () {
      expect(MuscleGroupDetector.detect('elevación de pelvis'), 'Piernas');
    });

    test('saltos asistidos → Piernas (not Cardio)', () {
      expect(MuscleGroupDetector.detect('saltos asistidos c/banda'), 'Piernas');
    });

    test('saltos con cuerda → Cardio', () {
      expect(MuscleGroupDetector.detect('saltos con cuerda'), 'Cardio');
    });

    test('unknown exercise → null', () {
      expect(MuscleGroupDetector.detect('zumba'), isNull);
    });
  });
}
