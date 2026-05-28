import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout_app/core/database/app_database.dart';
import 'package:workout_app/core/theme/app_theme.dart';
import 'package:workout_app/features/hiit/providers.dart';
import 'package:workout_app/providers.dart';

class ReorderExercisesScreen extends ConsumerWidget {
  const ReorderExercisesScreen({super.key, required this.circuit});
  final HiitCircuit circuit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.watch(exercisesByCircuitProvider(circuit.id));

    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.bgElev,
        title: Text(
          'Reordenar ejercicios',
          style: GoogleFonts.spaceGrotesk(color: AppTheme.text, fontSize: 17),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Listo',
              style: TextStyle(
                color: AppTheme.hiit,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: exercisesAsync.when(
        data: (exercises) => Column(
          children: [
            Expanded(
              child: ReorderableListView.builder(
                onReorderItem: (oldIndex, newIndex) async {
                  final reordered = [...exercises];
                  final item = reordered.removeAt(oldIndex);
                  reordered.insert(newIndex, item);
                  await ref
                      .read(databaseProvider)
                      .hiitExercisesDao
                      .reorder(reordered.map((e) => e.id).toList());
                },
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final ex = exercises[index];
                  final isTime = ex.type == 'time';
                  final valueLabel = isTime
                      ? '${ex.value ~/ 60}:${(ex.value % 60).toString().padLeft(2, '0')}'
                      : '×${ex.value}';
                  final chipColor =
                      isTime ? AppTheme.restSoft : AppTheme.hiitSoft;
                  final textColor = isTime ? AppTheme.rest : AppTheme.hiit;

                  return ListTile(
                    key: ValueKey(ex.id),
                    tileColor: AppTheme.bgCard,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    leading: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppTheme.bgChip,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${index + 1}',
                        style: GoogleFonts.jetBrainsMono(
                          color: AppTheme.textMid,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    title: Text(
                      ex.name,
                      style: const TextStyle(
                        color: AppTheme.text,
                        fontSize: 14,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: chipColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            valueLabel,
                            style: GoogleFonts.jetBrainsMono(
                              color: textColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.drag_handle, color: AppTheme.hiit),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.bgCard2,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.line),
              ),
              child: const Text(
                'El orden aplica a todas las rondas del circuito.',
                style: TextStyle(color: AppTheme.textMid, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }
}
