import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_app/core/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('HiitCircuitsDao', () {
    Future<int> makeSession() => db.into(db.workoutSessions).insert(
          WorkoutSessionsCompanion.insert(
            date: DateTime.now(),
            type: const Value('hiit'),
          ),
        );

    test('insert and watchBySession', () async {
      final sessionId = await makeSession();
      await db.hiitCircuitsDao.insertCircuit(
        HiitCircuitsCompanion.insert(
          sessionId: sessionId,
          letter: 'A',
          name: 'Circuito A',
          rounds: 3,
          restBetweenRoundsSec: 90,
          orderIndex: 0,
        ),
      );
      final circuits =
          await db.hiitCircuitsDao.watchBySession(sessionId).first;
      expect(circuits.length, 1);
      expect(circuits.first.name, 'Circuito A');
    });

    test('countBySession returns correct count', () async {
      final sessionId = await makeSession();
      expect(await db.hiitCircuitsDao.countBySession(sessionId), 0);
      await db.hiitCircuitsDao.insertCircuit(
        HiitCircuitsCompanion.insert(
          sessionId: sessionId,
          letter: 'A',
          name: 'A',
          rounds: 3,
          restBetweenRoundsSec: 60,
          orderIndex: 0,
        ),
      );
      expect(await db.hiitCircuitsDao.countBySession(sessionId), 1);
    });

    test('deleteCircuit removes it', () async {
      final sessionId = await makeSession();
      final id = await db.hiitCircuitsDao.insertCircuit(
        HiitCircuitsCompanion.insert(
          sessionId: sessionId,
          letter: 'A',
          name: 'A',
          rounds: 3,
          restBetweenRoundsSec: 60,
          orderIndex: 0,
        ),
      );
      await db.hiitCircuitsDao.deleteCircuit(id);
      final circuits =
          await db.hiitCircuitsDao.watchBySession(sessionId).first;
      expect(circuits, isEmpty);
    });

    test('updateCircuit persists changes', () async {
      final sessionId = await makeSession();
      final id = await db.hiitCircuitsDao.insertCircuit(
        HiitCircuitsCompanion.insert(
          sessionId: sessionId,
          letter: 'A',
          name: 'Old',
          rounds: 3,
          restBetweenRoundsSec: 60,
          orderIndex: 0,
        ),
      );
      await db.hiitCircuitsDao.updateCircuit(
        HiitCircuitsCompanion(
          id: Value(id),
          name: const Value('New'),
          rounds: const Value(4),
        ),
      );
      final circuits =
          await db.hiitCircuitsDao.watchBySession(sessionId).first;
      expect(circuits.first.name, 'New');
      expect(circuits.first.rounds, 4);
    });
  });
}
