// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/today/today_screen.dart';
import 'features/week/week_screen.dart';
import 'features/routines/routines_screen.dart';

class WorkoutApp extends ConsumerWidget {
  const WorkoutApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Workout',
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Workout'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Hoy'),
                Tab(text: 'Semana'),
                Tab(text: 'Rutinas'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              TodayScreen(),
              WeekScreen(),
              RoutinesScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
