// lib/core/database/tables.dart
import 'package:drift/drift.dart';

class Routines extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get rawText => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class WorkoutSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get notes => text().nullable()();
  TextColumn get type => text().withDefault(const Constant('strength'))();
}

class HiitCircuits extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(WorkoutSessions, #id)();
  TextColumn get letter => text()();
  TextColumn get name => text()();
  IntColumn get rounds => integer()();
  IntColumn get restBetweenRoundsSec => integer()();
  IntColumn get restBetweenExercisesSec => integer().nullable()();
  IntColumn get orderIndex => integer()();
}

class HiitExercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get circuitId => integer().references(HiitCircuits, #id)();
  TextColumn get name => text()();
  TextColumn get type => text()();
  IntColumn get value => integer()();
  IntColumn get orderIndex => integer()();
}

class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(WorkoutSessions, #id)();
  TextColumn get name => text()();
  IntColumn get orderIndex => integer()();
  IntColumn get restSeconds => integer().nullable()();
  TextColumn get muscleGroup => text().nullable()();
}

@DataClassName('WorkoutSet')
class Sets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get exerciseId => integer().references(Exercises, #id)();
  IntColumn get setNumber => integer()();
  IntColumn get reps => integer().nullable()();
  RealColumn get weight => real().nullable()();
  BoolColumn get toFailure => boolean().withDefault(const Constant(false))();
  BoolColumn get isPartial => boolean().withDefault(const Constant(false))();
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
}

class HiitWorkoutLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(WorkoutSessions, #id)();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
}

class HiitExerciseLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get workoutLogId => integer().references(HiitWorkoutLogs, #id)();
  IntColumn get exerciseId => integer().references(HiitExercises, #id)();
  IntColumn get round => integer()();
  // reps: count tapped; time: exercise.value (always completed fully)
  IntColumn get actualValue => integer()();
  DateTimeColumn get completedAt => dateTime()();
}
