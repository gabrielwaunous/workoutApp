// lib/features/today/exercise_card.dart
import 'package:drift/drift.dart' show Value;
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

  Future<void> _showAddSetDialog(
      BuildContext context, WidgetRef ref, int currentCount) async {
    final result = await showDialog<SetsCompanion>(
      context: context,
      builder: (_) => _AddSetDialog(
        exerciseId: exercise.id,
        setNumber: currentCount + 1,
      ),
    );
    if (result == null) return;
    await ref.read(databaseProvider).setsDao.insertSet(result);
  }

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
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: TextButton.icon(
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Serie'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                visualDensity: VisualDensity.compact,
              ),
              onPressed: () => _showAddSetDialog(context, ref, sets?.length ?? 0),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddSetDialog extends StatefulWidget {
  final int exerciseId;
  final int setNumber;

  const _AddSetDialog({required this.exerciseId, required this.setNumber});

  @override
  State<_AddSetDialog> createState() => _AddSetDialogState();
}

class _AddSetDialogState extends State<_AddSetDialog> {
  final _repsCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  bool _toFailure = false;

  @override
  void dispose() {
    _repsCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  void _confirm() {
    final reps = int.tryParse(_repsCtrl.text.trim());
    final weight = double.tryParse(_weightCtrl.text.trim());
    Navigator.pop(
      context,
      SetsCompanion(
        exerciseId: Value(widget.exerciseId),
        setNumber: Value(widget.setNumber),
        reps: Value(_toFailure ? null : reps),
        weight: Value(weight),
        toFailure: Value(_toFailure),
        isPartial: const Value(false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Serie ${widget.setNumber}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _repsCtrl,
                  enabled: !_toFailure,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Reps'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _weightCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Peso (kg)'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Checkbox(
                value: _toFailure,
                onChanged: (v) => setState(() => _toFailure = v ?? false),
              ),
              const Text('Al fallo'),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: _confirm,
          child: const Text('Agregar'),
        ),
      ],
    );
  }
}
