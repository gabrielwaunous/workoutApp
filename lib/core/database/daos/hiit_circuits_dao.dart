import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'hiit_circuits_dao.g.dart';

@DriftAccessor(tables: [HiitCircuits])
class HiitCircuitsDao extends DatabaseAccessor<AppDatabase>
    with _$HiitCircuitsDaoMixin {
  HiitCircuitsDao(super.db);

  Stream<List<HiitCircuit>> watchBySession(int sessionId) =>
      (select(hiitCircuits)
            ..where((t) => t.sessionId.equals(sessionId))
            ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
          .watch();

  Future<int> insertCircuit(HiitCircuitsCompanion c) =>
      into(hiitCircuits).insert(c);

  Future<void> updateCircuit(HiitCircuitsCompanion c) =>
      (update(hiitCircuits)..where((t) => t.id.equals(c.id.value))).write(c);

  Future<void> deleteCircuit(int id) =>
      (delete(hiitCircuits)..where((t) => t.id.equals(id))).go();

  Future<int> countBySession(int sessionId) async {
    final count = hiitCircuits.id.count();
    final query = selectOnly(hiitCircuits)
      ..addColumns([count])
      ..where(hiitCircuits.sessionId.equals(sessionId));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }
}
