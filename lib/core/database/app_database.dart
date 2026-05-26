import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables.dart';
import 'daos/routines_dao.dart';
import 'daos/sessions_dao.dart';
import 'daos/exercises_dao.dart';
import 'daos/sets_dao.dart';
import 'daos/hiit_circuits_dao.dart';
import 'daos/hiit_exercises_dao.dart';
import 'daos/hiit_workout_logs_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Routines, WorkoutSessions, Exercises, Sets,
    HiitCircuits, HiitExercises,
    HiitWorkoutLogs, HiitExerciseLogs,
  ],
  daos: [
    RoutinesDao, SessionsDao, ExercisesDao, SetsDao,
    HiitCircuitsDao, HiitExercisesDao,
    HiitWorkoutLogsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(exercises, exercises.restSeconds);
      }
      if (from < 3) {
        await m.addColumn(sets, sets.isDone);
      }
      if (from < 4) {
        await m.addColumn(exercises, exercises.muscleGroup);
      }
      if (from < 5) {
        await m.addColumn(workoutSessions, workoutSessions.type);
        await m.createTable(hiitCircuits);
        await m.createTable(hiitExercises);
      }
      if (from < 6) {
        await m.createTable(hiitWorkoutLogs);
        await m.createTable(hiitExerciseLogs);
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'workout.db'));
    return NativeDatabase(file);
  });
}
