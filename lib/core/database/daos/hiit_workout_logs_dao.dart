import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'hiit_workout_logs_dao.g.dart';

@DriftAccessor(tables: [HiitWorkoutLogs, HiitExerciseLogs])
class HiitWorkoutLogsDao extends DatabaseAccessor<AppDatabase>
    with _$HiitWorkoutLogsDaoMixin {
  HiitWorkoutLogsDao(super.db);
}
