import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout_app/core/theme/app_theme.dart';
import 'package:workout_app/features/hiit/workout/hiit_workout_state.dart';

class WorkoutExerciseCard extends StatelessWidget {
  const WorkoutExerciseCard({super.key, required this.workoutState});
  final HiitWorkoutState workoutState;

  @override
  Widget build(BuildContext context) {
    if (!workoutState.isLoaded) return const SizedBox.shrink();

    final phase = workoutState.phase;
    final isRest = phase == WorkoutPhase.exerciseRest ||
        phase == WorkoutPhase.roundRest;

    if (isRest) {
      return _RestLabel(workoutState: workoutState);
    }

    final ex = workoutState.currentExercise;
    final isTime = ex.type == 'time';
    final valueLabel = isTime
        ? '${ex.value ~/ 60}:${(ex.value % 60).toString().padLeft(2, '0')}'
        : '×${ex.value}';

    return Column(
      children: [
        Text(
          ex.name,
          style: const TextStyle(
            color: AppTheme.text,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          '$valueLabel · planificado',
          style: const TextStyle(color: AppTheme.textMid, fontSize: 14),
        ),
      ],
    );
  }
}

class _RestLabel extends StatelessWidget {
  const _RestLabel({required this.workoutState});
  final HiitWorkoutState workoutState;

  @override
  Widget build(BuildContext context) {
    final isRoundRest = workoutState.phase == WorkoutPhase.roundRest;
    final nextRound = workoutState.round + 1;
    final nextEx = workoutState.currentExercises[0];

    return Column(
      children: [
        Text(
          isRoundRest
              ? 'Siguiente ronda $nextRound'
              : 'Siguiente ejercicio',
          style: const TextStyle(color: AppTheme.textMid, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          nextEx.name,
          style: GoogleFonts.jetBrainsMono(
            color: AppTheme.rest,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
