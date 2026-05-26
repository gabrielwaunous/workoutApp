import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import 'package:workout_app/core/database/app_database.dart';
import 'package:workout_app/core/muscle_group_detector.dart';
import 'package:workout_app/core/theme/app_theme.dart';
import 'package:workout_app/features/hiit/hiit_planning_content.dart';
import 'package:workout_app/providers.dart';
import 'exercise_card.dart';
import 'providers.dart';

sealed class _ListItem {}

class _HeaderItem extends _ListItem {
  final String label;
  _HeaderItem(this.label);
}

class _ExerciseItem extends _ListItem {
  final Exercise exercise;
  _ExerciseItem(this.exercise);
}

List<_ListItem> _buildItems(List<Exercise> exercises) {
  final items = <_ListItem>[];
  String? last;
  for (final ex in exercises) {
    final g = ex.muscleGroup ?? 'General';
    if (g != last) {
      items.add(_HeaderItem(g));
      last = g;
    }
    items.add(_ExerciseItem(ex));
  }
  return items;
}

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(todaySessionProvider);

    return sessionAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (session) => TodayContent(session: session),
    );
  }
}

class TodayContent extends ConsumerWidget {
  final WorkoutSession session;

  const TodayContent({required this.session, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _SessionHeader(session: session),
        Expanded(
          child: session.type == 'hiit'
              ? HiitPlanningContent(sessionId: session.id)
              : _StrengthContent(session: session),
        ),
      ],
    );
  }
}

String _formatDate(DateTime d) {
  const days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
  const months = [
    'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
  ];
  return '${days[d.weekday - 1]} ${d.day} ${months[d.month - 1]}';
}

class _SessionHeader extends ConsumerWidget {
  const _SessionHeader({required this.session});
  final WorkoutSession session;

  @override
  Widget build(BuildContext context, WidgetRef widgetRef) {
    final volumeAsync = widgetRef.watch(dailyVolumeProvider(session.id));
    final isHiit = session.type == 'hiit';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _formatDate(session.date),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              if (!isHiit)
                volumeAsync.when(
                  data: (v) => Text(
                    'Vol: ${v.toStringAsFixed(0)}',
                    style: const TextStyle(color: Colors.blue),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: isHiit ? AppTheme.hiit : AppTheme.fuerza,
                ),
                onSelected: (type) async {
                  final db = widgetRef.read(databaseProvider);
                  await db.sessionsDao.updateType(session.id, type);
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'strength',
                    child: Text('Fuerza'),
                  ),
                  PopupMenuItem(
                    value: 'hiit',
                    child: Text('HIIT'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StrengthContent extends ConsumerWidget {
  const _StrengthContent({required this.session});
  final WorkoutSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.watch(exercisesBySessionProvider(session.id));

    return CustomScrollView(
      slivers: [
        exercisesAsync.when(
          data: (exercises) {
            final items = _buildItems(exercises);
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => switch (items[i]) {
                  _HeaderItem(:final label) =>
                    _MuscleGroupHeader(label: label),
                  _ExerciseItem(:final exercise) =>
                    ExerciseCard(exercise: exercise),
                },
                childCount: items.length,
              ),
            );
          },
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
                  muscleGroup: Value(MuscleGroupDetector.detect(name)),
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

class _MuscleGroupHeader extends StatelessWidget {
  final String label;
  const _MuscleGroupHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Divider(
              thickness: 0.5,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }
}
