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

    test('unknown exercise → null', () {
      expect(MuscleGroupDetector.detect('zumba'), isNull);
    });
  });
}
