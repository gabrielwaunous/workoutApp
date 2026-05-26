import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_app/core/database/app_database.dart';

void main() {
  late AppDatabase db;
  late int sessionId;
  late int circuitId;
  late int exerciseId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    sessionId = await db.into(db.workoutSessions).insert(
          WorkoutSessionsCompanion.insert(
            date: DateTime.now(),
            type: const Value('hiit'),
          ),
        );
    circuitId = await db.hiitCircuitsDao.insertCircuit(
      HiitCircuitsCompanion.insert(
        sessionId: sessionId,
        letter: 'A',
        name: 'A',
        rounds: 3,
        restBetweenRoundsSec: 60,
        orderIndex: 0,
      ),
    );
    exerciseId = await db.hiitExercisesDao.insertExercise(
      HiitExercisesCompanion.insert(
        circuitId: circuitId,
        name: 'Burpees',
        type: 'reps',
        value: 10,
        orderIndex: 0,
      ),
    );
  });

  tearDown(() => db.close());

  test('createLog returns an id and log is watchable', () async {
    final logId = await db.hiitWorkoutLogsDao.createLog(sessionId);
    expect(logId, greaterThan(0));
    final logs =
        await db.hiitWorkoutLogsDao.watchLogsForSession(sessionId).first;
    expect(logs.length, 1);
    expect(logs.first.id, logId);
    expect(logs.first.completedAt, isNull);
  });

  test('completeLog sets completedAt', () async {
    final logId = await db.hiitWorkoutLogsDao.createLog(sessionId);
    await db.hiitWorkoutLogsDao.completeLog(logId);
    final logs =
        await db.hiitWorkoutLogsDao.watchLogsForSession(sessionId).first;
    expect(logs.first.completedAt, isNotNull);
  });

  test('logExercise persists exercise result', () async {
    final logId = await db.hiitWorkoutLogsDao.createLog(sessionId);
    await db.hiitWorkoutLogsDao.logExercise(logId, exerciseId, 1, 10);
    final exLogs =
        await db.hiitWorkoutLogsDao.getExerciseLogsForWorkout(logId);
    expect(exLogs.length, 1);
    expect(exLogs.first.exerciseId, exerciseId);
    expect(exLogs.first.round, 1);
    expect(exLogs.first.actualValue, 10);
  });

  test('multiple exercise logs per workout', () async {
    final logId = await db.hiitWorkoutLogsDao.createLog(sessionId);
    await db.hiitWorkoutLogsDao.logExercise(logId, exerciseId, 1, 10);
    await db.hiitWorkoutLogsDao.logExercise(logId, exerciseId, 2, 10);
    await db.hiitWorkoutLogsDao.logExercise(logId, exerciseId, 3, 10);
    final exLogs =
        await db.hiitWorkoutLogsDao.getExerciseLogsForWorkout(logId);
    expect(exLogs.length, 3);
  });

  test('watchHiitActiveDays returns empty when no completed logs exist',
      () async {
    // Create a log but don't complete it
    await db.hiitWorkoutLogsDao.createLog(sessionId);

    final activeDays =
        await db.hiitWorkoutLogsDao.watchHiitActiveDays().first;

    expect(activeDays.isEmpty, true);
  });

  test('watchHiitActiveDays returns session date when log is completed',
      () async {
    final now = DateTime.now();
    final normalizedDate = DateTime(now.year, now.month, now.day);

    // Create and complete a log
    final logId = await db.hiitWorkoutLogsDao.createLog(sessionId);
    await db.hiitWorkoutLogsDao.completeLog(logId);

    final activeDays =
        await db.hiitWorkoutLogsDao.watchHiitActiveDays().first;

    expect(activeDays.length, 1);
    expect(activeDays.first, normalizedDate);
  });
}
