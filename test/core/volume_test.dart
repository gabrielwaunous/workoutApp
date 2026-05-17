import 'package:flutter_test/flutter_test.dart';
import 'package:workout_app/core/database/app_database.dart';
import 'package:workout_app/core/volume.dart';

WorkoutSet _set({int? reps, double? weight, bool toFailure = false, bool isPartial = false}) {
  return WorkoutSet(
    id: 1,
    exerciseId: 1,
    setNumber: 1,
    reps: reps,
    weight: weight,
    toFailure: toFailure,
    isPartial: isPartial,
  );
}

void main() {
  group('calculateSetVolume', () {
    test('reps × weight when both present', () {
      expect(calculateSetVolume(_set(reps: 8, weight: 60)), 480.0);
    });

    test('reps only when no weight', () {
      expect(calculateSetVolume(_set(reps: 10)), 10.0);
    });

    test('zero for to_failure sets', () {
      expect(calculateSetVolume(_set(toFailure: true)), 0.0);
    });

    test('zero when reps is null and not to_failure', () {
      expect(calculateSetVolume(_set(reps: null)), 0.0);
    });
  });

  group('calculateExerciseVolume', () {
    test('sums set volumes', () {
      final sets = [
        _set(reps: 8, weight: 60),  // 480
        _set(reps: 8, weight: 60),  // 480
        _set(reps: 6, weight: 60),  // 360
      ];
      expect(calculateExerciseVolume(sets), 1320.0);
    });

    test('skips to_failure sets', () {
      final sets = [
        _set(reps: 10),            // 10
        _set(toFailure: true),     // 0
      ];
      expect(calculateExerciseVolume(sets), 10.0);
    });

    test('returns 0 for empty list', () {
      expect(calculateExerciseVolume([]), 0.0);
    });
  });
}
