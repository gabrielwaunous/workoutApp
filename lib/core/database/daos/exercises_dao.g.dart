// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercises_dao.dart';

// ignore_for_file: type=lint
mixin _$ExercisesDaoMixin on DatabaseAccessor<AppDatabase> {
  $WorkoutSessionsTable get workoutSessions => attachedDatabase.workoutSessions;
  $ExercisesTable get exercises => attachedDatabase.exercises;
  ExercisesDaoManager get managers => ExercisesDaoManager(this);
}

class ExercisesDaoManager {
  final _$ExercisesDaoMixin _db;
  ExercisesDaoManager(this._db);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(
        _db.attachedDatabase,
        _db.workoutSessions,
      );
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db.attachedDatabase, _db.exercises);
}
