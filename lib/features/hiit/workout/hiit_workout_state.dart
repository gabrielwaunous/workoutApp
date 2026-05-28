import 'package:workout_app/core/database/app_database.dart';

enum WorkoutPhase { exerciseWork, exerciseRest, roundRest, done }

class HiitWorkoutState {
  const HiitWorkoutState({
    required this.circuits,
    required this.exercisesByCircuit,
    required this.circuitIndex,
    required this.exerciseIndex,
    required this.round,
    required this.phase,
    required this.remainingSeconds,
    required this.isPaused,
    required this.workoutLogId,
    required this.startedAt,
  });

  final List<HiitCircuit> circuits;
  final Map<int, List<HiitExercise>> exercisesByCircuit;
  final int circuitIndex;
  final int exerciseIndex;
  final int round;
  final WorkoutPhase phase;
  final int remainingSeconds;
  final bool isPaused;
  final int workoutLogId;
  final DateTime startedAt;

  static HiitWorkoutState loading() => HiitWorkoutState(
        circuits: const [],
        exercisesByCircuit: const {},
        circuitIndex: 0,
        exerciseIndex: 0,
        round: 1,
        phase: WorkoutPhase.exerciseWork,
        remainingSeconds: 0,
        isPaused: false,
        workoutLogId: 0,
        startedAt: DateTime.now(),
      );

  HiitCircuit get currentCircuit => circuits[circuitIndex];
  List<HiitExercise> get currentExercises =>
      exercisesByCircuit[currentCircuit.id]!;
  HiitExercise get currentExercise => currentExercises[exerciseIndex];
  bool get isTimeExercise => currentExercise.type == 'time';
  bool get isLoaded => circuits.isNotEmpty;

  HiitWorkoutState copyWith({
    int? circuitIndex,
    int? exerciseIndex,
    int? round,
    WorkoutPhase? phase,
    int? remainingSeconds,
    bool? isPaused,
  }) =>
      HiitWorkoutState(
        circuits: circuits,
        exercisesByCircuit: exercisesByCircuit,
        circuitIndex: circuitIndex ?? this.circuitIndex,
        exerciseIndex: exerciseIndex ?? this.exerciseIndex,
        round: round ?? this.round,
        phase: phase ?? this.phase,
        remainingSeconds: remainingSeconds ?? this.remainingSeconds,
        isPaused: isPaused ?? this.isPaused,
        workoutLogId: workoutLogId,
        startedAt: startedAt,
      );
}
