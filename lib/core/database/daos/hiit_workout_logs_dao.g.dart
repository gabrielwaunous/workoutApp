// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hiit_workout_logs_dao.dart';

// ignore_for_file: type=lint
mixin _$HiitWorkoutLogsDaoMixin on DatabaseAccessor<AppDatabase> {
  $WorkoutSessionsTable get workoutSessions => attachedDatabase.workoutSessions;
  $HiitWorkoutLogsTable get hiitWorkoutLogs => attachedDatabase.hiitWorkoutLogs;
  $HiitCircuitsTable get hiitCircuits => attachedDatabase.hiitCircuits;
  $HiitExercisesTable get hiitExercises => attachedDatabase.hiitExercises;
  $HiitExerciseLogsTable get hiitExerciseLogs =>
      attachedDatabase.hiitExerciseLogs;
  HiitWorkoutLogsDaoManager get managers => HiitWorkoutLogsDaoManager(this);
}

class HiitWorkoutLogsDaoManager {
  final _$HiitWorkoutLogsDaoMixin _db;
  HiitWorkoutLogsDaoManager(this._db);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(
        _db.attachedDatabase,
        _db.workoutSessions,
      );
  $$HiitWorkoutLogsTableTableManager get hiitWorkoutLogs =>
      $$HiitWorkoutLogsTableTableManager(
        _db.attachedDatabase,
        _db.hiitWorkoutLogs,
      );
  $$HiitCircuitsTableTableManager get hiitCircuits =>
      $$HiitCircuitsTableTableManager(_db.attachedDatabase, _db.hiitCircuits);
  $$HiitExercisesTableTableManager get hiitExercises =>
      $$HiitExercisesTableTableManager(_db.attachedDatabase, _db.hiitExercises);
  $$HiitExerciseLogsTableTableManager get hiitExerciseLogs =>
      $$HiitExerciseLogsTableTableManager(
        _db.attachedDatabase,
        _db.hiitExerciseLogs,
      );
}
