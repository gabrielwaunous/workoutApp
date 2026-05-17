import 'database/app_database.dart';

double calculateSetVolume(WorkoutSet s) {
  if (s.toFailure || s.reps == null) return 0;
  final r = s.reps!.toDouble();
  return s.weight != null ? r * s.weight! : r;
}

double calculateExerciseVolume(List<WorkoutSet> sets) =>
    sets.fold(0.0, (sum, s) => sum + calculateSetVolume(s));
