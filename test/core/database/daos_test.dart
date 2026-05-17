// test/core/database/daos_test.dart
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:workout_app/core/database/app_database.dart';
import 'package:workout_app/core/database/tables.dart';

AppDatabase _inMemory() => AppDatabase.forTesting(NativeDatabase.memory());

void main() {
  late AppDatabase db;

  setUp(() => db = _inMemory());
  tearDown(() => db.close());

  group('SessionsDao', () {
    test('getByDate returns null when no session exists', () async {
      final result = await db.sessionsDao.getByDate(DateTime(2026, 5, 17));
      expect(result, isNull);
    });

    test('insertSession normalises to midnight and getByDate finds it', () async {
      await db.sessionsDao.insertSession(
        WorkoutSessionsCompanion(date: Value(DateTime(2026, 5, 17, 14, 30))),
      );
      final result = await db.sessionsDao.getByDate(DateTime(2026, 5, 17));
      expect(result, isNotNull);
      expect(result!.date, equals(DateTime(2026, 5, 17)));
    });

    test('watchWeek emits only sessions in range', () async {
      await db.sessionsDao.insertSession(
        WorkoutSessionsCompanion(date: Value(DateTime(2026, 5, 11))),
      );
      await db.sessionsDao.insertSession(
        WorkoutSessionsCompanion(date: Value(DateTime(2026, 5, 17))),
      );
      await db.sessionsDao.insertSession(
        WorkoutSessionsCompanion(date: Value(DateTime(2026, 5, 18))),
      );
      final week = await db.sessionsDao.getWeek(DateTime(2026, 5, 11));
      expect(week.length, 2);
    });
  });

  group('ExercisesDao + SetsDao', () {
    test('insert exercise and watch by session', () async {
      final sid = await db.sessionsDao.insertSession(
        WorkoutSessionsCompanion(date: Value(DateTime(2026, 5, 17))),
      );
      await db.exercisesDao.insertExercise(
        ExercisesCompanion(
          sessionId: Value(sid),
          name: const Value('Sentadillas'),
          orderIndex: const Value(0),
        ),
      );
      final exercises = await db.exercisesDao
          .watchBySession(sid)
          .first;
      expect(exercises.length, 1);
      expect(exercises.first.name, 'Sentadillas');
    });

    test('updateWeight persists and is retrieved', () async {
      final sid = await db.sessionsDao.insertSession(
        WorkoutSessionsCompanion(date: Value(DateTime(2026, 5, 17))),
      );
      final eid = await db.exercisesDao.insertExercise(
        ExercisesCompanion(
          sessionId: Value(sid),
          name: const Value('Press plano'),
          orderIndex: const Value(0),
        ),
      );
      final setId = await db.setsDao.insertSet(
        SetsCompanion(
          exerciseId: Value(eid),
          setNumber: const Value(1),
          reps: const Value(8),
        ),
      );
      await db.setsDao.updateWeight(setId, 60.0);
      final result = await db.setsDao.getByExercise(eid);
      expect(result.first.weight, 60.0);
    });

    test('watchBySession returns sets across all exercises', () async {
      final sid = await db.sessionsDao.insertSession(
        WorkoutSessionsCompanion(date: Value(DateTime(2026, 5, 17))),
      );
      final eid1 = await db.exercisesDao.insertExercise(
        ExercisesCompanion(sessionId: Value(sid), name: const Value('A'), orderIndex: const Value(0)),
      );
      final eid2 = await db.exercisesDao.insertExercise(
        ExercisesCompanion(sessionId: Value(sid), name: const Value('B'), orderIndex: const Value(1)),
      );
      await db.setsDao.insertSet(
        SetsCompanion(exerciseId: Value(eid1), setNumber: const Value(1), reps: const Value(10)),
      );
      await db.setsDao.insertSet(
        SetsCompanion(exerciseId: Value(eid2), setNumber: const Value(1), reps: const Value(8)),
      );
      final allSets = await db.setsDao.getBySession(sid);
      expect(allSets.length, 2);
    });
  });
}
