import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/volume.dart';
import '../../providers.dart';

final todaySessionProvider = FutureProvider<WorkoutSession>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.sessionsDao.getOrCreateForDate(DateTime.now());
});

final sessionForDateProvider =
    FutureProvider.family<WorkoutSession, DateTime>((ref, date) async {
  final db = ref.watch(databaseProvider);
  return db.sessionsDao.getOrCreateForDate(date);
});

final exercisesBySessionProvider =
    StreamProvider.family<List<Exercise>, int>((ref, sessionId) {
  return ref.watch(databaseProvider).exercisesDao.watchBySession(sessionId);
});

final setsByExerciseProvider =
    StreamProvider.family<List<WorkoutSet>, int>((ref, exerciseId) {
  return ref.watch(databaseProvider).setsDao.watchByExercise(exerciseId);
});

final dailyVolumeProvider =
    StreamProvider.family<double, int>((ref, sessionId) {
  return ref
      .watch(databaseProvider)
      .setsDao
      .watchBySession(sessionId)
      .map(calculateExerciseVolume);
});
