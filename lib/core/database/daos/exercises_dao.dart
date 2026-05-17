// lib/core/database/daos/exercises_dao.dart
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'exercises_dao.g.dart';

@DriftAccessor(tables: [Exercises])
class ExercisesDao extends DatabaseAccessor<AppDatabase>
    with _$ExercisesDaoMixin {
  ExercisesDao(super.db);

  Stream<List<Exercise>> watchBySession(int sessionId) =>
      (select(exercises)
            ..where((t) => t.sessionId.equals(sessionId))
            ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
          .watch();

  Future<int> insertExercise(ExercisesCompanion exercise) =>
      into(exercises).insert(exercise);

  Future<void> deleteExercise(int id) =>
      (delete(exercises)..where((t) => t.id.equals(id))).go();

  Future<int> countBySession(int sessionId) async {
    final count = exercises.id.count();
    final q = selectOnly(exercises)
      ..addColumns([count])
      ..where(exercises.sessionId.equals(sessionId));
    final row = await q.getSingle();
    return row.read(count)!;
  }
}
