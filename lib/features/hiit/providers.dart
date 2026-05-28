import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_app/core/database/app_database.dart';
import 'package:workout_app/providers.dart';

final circuitsBySessionProvider =
    StreamProvider.family<List<HiitCircuit>, int>((ref, sessionId) {
  return ref
      .read(databaseProvider)
      .hiitCircuitsDao
      .watchBySession(sessionId);
});

final exercisesByCircuitProvider =
    StreamProvider.family<List<HiitExercise>, int>((ref, circuitId) {
  return ref
      .read(databaseProvider)
      .hiitExercisesDao
      .watchByCircuit(circuitId);
});
