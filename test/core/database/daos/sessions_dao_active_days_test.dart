import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_app/core/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  Future<int> makeSession(DateTime date) =>
      db.into(db.workoutSessions).insert(
            WorkoutSessionsCompanion.insert(date: date),
          );

  Future<int> makeExercise(int sessionId) =>
      db.into(db.exercises).insert(
            ExercisesCompanion.insert(
              sessionId: sessionId,
              name: 'Squat',
              orderIndex: 0,
            ),
          );

  Future<void> makeSet(int exerciseId) =>
      db.into(db.sets).insert(
            SetsCompanion.insert(exerciseId: exerciseId, setNumber: 1),
          );

  test('watchStrengthActiveDays returns empty when no sets', () async {
    await makeSession(DateTime(2026, 1, 10));
    final days = await db.sessionsDao.watchStrengthActiveDays().first;
    expect(days, isEmpty);
  });

  test('watchStrengthActiveDays returns date when session has a set', () async {
    final sessionId = await makeSession(DateTime(2026, 1, 10));
    final exId = await makeExercise(sessionId);
    await makeSet(exId);
    final days = await db.sessionsDao.watchStrengthActiveDays().first;
    expect(days, contains(DateTime(2026, 1, 10)));
  });

  test('watchStrengthActiveDays excludes sessions without sets', () async {
    final sessionId = await makeSession(DateTime(2026, 1, 10));
    final exId = await makeExercise(sessionId);
    await makeSet(exId);
    await makeSession(DateTime(2026, 1, 11));
    final days = await db.sessionsDao.watchStrengthActiveDays().first;
    expect(days, {DateTime(2026, 1, 10)});
  });

  test('watchAllSessions returns all sessions', () async {
    await makeSession(DateTime(2026, 1, 10));
    await makeSession(DateTime(2026, 1, 11));
    final sessions = await db.sessionsDao.watchAllSessions().first;
    expect(sessions.length, 2);
  });
}
