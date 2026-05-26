import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout_app/core/database/app_database.dart';
import 'package:workout_app/core/theme/app_theme.dart';
import 'package:workout_app/features/hiit/add_exercise_sheet.dart';
import 'package:workout_app/features/hiit/edit_circuit_sheet.dart';
import 'package:workout_app/features/hiit/providers.dart';
import 'package:workout_app/features/hiit/reorder_exercises_screen.dart';

class CircuitCard extends ConsumerWidget {
  const CircuitCard({super.key, required this.circuit});

  final HiitCircuit circuit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.watch(exercisesByCircuitProvider(circuit.id));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.line),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(circuit: circuit),
          exercisesAsync.when(
            data: (exercises) => _ExerciseList(
              circuit: circuit,
              exercises: exercises,
            ),
            loading: () => const SizedBox(
              height: 48,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),
          _Footer(circuit: circuit),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.circuit});
  final HiitCircuit circuit;

  @override
  Widget build(BuildContext context) {
    final restSec = circuit.restBetweenRoundsSec;
    final restLabel = restSec >= 60
        ? '${restSec ~/ 60}:${(restSec % 60).toString().padLeft(2, '0')} descanso'
        : '${restSec}s descanso';

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF1A2010), AppTheme.bgCard],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _LetterBadge(letter: circuit.letter),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  circuit.name,
                  style: const TextStyle(
                    color: AppTheme.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz, color: AppTheme.textMid),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: AppTheme.bgCard2,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    builder: (_) => EditCircuitSheet(circuit: circuit),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                '${circuit.rounds} rondas',
                style: GoogleFonts.jetBrainsMono(
                  color: AppTheme.hiit,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                restLabel,
                style: GoogleFonts.jetBrainsMono(
                  color: AppTheme.rest,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LetterBadge extends StatelessWidget {
  const _LetterBadge({required this.letter});
  final String letter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppTheme.hiit,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: GoogleFonts.jetBrainsMono(
          color: AppTheme.bg,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ExerciseList extends StatelessWidget {
  const _ExerciseList({required this.circuit, required this.exercises});
  final HiitCircuit circuit;
  final List<HiitExercise> exercises;

  @override
  Widget build(BuildContext context) {
    if (exercises.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        const Divider(height: 1, color: AppTheme.line),
        ...exercises.asMap().entries.map((e) => _ExerciseRow(
              index: e.key,
              exercise: e.value,
              circuit: circuit,
            )),
      ],
    );
  }
}

class _ExerciseRow extends StatelessWidget {
  const _ExerciseRow({
    required this.index,
    required this.exercise,
    required this.circuit,
  });
  final int index;
  final HiitExercise exercise;
  final HiitCircuit circuit;

  @override
  Widget build(BuildContext context) {
    final isTime = exercise.type == 'time';
    final valueLabel = isTime
        ? '${exercise.value ~/ 60}:${(exercise.value % 60).toString().padLeft(2, '0')}'
        : '×${exercise.value}';
    final chipColor = isTime ? AppTheme.restSoft : AppTheme.hiitSoft;
    final textColor = isTime ? AppTheme.rest : AppTheme.hiit;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.line)),
      ),
      child: Row(
        children: [
          _IndexChip(index: index),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              exercise.name,
              style: const TextStyle(color: AppTheme.text, fontSize: 14),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: chipColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              valueLabel,
              style: GoogleFonts.jetBrainsMono(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ReorderExercisesScreen(circuit: circuit),
              ),
            ),
            child: const Icon(
              Icons.drag_handle,
              color: AppTheme.textDim,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _IndexChip extends StatelessWidget {
  const _IndexChip({required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.circuit});
  final HiitCircuit circuit;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.line)),
      ),
      child: TextButton.icon(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: AppTheme.bgCard2,
            shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (_) => AddExerciseSheet(circuit: circuit),
          );
        },
        icon: const Icon(Icons.add, color: AppTheme.hiit, size: 18),
        label: const Text(
          'Ejercicio',
          style: TextStyle(color: AppTheme.hiit, fontSize: 14),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          minimumSize: const Size.fromHeight(44),
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }
}
