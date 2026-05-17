// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sets_dao.dart';

// ignore_for_file: type=lint
mixin _$SetsDaoMixin on DatabaseAccessor<AppDatabase> {
  $WorkoutSessionsTable get workoutSessions => attachedDatabase.workoutSessions;
  $ExercisesTable get exercises => attachedDatabase.exercises;
  $SetsTable get sets => attachedDatabase.sets;
  SetsDaoManager get managers => SetsDaoManager(this);
}

class SetsDaoManager {
  final _$SetsDaoMixin _db;
  SetsDaoManager(this._db);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(
        _db.attachedDatabase,
        _db.workoutSessions,
      );
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db.attachedDatabase, _db.exercises);
  $$SetsTableTableManager get sets =>
      $$SetsTableTableManager(_db.attachedDatabase, _db.sets);
}
