import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'sessions_dao.g.dart';

@DriftAccessor(tables: [WorkoutSessions, Exercises, Sets])
class SessionsDao extends DatabaseAccessor<AppDatabase>
    with _$SessionsDaoMixin {
  SessionsDao(super.db);

  Future<WorkoutSession?> getByDate(DateTime date) {
    final dayOnly = DateTime(date.year, date.month, date.day);
    return (select(workoutSessions)
          ..where((t) => t.date.equals(dayOnly)))
        .getSingleOrNull();
  }

  Future<int> insertSession(WorkoutSessionsCompanion session) {
    final d = session.date.value;
    final dayOnly = DateTime(d.year, d.month, d.day);
    return into(workoutSessions)
        .insert(session.copyWith(date: Value(dayOnly)));
  }

  Stream<List<WorkoutSession>> watchWeek(DateTime monday) {
    final start = DateTime(monday.year, monday.month, monday.day);
    final end = start.add(const Duration(days: 7));
    return (select(workoutSessions)
          ..where((t) =>
              t.date.isBiggerOrEqualValue(start) &
              t.date.isSmallerThanValue(end)))
        .watch();
  }

  Future<List<WorkoutSession>> getWeek(DateTime monday) {
    final start = DateTime(monday.year, monday.month, monday.day);
    final end = start.add(const Duration(days: 7));
    return (select(workoutSessions)
          ..where((t) =>
              t.date.isBiggerOrEqualValue(start) &
              t.date.isSmallerThanValue(end)))
        .get();
  }

  Future<WorkoutSession> getOrCreateForDate(DateTime date) async {
    final existing = await getByDate(date);
    if (existing != null) return existing;
    await insertSession(WorkoutSessionsCompanion(date: Value(date)));
    return (await getByDate(date))!;
  }

  Future<void> updateType(int id, String type) =>
      (update(workoutSessions)..where((t) => t.id.equals(id)))
          .write(WorkoutSessionsCompanion(type: Value(type)));

  Stream<List<WorkoutSession>> watchAllSessions() =>
      select(workoutSessions).watch();

  Stream<Set<DateTime>> watchStrengthActiveDays() {
    final q = select(workoutSessions)
      ..where((s) => s.id.isInQuery(
          selectOnly(exercises)
            ..addColumns([exercises.sessionId])
            ..where(exercises.id.isInQuery(
                selectOnly(sets)..addColumns([sets.exerciseId])))));
    return q
        .map((s) => DateTime(s.date.year, s.date.month, s.date.day))
        .watch()
        .map((list) => list.toSet());
  }
}
