import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import 'package:workout_app/core/database/app_database.dart';
import 'package:workout_app/core/muscle_group_detector.dart';
import 'package:workout_app/core/theme/app_theme.dart';
import 'package:workout_app/features/hiit/hiit_planning_content.dart';
import 'package:workout_app/features/home/session_hero_card.dart';
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
        SessionHeroCard(session: session),
        Expanded(
          child: session.type == 'hiit'
              ? HiitPlanningContent(sessionId: session.id)
              : _StrengthContent(session: session),
        ),
      ],
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
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: GestureDetector(
              onTap: () => _addExercise(context, ref, session.id),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.fuerza),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: AppTheme.fuerza, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Agregar ejercicio',
                      style: TextStyle(
                        color: AppTheme.fuerza,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
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
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: AppTheme.fuerza,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Divider(
              thickness: 0.5,
              color: Color(0x446BA8FF),
            ),
          ),
        ],
      ),
    );
  }
}
