// lib/features/today/exercise_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/tables.dart';
import '../../core/volume.dart';
import 'providers.dart';
import 'set_row.dart';

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
                Text(
                  exercise.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                if (sets != null)
                  Text(
                    '${calculateExerciseVolume(sets).toStringAsFixed(0)} vol',
                    style: const TextStyle(color: Colors.blue, fontSize: 12),
                  ),
              ],
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
