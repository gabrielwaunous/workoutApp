// lib/features/today/today_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import '../../core/database/tables.dart';
import '../../providers.dart';
import 'exercise_card.dart';
import 'providers.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(todaySessionProvider);

    return sessionAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (session) => _TodayContent(session: session),
    );
  }
}

class _TodayContent extends ConsumerWidget {
  final WorkoutSession session;

  const _TodayContent({required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.watch(exercisesBySessionProvider(session.id));
    final volumeAsync = ref.watch(dailyVolumeProvider(session.id));

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(session.date),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                volumeAsync.when(
                  data: (v) => Text(
                    'Vol: ${v.toStringAsFixed(0)}',
                    style: const TextStyle(color: Colors.blue),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
        exercisesAsync.when(
          data: (exercises) => SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => ExerciseCard(exercise: exercises[i]),
              childCount: exercises.length,
            ),
          ),
          loading: () => const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => SliverToBoxAdapter(
            child: Center(child: Text('Error: $e')),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton(
              onPressed: () => _addExercise(context, ref, session.id),
              child: const Text('+ Agregar ejercicio'),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime d) {
    const days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    const months = ['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'];
    return '${days[d.weekday - 1]} ${d.day} ${months[d.month - 1]}';
  }

  void _addExercise(BuildContext context, WidgetRef ref, int sessionId) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nuevo ejercicio'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'ej: Sentadillas'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isEmpty) return;
              final db = ref.read(databaseProvider);
              final count = await db.exercisesDao.countBySession(sessionId);
              await db.exercisesDao.insertExercise(
                ExercisesCompanion(
                  sessionId: Value(sessionId),
                  name: Value(name),
                  orderIndex: Value(count),
                ),
              );
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }
}
