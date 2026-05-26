import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_app/core/database/app_database.dart';

void main() {
  test('HiitWorkoutLogsDao exists', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    expect(db.hiitWorkoutLogsDao, isNotNull);
  });
}
