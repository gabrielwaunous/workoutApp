// lib/features/week/week_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'day_card.dart';
import 'providers.dart';

class WeekScreen extends ConsumerWidget {
  const WeekScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monday = ref.watch(currentMondayProvider);
    final sessionsAsync = ref.watch(weekSessionsProvider(monday));
    final weekVolAsync = ref.watch(weekVolumeProvider(monday));

    final days = List.generate(7, (i) => monday.add(Duration(days: i)));

    return Column(
      children: [
        // Week navigation
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => ref
                    .read(currentMondayProvider.notifier)
                    .state = monday.subtract(const Duration(days: 7)),
              ),
              Column(
                children: [
                  Text(
                    '${monday.day}/${monday.month} — ${monday.add(const Duration(days: 6)).day}/${monday.add(const Duration(days: 6)).month}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  weekVolAsync.when(
                    data: (v) => Text(
                      'Volumen semanal: ${v.toStringAsFixed(0)}',
                      style: const TextStyle(color: Colors.blue, fontSize: 12),
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => ref
                    .read(currentMondayProvider.notifier)
                    .state = monday.add(const Duration(days: 7)),
              ),
            ],
          ),
        ),
        Expanded(
          child: sessionsAsync.when(
            data: (sessions) => ListView(
              children: days.map((day) {
                final session = sessions.where((s) => _sameDay(s.date, day)).firstOrNull;
                return DayCard(date: day, session: session);
              }).toList(),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
