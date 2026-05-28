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

bool _isRest(HiitWorkoutState s) =>
    s.phase == WorkoutPhase.exerciseRest ||
    s.phase == WorkoutPhase.roundRest;

int _completedRoundsFor(HiitWorkoutState s) {
  if (s.phase == WorkoutPhase.roundRest) return s.round;
  return s.round - 1;
}

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
                s.currentCircuit.name,
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
          _RoundProgressBar(
            totalRounds: s.currentCircuit.rounds,
            completedRounds: _completedRoundsFor(s),
          ),
          Expanded(
            child: _isRest(s)
                ? _RestPhaseBody(s: s)
                : _WorkPhaseBody(s: s),
          ),
          _ActionBar(s: s, notifier: notifier),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _RoundProgressBar extends StatelessWidget {
  const _RoundProgressBar({
    required this.totalRounds,
    required this.completedRounds,
  });
  final int totalRounds;
  final int completedRounds;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 14),
      child: Row(
        children: List.generate(totalRounds, (i) {
          final isDone = i < completedRounds;
          final isCurrent = i == completedRounds;
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: isDone
                    ? AppTheme.hiit
                    : isCurrent
                        ? AppTheme.hiit.withValues(alpha: 0.5)
                        : AppTheme.bgChip,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _WorkPhaseBody extends StatelessWidget {
  const _WorkPhaseBody({required this.s});
  final HiitWorkoutState s;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'TRABAJO',
              style: GoogleFonts.jetBrainsMono(
                color: AppTheme.hiit,
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
              color: AppTheme.hiit,
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
    );
  }
}

class _RestPhaseBody extends StatelessWidget {
  const _RestPhaseBody({required this.s});
  final HiitWorkoutState s;

  @override
  Widget build(BuildContext context) {
    final isRoundRest = s.phase == WorkoutPhase.roundRest;
    final label = isRoundRest
        ? 'DESCANSO · RONDA ${s.round}/${s.currentCircuit.rounds}'
        : 'DESCANSO · SIGUIENTE EJERCICIO';

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.jetBrainsMono(
                color: AppTheme.rest,
                fontSize: 11,
                letterSpacing: 0.12 * 11,
              ),
            ),
            const SizedBox(height: 16),
            WorkoutTimerDisplay(
              phase: s.phase,
              remainingSeconds: s.remainingSeconds,
              isTimeExercise: s.isTimeExercise,
              plannedValue: s.currentExercise.value,
              color: AppTheme.rest,
            ),
            const SizedBox(height: 32),
            if (isRoundRest)
              _NextRoundPreview(s: s)
            else
              _NextExercisePreview(s: s),
          ],
        ),
      ),
    );
  }
}

class _NextRoundPreview extends StatelessWidget {
  const _NextRoundPreview({required this.s});
  final HiitWorkoutState s;

  @override
  Widget build(BuildContext context) {
    final nextRound = s.round + 1;
    final exercises = s.currentExercises;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SIGUE · VUELTA $nextRound DE ${s.currentCircuit.rounds}',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppTheme.rest,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 10),
          ...exercises.map((ex) {
            final valueStr = ex.type == 'time'
                ? '${ex.value}s'
                : '×${ex.value}';
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      ex.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.text,
                      ),
                    ),
                  ),
                  Text(
                    valueStr,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textMid,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _NextExercisePreview extends StatelessWidget {
  const _NextExercisePreview({required this.s});
  final HiitWorkoutState s;

  @override
  Widget build(BuildContext context) {
    final exercises = s.currentExercises;
    final nextIndex = s.exerciseIndex + 1;
    if (nextIndex >= exercises.length) return const SizedBox.shrink();

    final next = exercises[nextIndex];
    final valueStr = next.type == 'time' ? '${next.value}s' : '×${next.value}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SIGUIENTE',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppTheme.rest,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  next.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.text,
                  ),
                ),
              ),
              Text(
                valueStr,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textMid,
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
    final isRest = _isRest(s);

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
            )
          else if (isRest)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => notifier.addRestSeconds(30),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.rest,
                      side: const BorderSide(color: AppTheme.rest),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      '+30s',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: notifier.skip,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.rest,
                      foregroundColor: AppTheme.bg,
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
            )
          else if (s.phase != WorkoutPhase.done)
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
                child: const Text(
                  'SALTAR →',
                  style: TextStyle(
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
