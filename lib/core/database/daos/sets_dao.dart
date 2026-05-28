// lib/core/database/daos/sets_dao.dart
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'sets_dao.g.dart';

@DriftAccessor(tables: [Sets, Exercises])
class SetsDao extends DatabaseAccessor<AppDatabase> with _$SetsDaoMixin {
  SetsDao(super.db);

  Stream<List<WorkoutSet>> watchByExercise(int exerciseId) =>
      (select(sets)
            ..where((t) => t.exerciseId.equals(exerciseId))
            ..orderBy([(t) => OrderingTerm.asc(t.setNumber)]))
          .watch();

  Future<List<WorkoutSet>> getByExercise(int exerciseId) =>
      (select(sets)
            ..where((t) => t.exerciseId.equals(exerciseId))
            ..orderBy([(t) => OrderingTerm.asc(t.setNumber)]))
          .get();

  Future<int> insertSet(SetsCompanion set) => into(sets).insert(set);

  Future<void> updateWeight(int setId, double? weight) =>
      (update(sets)..where((t) => t.id.equals(setId)))
          .write(SetsCompanion(weight: Value(weight)));

  Future<void> updateReps(int setId, int? reps, bool toFailure) =>
      (update(sets)..where((t) => t.id.equals(setId)))
          .write(SetsCompanion(reps: Value(reps), toFailure: Value(toFailure)));

  // Returns all sets belonging to exercises in a session (for volume calc)
  Future<List<WorkoutSet>> getBySession(int sessionId) async {
    final query = select(sets).join([
      innerJoin(exercises, exercises.id.equalsExp(sets.exerciseId)),
    ])..where(exercises.sessionId.equals(sessionId));
    final rows = await query.get();
    return rows.map((r) => r.readTable(sets)).toList();
  }

  Stream<List<WorkoutSet>> watchBySession(int sessionId) {
    final query = select(sets).join([
      innerJoin(exercises, exercises.id.equalsExp(sets.exerciseId)),
    ])..where(exercises.sessionId.equals(sessionId));
    return query
        .watch()
        .map((rows) => rows.map((r) => r.readTable(sets)).toList());
  }

  Future<void> toggleDone(int setId, bool done) =>
      (update(sets)..where((t) => t.id.equals(setId)))
          .write(SetsCompanion(isDone: Value(done)));

  Future<void> deleteByExercise(int exerciseId) =>
      (delete(sets)..where((t) => t.exerciseId.equals(exerciseId))).go();

  Stream<Map<int, double>> watchVolumeBySession() {
    final query = select(sets).join([
      innerJoin(exercises, exercises.id.equalsExp(sets.exerciseId)),
    ]);
    return query.watch().map((rows) {
      final volumes = <int, double>{};
      for (final row in rows) {
        final s = row.readTable(sets);
        final ex = row.readTable(exercises);
        if (!s.toFailure && s.reps != null) {
          final vol = s.weight != null
              ? s.reps!.toDouble() * s.weight!
              : s.reps!.toDouble();
          volumes[ex.sessionId] = (volumes[ex.sessionId] ?? 0) + vol;
        }
      }
      return volumes;
    });
  }
}
