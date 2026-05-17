import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/tables.dart';
import '../../core/volume.dart';
import '../../providers.dart';

final todaySessionProvider = FutureProvider<WorkoutSession>((ref) async {
  final db = ref.watch(databaseProvider);
  final today = DateTime.now();
  final existing = await db.sessionsDao.getByDate(today);
  if (existing != null) return existing;
  await db.sessionsDao.insertSession(
    WorkoutSessionsCompanion(date: Value(today)),
  );
  return (await db.sessionsDao.getByDate(today))!;
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
