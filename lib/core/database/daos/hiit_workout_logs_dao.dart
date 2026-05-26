import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'hiit_workout_logs_dao.g.dart';

@DriftAccessor(tables: [HiitWorkoutLogs, HiitExerciseLogs])
class HiitWorkoutLogsDao extends DatabaseAccessor<AppDatabase>
    with _$HiitWorkoutLogsDaoMixin {
  HiitWorkoutLogsDao(super.db);

  Future<int> createLog(int sessionId) => into(hiitWorkoutLogs).insert(
        HiitWorkoutLogsCompanion.insert(
          sessionId: sessionId,
          startedAt: DateTime.now(),
        ),
      );

  Future<void> completeLog(int logId) =>
      (update(hiitWorkoutLogs)..where((t) => t.id.equals(logId)))
          .write(HiitWorkoutLogsCompanion(completedAt: Value(DateTime.now())));

  Future<void> logExercise(
    int workoutLogId,
    int exerciseId,
    int round,
    int actualValue,
  ) =>
      into(hiitExerciseLogs).insert(
        HiitExerciseLogsCompanion.insert(
          workoutLogId: workoutLogId,
          exerciseId: exerciseId,
          round: round,
          actualValue: actualValue,
          completedAt: DateTime.now(),
        ),
      );

  Stream<List<HiitWorkoutLog>> watchLogsForSession(int sessionId) =>
      (select(hiitWorkoutLogs)
            ..where((t) => t.sessionId.equals(sessionId))
            ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
          .watch();

  Future<List<HiitExerciseLog>> getExerciseLogsForWorkout(int workoutLogId) =>
      (select(hiitExerciseLogs)
            ..where((t) => t.workoutLogId.equals(workoutLogId)))
          .get();
}
