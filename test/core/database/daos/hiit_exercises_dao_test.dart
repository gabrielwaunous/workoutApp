import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_app/core/database/app_database.dart';
import 'package:workout_app/core/database/tables.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('HiitExercisesDao', () {
    Future<int> makeCircuit() async {
      final sessionId = await db.into(db.workoutSessions).insert(
            WorkoutSessionsCompanion.insert(
              date: DateTime.now(),
              type: const Value('hiit'),
            ),
          );
      return db.hiitCircuitsDao.insertCircuit(
        HiitCircuitsCompanion.insert(
          sessionId: sessionId,
          letter: 'A',
          name: 'A',
          rounds: 3,
          restBetweenRoundsSec: 60,
          orderIndex: 0,
        ),
      );
    }

    test('insert and watchByCircuit', () async {
      final circuitId = await makeCircuit();
      await db.hiitExercisesDao.insertExercise(
        HiitExercisesCompanion.insert(
          circuitId: circuitId,
          name: 'Burpees',
          type: 'reps',
          value: 10,
          orderIndex: 0,
        ),
      );
      final exercises =
          await db.hiitExercisesDao.watchByCircuit(circuitId).first;
      expect(exercises.length, 1);
      expect(exercises.first.name, 'Burpees');
    });

    test('deleteExercise removes it', () async {
      final circuitId = await makeCircuit();
      final id = await db.hiitExercisesDao.insertExercise(
        HiitExercisesCompanion.insert(
          circuitId: circuitId,
          name: 'Burpees',
          type: 'reps',
          value: 10,
          orderIndex: 0,
        ),
      );
      await db.hiitExercisesDao.deleteExercise(id);
      final exercises =
          await db.hiitExercisesDao.watchByCircuit(circuitId).first;
      expect(exercises, isEmpty);
    });

    test('reorder updates orderIndex', () async {
      final circuitId = await makeCircuit();
      final id1 = await db.hiitExercisesDao.insertExercise(
        HiitExercisesCompanion.insert(
          circuitId: circuitId,
          name: 'A',
          type: 'reps',
          value: 8,
          orderIndex: 0,
        ),
      );
      final id2 = await db.hiitExercisesDao.insertExercise(
        HiitExercisesCompanion.insert(
          circuitId: circuitId,
          name: 'B',
          type: 'time',
          value: 30,
          orderIndex: 1,
        ),
      );
      await db.hiitExercisesDao.reorder([id2, id1]);
      final exercises =
          await db.hiitExercisesDao.watchByCircuit(circuitId).first;
      expect(exercises.first.id, id2);
      expect(exercises.last.id, id1);
    });
  });
}
