// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hiit_exercises_dao.dart';

// ignore_for_file: type=lint
mixin _$HiitExercisesDaoMixin on DatabaseAccessor<AppDatabase> {
  $WorkoutSessionsTable get workoutSessions => attachedDatabase.workoutSessions;
  $HiitCircuitsTable get hiitCircuits => attachedDatabase.hiitCircuits;
  $HiitExercisesTable get hiitExercises => attachedDatabase.hiitExercises;
  HiitExercisesDaoManager get managers => HiitExercisesDaoManager(this);
}

class HiitExercisesDaoManager {
  final _$HiitExercisesDaoMixin _db;
  HiitExercisesDaoManager(this._db);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(
        _db.attachedDatabase,
        _db.workoutSessions,
      );
  $$HiitCircuitsTableTableManager get hiitCircuits =>
      $$HiitCircuitsTableTableManager(_db.attachedDatabase, _db.hiitCircuits);
  $$HiitExercisesTableTableManager get hiitExercises =>
      $$HiitExercisesTableTableManager(_db.attachedDatabase, _db.hiitExercises);
}
