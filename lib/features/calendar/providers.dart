import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_app/core/database/app_database.dart';
import 'package:workout_app/providers.dart';

final _hiitActiveDaysProvider = StreamProvider<Set<DateTime>>(
  (ref) => ref.read(databaseProvider).hiitWorkoutLogsDao.watchHiitActiveDays(),
);

final _strengthActiveDaysProvider = StreamProvider<Set<DateTime>>(
  (ref) =>
      ref.read(databaseProvider).sessionsDao.watchStrengthActiveDays(),
);

/// All dates with completed work — HIIT completed logs ∪ strength sessions with ≥1 set.
final activeDaysProvider = Provider<Set<DateTime>>((ref) {
  final hiit = ref.watch(_hiitActiveDaysProvider).valueOrNull ?? {};
  final strength = ref.watch(_strengthActiveDaysProvider).valueOrNull ?? {};
  return {...hiit, ...strength};
});

/// Consecutive days ending today with completed work.
final streakProvider = Provider<int>((ref) {
  final activeDays = ref.watch(activeDaysProvider);
  int streak = 0;
  var day = DateTime.now();
  day = DateTime(day.year, day.month, day.day);
  while (activeDays.contains(day)) {
    streak++;
    day = day.subtract(const Duration(days: 1));
  }
  return streak;
});

/// Most recent active day strictly before today, or null if none.
final lastActiveDayProvider = Provider<DateTime?>((ref) {
  final activeDays = ref.watch(activeDaysProvider);
  if (activeDays.isEmpty) return null;
  final today = DateTime.now();
  final todayNorm = DateTime(today.year, today.month, today.day);
  final past = activeDays.where((d) => d.isBefore(todayNorm)).toList()
    ..sort((a, b) => b.compareTo(a));
  return past.isEmpty ? null : past.first;
});

/// All sessions keyed by normalized date (midnight) — used by calendar.
final sessionsByDayProvider = StreamProvider<Map<DateTime, WorkoutSession>>(
  (ref) => ref
      .read(databaseProvider)
      .sessionsDao
      .watchAllSessions()
      .map((sessions) => {
            for (final s in sessions)
              DateTime(s.date.year, s.date.month, s.date.day): s,
          }),
);

/// Stream of total strength volume per session ID (all sessions combined).
final volumeBySessionProvider = StreamProvider<Map<int, double>>(
  (ref) => ref.read(databaseProvider).setsDao.watchVolumeBySession(),
);

/// Volume per normalized date — derived from volumeBySession + sessionsByDay.
final volumeByDayProvider = Provider<Map<DateTime, double>>((ref) {
  final bySession = ref.watch(volumeBySessionProvider).valueOrNull ?? {};
  final byDay = ref.watch(sessionsByDayProvider).valueOrNull ?? {};
  return {
    for (final entry in byDay.entries)
      if (bySession.containsKey(entry.value.id))
        entry.key: bySession[entry.value.id]!,
  };
});
