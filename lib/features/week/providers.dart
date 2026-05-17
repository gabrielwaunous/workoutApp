// lib/features/week/providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/volume.dart';
import '../../providers.dart';

// Monday of a given date's week
DateTime mondayOf(DateTime date) =>
    DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: date.weekday - 1));

final currentMondayProvider = StateProvider<DateTime>(
  (_) => mondayOf(DateTime.now()),
);

final weekSessionsProvider =
    StreamProvider.family<List<WorkoutSession>, DateTime>((ref, monday) {
  return ref.watch(databaseProvider).sessionsDao.watchWeek(monday);
});

final sessionVolumeProvider =
    FutureProvider.family<double, int>((ref, sessionId) async {
  final sets = await ref.watch(databaseProvider).setsDao.getBySession(sessionId);
  return calculateExerciseVolume(sets);
});

final weekVolumeProvider =
    FutureProvider.family<double, DateTime>((ref, monday) async {
  final sessions = await ref.watch(databaseProvider).sessionsDao.getWeek(monday);
  double total = 0;
  for (final s in sessions) {
    final sets = await ref.watch(databaseProvider).setsDao.getBySession(s.id);
    total += calculateExerciseVolume(sets);
  }
  return total;
});
