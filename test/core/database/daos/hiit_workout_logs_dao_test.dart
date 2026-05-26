import 'package:drift/drift.dart';
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
}
