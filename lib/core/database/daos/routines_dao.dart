// lib/core/database/daos/routines_dao.dart
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'routines_dao.g.dart';

@DriftAccessor(tables: [Routines])
class RoutinesDao extends DatabaseAccessor<AppDatabase> with _$RoutinesDaoMixin {
  RoutinesDao(super.db);

  Stream<List<Routine>> watchAll() => select(routines).watch();

  Future<int> insertRoutine(RoutinesCompanion routine) =>
      into(routines).insert(routine);

  Future<void> deleteRoutine(int id) =>
      (delete(routines)..where((t) => t.id.equals(id))).go();
}
