import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:workout_app/core/database/app_database.dart';
import 'hiit_workout_state.dart';

class HiitWorkoutNotifier extends StateNotifier<HiitWorkoutState> {
  HiitWorkoutNotifier({required this.sessionId, required this.db})
      : _player = AudioPlayer(),
        super(HiitWorkoutState.loading());

  final int sessionId;
  final AppDatabase db;
  final AudioPlayer _player;
  Timer? _timer;

  Future<void> start() async {
    final circuits =
        await db.hiitCircuitsDao.watchBySession(sessionId).first;
    if (circuits.isEmpty) return;

    final Map<int, List<HiitExercise>> byCircuit = {};
    for (final c in circuits) {
      byCircuit[c.id] =
          await db.hiitExercisesDao.watchByCircuit(c.id).first;
    }

    final logId = await db.hiitWorkoutLogsDao.createLog(sessionId);
    final first = byCircuit[circuits[0].id]![0];

    state = HiitWorkoutState(
      circuits: circuits,
      exercisesByCircuit: byCircuit,
      circuitIndex: 0,
      exerciseIndex: 0,
      round: 1,
      phase: WorkoutPhase.exerciseWork,
      remainingSeconds: _seconds(first),
      isPaused: false,
      workoutLogId: logId,
      startedAt: DateTime.now(),
    );

    await WakelockPlus.enable();
    _startTimer();
  }

  void tap() {
    if (!state.isLoaded) return;
    if (state.phase != WorkoutPhase.exerciseWork) return;
    if (state.isTimeExercise) return;
    _logAndAdvance();
  }

  void skip() {
    if (!state.isLoaded) return;
    if (state.phase == WorkoutPhase.exerciseWork && !state.isTimeExercise) {
      return;
    }
    if (state.phase == WorkoutPhase.done) return;
    if (state.phase == WorkoutPhase.exerciseWork) {
      _logAndAdvance();
    } else {
      _advance();
    }
  }

  void addRestSeconds(int n) {
    if (state.phase == WorkoutPhase.exerciseRest ||
        state.phase == WorkoutPhase.roundRest) {
      state = state.copyWith(remainingSeconds: state.remainingSeconds + n);
    }
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(isPaused: true);
  }

  void resume() {
    state = state.copyWith(isPaused: false);
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (!state.isLoaded) return;
    if (state.isPaused) return;
    if (state.phase == WorkoutPhase.done) return;
    if (state.phase == WorkoutPhase.exerciseWork && !state.isTimeExercise) {
      return;
    }

    final remaining = state.remainingSeconds - 1;

    if (remaining > 0 && remaining <= 3) {
      _player.play(AssetSource('sounds/beep_short.wav'));
      HapticFeedback.lightImpact();
    }

    if (remaining <= 0) {
      if (state.phase == WorkoutPhase.exerciseWork) {
        _logAndAdvance();
      } else {
        _advance();
      }
    } else {
      state = state.copyWith(remainingSeconds: remaining);
    }
  }

  void _logAndAdvance() {
    final s = state;
    db.hiitWorkoutLogsDao
        .logExercise(
          s.workoutLogId,
          s.currentExercise.id,
          s.round,
          s.currentExercise.value,
        )
        .ignore();

    _player.play(AssetSource('sounds/beep_long.wav'));
    HapticFeedback.mediumImpact();

    _advance();
  }

  void _advance() {
    final s = state;
    final circuit = s.currentCircuit;
    final exercises = s.currentExercises;
    final isLastExercise = s.exerciseIndex == exercises.length - 1;
    final isLastRound = s.round == circuit.rounds;
    final isLastCircuit = s.circuitIndex == s.circuits.length - 1;
    final hasExRest = circuit.restBetweenExercisesSec != null &&
        circuit.restBetweenExercisesSec! > 0 &&
        !isLastExercise;

    switch (s.phase) {
      case WorkoutPhase.exerciseWork:
        if (hasExRest) {
          state = s.copyWith(
            phase: WorkoutPhase.exerciseRest,
            remainingSeconds: circuit.restBetweenExercisesSec!,
          );
        } else if (!isLastExercise) {
          final next = exercises[s.exerciseIndex + 1];
          state = s.copyWith(
            phase: WorkoutPhase.exerciseWork,
            exerciseIndex: s.exerciseIndex + 1,
            remainingSeconds: _seconds(next),
          );
        } else if (!isLastRound) {
          state = s.copyWith(
            phase: WorkoutPhase.roundRest,
            remainingSeconds: circuit.restBetweenRoundsSec,
          );
        } else if (!isLastCircuit) {
          final nextCircuit = s.circuits[s.circuitIndex + 1];
          final nextExercises = s.exercisesByCircuit[nextCircuit.id]!;
          state = HiitWorkoutState(
            circuits: s.circuits,
            exercisesByCircuit: s.exercisesByCircuit,
            circuitIndex: s.circuitIndex + 1,
            exerciseIndex: 0,
            round: 1,
            phase: WorkoutPhase.exerciseWork,
            remainingSeconds: _seconds(nextExercises[0]),
            isPaused: false,
            workoutLogId: s.workoutLogId,
            startedAt: s.startedAt,
          );
        } else {
          _completeDone().ignore();
        }
        break;

      case WorkoutPhase.exerciseRest:
        final next = exercises[s.exerciseIndex + 1];
        state = s.copyWith(
          phase: WorkoutPhase.exerciseWork,
          exerciseIndex: s.exerciseIndex + 1,
          remainingSeconds: _seconds(next),
        );
        break;

      case WorkoutPhase.roundRest:
        state = s.copyWith(
          phase: WorkoutPhase.exerciseWork,
          exerciseIndex: 0,
          round: s.round + 1,
          remainingSeconds: _seconds(exercises[0]),
        );
        break;

      case WorkoutPhase.done:
        break;
    }
  }

  Future<void> _completeDone() async {
    _timer?.cancel();
    state = state.copyWith(phase: WorkoutPhase.done);
    await db.hiitWorkoutLogsDao.completeLog(state.workoutLogId);
    await WakelockPlus.disable();
    HapticFeedback.heavyImpact();
    await _player.play(AssetSource('sounds/beep_long.wav'));
  }

  int _seconds(HiitExercise ex) => ex.type == 'time' ? ex.value : 0;

  @override
  void dispose() {
    _timer?.cancel();
    _player.dispose();
    WakelockPlus.disable().ignore();
    super.dispose();
  }
}
