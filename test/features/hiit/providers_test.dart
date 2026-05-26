import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_app/core/database/app_database.dart';
import 'package:workout_app/core/database/tables.dart';
import 'package:workout_app/features/hiit/providers.dart';
import 'package:workout_app/providers.dart';

void main() {
  test('circuitsBySessionProvider emits circuits for session', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    addTearDown(() async {
      container.dispose();
      await db.close();
    });

    final sessionId = await db.into(db.workoutSessions).insert(
          WorkoutSessionsCompanion.insert(
            date: DateTime.now(),
            type: const Value('hiit'),
          ),
        );
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

    final result =
        await container.read(circuitsBySessionProvider(sessionId).future);
    expect(result.length, 1);
    expect(result.first.name, 'Circuito A');
  });
}
