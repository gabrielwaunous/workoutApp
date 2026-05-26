import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout_app/core/theme/app_theme.dart';
import 'package:workout_app/features/hiit/workout/hiit_workout_notifier.dart';
import 'package:workout_app/features/hiit/workout/hiit_workout_provider.dart';
import 'package:workout_app/features/hiit/workout/hiit_workout_state.dart';
import 'package:workout_app/features/hiit/workout/workout_done_screen.dart';
import 'package:workout_app/features/hiit/workout/workout_exercise_card.dart';
import 'package:workout_app/features/hiit/workout/workout_timer_display.dart';

class HiitWorkoutScreen extends ConsumerStatefulWidget {
  const HiitWorkoutScreen({super.key, required this.sessionId});
  final int sessionId;

  @override
  ConsumerState<HiitWorkoutScreen> createState() =>
      _HiitWorkoutScreenState();
}

class _HiitWorkoutScreenState extends ConsumerState<HiitWorkoutScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref
          .read(hiitWorkoutProvider(widget.sessionId).notifier)
          .start(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(hiitWorkoutProvider(widget.sessionId));
    final notifier =
        ref.read(hiitWorkoutProvider(widget.sessionId).notifier);

    if (s.phase == WorkoutPhase.done) {
      return WorkoutDoneScreen(workoutState: s);
    }

    if (!s.isLoaded) {
      return const Scaffold(
        backgroundColor: AppTheme.bg,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isWork = s.phase == WorkoutPhase.exerciseWork;
    final phaseColor = isWork ? AppTheme.hiit : AppTheme.rest;
    final phaseLabel = switch (s.phase) {
      WorkoutPhase.exerciseWork => 'TRABAJO',
      WorkoutPhase.exerciseRest => 'DESCANSO',
      WorkoutPhase.roundRest =>
        'DESCANSO · RONDA ${s.round}/${s.currentCircuit.rounds}',
      WorkoutPhase.done => '',
    };

    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppTheme.textMid),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            _LetterBadge(letter: s.currentCircuit.letter),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${s.currentCircuit.name} · Ronda ${s.round}/${s.currentCircuit.rounds}',
                style: const TextStyle(color: AppTheme.text, fontSize: 15),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              s.isPaused ? Icons.play_arrow : Icons.pause,
              color: AppTheme.textMid,
            ),
            onPressed: s.isPaused ? notifier.resume : notifier.pause,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      phaseLabel,
                      style: GoogleFonts.jetBrainsMono(
                        color: phaseColor,
                        fontSize: 11,
                        letterSpacing: 0.12 * 11,
                      ),
                    ),
                    const SizedBox(height: 12),
                    WorkoutTimerDisplay(
                      phase: s.phase,
                      remainingSeconds: s.remainingSeconds,
                      isTimeExercise: s.isTimeExercise,
                      plannedValue: s.currentExercise.value,
                      color: phaseColor,
                    ),
                    const SizedBox(height: 28),
                    WorkoutExerciseCard(workoutState: s),
                    const SizedBox(height: 28),
                    _ExerciseDots(
                      total: s.currentExercises.length,
                      current: s.exerciseIndex,
                    ),
                  ],
                ),
              ),
            ),
          ),
          _ActionBar(s: s, notifier: notifier),
          const SizedBox(height: 32),
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
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: AppTheme.hiit,
        borderRadius: BorderRadius.circular(7),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: GoogleFonts.jetBrainsMono(
          color: AppTheme.bg,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ExerciseDots extends StatelessWidget {
  const _ExerciseDots({required this.total, required this.current});
  final int total;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final active = i == current;
        final done = i < current;
        return Container(
          width: active ? 10 : 8,
          height: active ? 10 : 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done
                ? AppTheme.hiit.withValues(alpha: 0.5)
                : active
                    ? AppTheme.hiit
                    : AppTheme.bgChip,
          ),
        );
      }),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.s, required this.notifier});
  final HiitWorkoutState s;
  final HiitWorkoutNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final showTap =
        s.phase == WorkoutPhase.exerciseWork && !s.isTimeExercise;
    final showSkip = !showTap && s.phase != WorkoutPhase.done;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          if (showTap)
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: notifier.tap,
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.hiit,
                  foregroundColor: AppTheme.bg,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'LISTO ✓',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          if (showSkip)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: notifier.skip,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.textMid,
                  side: const BorderSide(color: AppTheme.lineStrong),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  s.phase == WorkoutPhase.roundRest
                      ? 'SALTAR DESCANSO'
                      : 'SALTAR →',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
