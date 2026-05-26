import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout_app/core/database/app_database.dart';
import 'package:workout_app/core/theme/app_theme.dart';
import 'package:workout_app/features/hiit/circuit_card.dart';
import 'package:workout_app/providers.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('CircuitCard shows circuit letter and name', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

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
        name: 'Power Circuit',
        rounds: 3,
        restBetweenRoundsSec: 90,
        orderIndex: 0,
      ),
    );
    final circuits =
        await db.hiitCircuitsDao.watchBySession(sessionId).first;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          theme: AppTheme.dark(),
          home: Scaffold(body: CircuitCard(circuit: circuits.first)),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('A'), findsWidgets);
    expect(find.text('Power Circuit'), findsOneWidget);
    expect(find.text('3 rondas'), findsOneWidget);
    await tester.pump(Duration.zero);
  });

  testWidgets('CircuitCard shows exercise names', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    final sessionId = await db.into(db.workoutSessions).insert(
          WorkoutSessionsCompanion.insert(
            date: DateTime.now(),
            type: const Value('hiit'),
          ),
        );
    final circuitId = await db.hiitCircuitsDao.insertCircuit(
      HiitCircuitsCompanion.insert(
        sessionId: sessionId,
        letter: 'A',
        name: 'A',
        rounds: 3,
        restBetweenRoundsSec: 60,
        orderIndex: 0,
      ),
    );
    await db.hiitExercisesDao.insertExercise(
      HiitExercisesCompanion.insert(
        circuitId: circuitId,
        name: 'Burpees',
        type: 'reps',
        value: 10,
        orderIndex: 0,
      ),
    );
    final circuits =
        await db.hiitCircuitsDao.watchBySession(sessionId).first;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          theme: AppTheme.dark(),
          home: Scaffold(body: CircuitCard(circuit: circuits.first)),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Burpees'), findsOneWidget);
    await tester.pump(Duration.zero);
  });
}
