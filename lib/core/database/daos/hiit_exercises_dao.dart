import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'hiit_exercises_dao.g.dart';

@DriftAccessor(tables: [HiitExercises])
class HiitExercisesDao extends DatabaseAccessor<AppDatabase>
    with _$HiitExercisesDaoMixin {
  HiitExercisesDao(super.db);

  Stream<List<HiitExercise>> watchByCircuit(int circuitId) =>
      (select(hiitExercises)
            ..where((t) => t.circuitId.equals(circuitId))
            ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
          .watch();

  Future<int> insertExercise(HiitExercisesCompanion c) =>
      into(hiitExercises).insert(c);

  Future<void> updateExercise(HiitExercisesCompanion c) =>
      (update(hiitExercises)..where((t) => t.id.equals(c.id.value))).write(c);

  Future<void> deleteExercise(int id) =>
      (delete(hiitExercises)..where((t) => t.id.equals(id))).go();

  Future<void> reorder(List<int> ids) async {
    await db.transaction(() async {
      for (var i = 0; i < ids.length; i++) {
        await (update(hiitExercises)..where((t) => t.id.equals(ids[i])))
            .write(HiitExercisesCompanion(orderIndex: Value(i)));
      }
    });
  }
}
