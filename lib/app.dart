import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/today/today_screen.dart';
import 'features/calendar/calendar_screen.dart';
import 'features/routines/routines_screen.dart';

class WorkoutApp extends ConsumerWidget {
  const WorkoutApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Workout',
      theme: AppTheme.dark(),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Workout'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Hoy'),
                Tab(text: 'Calendario'),
                Tab(text: 'Rutinas'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              TodayScreen(),
              CalendarScreen(),
              RoutinesScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
