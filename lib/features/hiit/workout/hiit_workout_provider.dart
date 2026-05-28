import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_app/providers.dart';
import 'hiit_workout_notifier.dart';
import 'hiit_workout_state.dart';

final hiitWorkoutProvider = StateNotifierProvider.autoDispose
    .family<HiitWorkoutNotifier, HiitWorkoutState, int>(
  (ref, sessionId) => HiitWorkoutNotifier(
    sessionId: sessionId,
    db: ref.read(databaseProvider),
  ),
);
