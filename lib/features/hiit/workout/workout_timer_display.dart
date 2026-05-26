import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout_app/features/hiit/workout/hiit_workout_state.dart';

class WorkoutTimerDisplay extends StatelessWidget {
  const WorkoutTimerDisplay({
    super.key,
    required this.phase,
    required this.remainingSeconds,
    required this.isTimeExercise,
    required this.plannedValue,
    required this.color,
  });

  final WorkoutPhase phase;
  final int remainingSeconds;
  final bool isTimeExercise;
  final int plannedValue;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final showCountdown = phase == WorkoutPhase.exerciseRest ||
        phase == WorkoutPhase.roundRest ||
        (phase == WorkoutPhase.exerciseWork && isTimeExercise);

    final label = showCountdown
        ? _formatSeconds(remainingSeconds)
        : '×$plannedValue';

    return Text(
      label,
      style: GoogleFonts.jetBrainsMono(
        color: color,
        fontSize: 80,
        fontWeight: FontWeight.w700,
        height: 1,
      ),
    );
  }

  String _formatSeconds(int s) {
    final m = s ~/ 60;
    final sec = (s % 60).toString().padLeft(2, '0');
    return '$m:$sec';
  }
}
