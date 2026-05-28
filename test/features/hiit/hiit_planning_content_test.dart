import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout_app/core/database/app_database.dart';
import 'package:workout_app/core/theme/app_theme.dart';
import 'package:workout_app/features/hiit/hiit_planning_content.dart';
import 'package:workout_app/providers.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<int> makeHiitSession(AppDatabase db) =>
      db.into(db.workoutSessions).insert(
            WorkoutSessionsCompanion.insert(
              date: DateTime.now(),
              type: const Value('hiit'),
            ),
          );

  testWidgets('Shows empty state when no circuits', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final sessionId = await makeHiitSession(db);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          theme: AppTheme.dark(),
          home: Scaffold(body: HiitPlanningContent(sessionId: sessionId)),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Arrancá tu primer circuito'), findsOneWidget);
    await tester.pump(Duration.zero);
  });

  testWidgets('Shows circuits when they exist', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final sessionId = await makeHiitSession(db);

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

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          theme: AppTheme.dark(),
          home: Scaffold(body: HiitPlanningContent(sessionId: sessionId)),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Circuito A'), findsOneWidget);
    expect(find.text('Agregar circuito'), findsOneWidget);
    await tester.pump(Duration.zero);
  });
}
