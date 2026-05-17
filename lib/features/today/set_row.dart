// lib/features/today/set_row.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../providers.dart';

class SetRow extends ConsumerWidget {
  final WorkoutSet set;

  const SetRow({required this.set, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final done = set.isDone;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          GestureDetector(
            onTap: () =>
                ref.read(databaseProvider).setsDao.toggleDone(set.id, !done),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: done ? Colors.green[700] : Colors.grey[850],
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: done ? Colors.green[400]! : Colors.grey[600]!,
                  width: 1.5,
                ),
              ),
              child: done
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : Center(
                      child: Text(
                        '${set.setNumber}',
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 11),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _chip(
              set.toFailure ? 'fallo' : '${set.reps} reps',
              done ? Colors.green[900]! : Colors.grey[850]!,
              done ? Colors.green[200]! : Colors.white70,
              strikethrough: done,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => _weightDialog(context, ref),
              child: _chip(
                set.weight != null ? '${set.weight} kg' : '+ peso',
                set.weight != null
                    ? (done ? Colors.green[900]! : Colors.blue[900]!)
                    : Colors.grey[850]!,
                set.weight != null
                    ? (done ? Colors.green[200]! : Colors.lightBlue)
                    : Colors.grey[600]!,
                strikethrough: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text, Color bg, Color fg,
          {required bool strikethrough}) =>
      Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: fg,
            fontSize: 13,
            decoration: strikethrough ? TextDecoration.lineThrough : null,
            decorationColor: fg,
          ),
        ),
      );

  void _weightDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(
      text: set.weight != null ? set.weight.toString() : '',
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Set ${set.setNumber} — Peso (kg)'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
          decoration: const InputDecoration(hintText: 'ej: 60'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final w = double.tryParse(controller.text.trim());
              ref.read(databaseProvider).setsDao.updateWeight(set.id, w);
              Navigator.pop(ctx);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
