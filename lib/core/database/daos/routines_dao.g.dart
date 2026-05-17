// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routines_dao.dart';

// ignore_for_file: type=lint
mixin _$RoutinesDaoMixin on DatabaseAccessor<AppDatabase> {
  $RoutinesTable get routines => attachedDatabase.routines;
  RoutinesDaoManager get managers => RoutinesDaoManager(this);
}

class RoutinesDaoManager {
  final _$RoutinesDaoMixin _db;
  RoutinesDaoManager(this._db);
  $$RoutinesTableTableManager get routines =>
      $$RoutinesTableTableManager(_db.attachedDatabase, _db.routines);
}
