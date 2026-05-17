// lib/features/today/exercise_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/volume.dart';
import '../../providers.dart';
import 'providers.dart';
import 'set_row.dart';

String _formatRest(int seconds) {
  final m = seconds ~/ 60;
  final s = seconds % 60;
  if (m == 0) return '${s}s descanso';
  return s == 0 ? '${m}min descanso' : '${m}m ${s}s descanso';
}

class ExerciseCard extends ConsumerWidget {
  final Exercise exercise;

  const ExerciseCard({required this.exercise, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setsAsync = ref.watch(setsByExerciseProvider(exercise.id));
    final sets = setsAsync.valueOrNull;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    exercise.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                if (sets != null)
                  Text(
                    '${calculateExerciseVolume(sets).toStringAsFixed(0)} vol',
                    style: const TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18),
                  color: Colors.red[300],
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Eliminar ejercicio'),
                        content: Text('¿Eliminar "${exercise.name}"?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text('Eliminar'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      final db = ref.read(databaseProvider);
                      await db.setsDao.deleteByExercise(exercise.id);
                      await db.exercisesDao.deleteExercise(exercise.id);
                    }
                  },
                ),
              ],
            ),
          ),
          if (exercise.restSeconds != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
              child: Text(
                '⏱ ${_formatRest(exercise.restSeconds!)}',
                style: TextStyle(color: Colors.orange[300], fontSize: 11),
              ),
            ),
          if (sets != null)
            Column(children: sets.map((s) => SetRow(set: s)).toList())
          else if (setsAsync.isLoading)
            const Padding(
              padding: EdgeInsets.all(12),
              child: LinearProgressIndicator(),
            )
          else if (setsAsync.hasError)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text('Error: ${setsAsync.error}'),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
