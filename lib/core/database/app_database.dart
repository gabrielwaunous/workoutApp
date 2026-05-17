// lib/core/database/app_database.dart
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

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Routines, WorkoutSessions, Exercises, Sets],
  daos: [RoutinesDao, SessionsDao, ExercisesDao, SetsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 4;

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
