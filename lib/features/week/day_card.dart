// lib/features/week/day_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import 'day_detail_screen.dart';
import 'providers.dart';

class DayCard extends ConsumerWidget {
  final DateTime date;
  final WorkoutSession? session;

  const DayCard({required this.date, this.session, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    final label = days[date.weekday - 1];
    final isToday = _sameDay(date, DateTime.now());

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      color: isToday ? Colors.blue[900] : null,
      child: ListTile(
        leading: CircleAvatar(
          child: Text(label, style: const TextStyle(fontSize: 12)),
        ),
        title: Text('${date.day}/${date.month}'),
        subtitle: session != null
            ? _VolumeText(sessionId: session!.id)
            : const Text('Sin entrenamiento', style: TextStyle(color: Colors.grey)),
        trailing: const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DayDetailScreen(date: date)),
        ),
      ),
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _VolumeText extends ConsumerWidget {
  final int sessionId;
  const _VolumeText({required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final volAsync = ref.watch(sessionVolumeProvider(sessionId));
    return volAsync.when(
      data: (v) => Text('Vol: ${v.toStringAsFixed(0)}'),
      loading: () => const Text('...'),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
