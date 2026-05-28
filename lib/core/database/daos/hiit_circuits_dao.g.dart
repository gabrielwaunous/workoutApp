// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hiit_circuits_dao.dart';

// ignore_for_file: type=lint
mixin _$HiitCircuitsDaoMixin on DatabaseAccessor<AppDatabase> {
  $WorkoutSessionsTable get workoutSessions => attachedDatabase.workoutSessions;
  $HiitCircuitsTable get hiitCircuits => attachedDatabase.hiitCircuits;
  HiitCircuitsDaoManager get managers => HiitCircuitsDaoManager(this);
}

class HiitCircuitsDaoManager {
  final _$HiitCircuitsDaoMixin _db;
  HiitCircuitsDaoManager(this._db);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(
        _db.attachedDatabase,
        _db.workoutSessions,
      );
  $$HiitCircuitsTableTableManager get hiitCircuits =>
      $$HiitCircuitsTableTableManager(_db.attachedDatabase, _db.hiitCircuits);
}
