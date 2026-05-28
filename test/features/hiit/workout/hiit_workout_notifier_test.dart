import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_app/core/database/app_database.dart';
import 'package:workout_app/features/hiit/workout/hiit_workout_notifier.dart';
import 'package:workout_app/features/hiit/workout/hiit_workout_state.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Mock wakelock_plus (v1.6+ uses Pigeon, not MethodChannel)
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(
      'dev.flutter.pigeon.wakelock_plus_platform_interface.WakelockPlusApi.toggle',
      (_) async => const StandardMessageCodec().encodeMessage([null]),
    );
    // Mock audioplayers global
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers'),
      (_) async => 1,
    );
    // Mock audioplayers per-player channel (player id = 'default')
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers/events/default'),
      (_) async => null,
    );
  });

  late AppDatabase db;
  late int sessionId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    sessionId = await db.into(db.workoutSessions).insert(
          WorkoutSessionsCompanion.insert(
            date: DateTime.now(),
            type: const Value('hiit'),
          ),
        );
  });

  tearDown(() => db.close());

  Future<({int circuitId, int ex1Id, int ex2Id})> makeCircuit({
    int rounds = 2,
    int restBetweenRoundsSec = 60,
    int? restBetweenExercisesSec,
    String ex1Type = 'reps',
    String ex2Type = 'reps',
  }) async {
    final circuitId = await db.hiitCircuitsDao.insertCircuit(
      HiitCircuitsCompanion.insert(
        sessionId: sessionId,
        letter: 'A',
        name: 'A',
        rounds: rounds,
        restBetweenRoundsSec: restBetweenRoundsSec,
        restBetweenExercisesSec: restBetweenExercisesSec == null
            ? const Value.absent()
            : Value(restBetweenExercisesSec),
        orderIndex: 0,
      ),
    );
    final ex1Id = await db.hiitExercisesDao.insertExercise(
      HiitExercisesCompanion.insert(
        circuitId: circuitId,
        name: 'Ex1',
        type: ex1Type,
        value: ex1Type == 'time' ? 30 : 10,
        orderIndex: 0,
      ),
    );
    final ex2Id = await db.hiitExercisesDao.insertExercise(
      HiitExercisesCompanion.insert(
        circuitId: circuitId,
        name: 'Ex2',
        type: ex2Type,
        value: ex2Type == 'time' ? 20 : 12,
        orderIndex: 1,
      ),
    );
    return (circuitId: circuitId, ex1Id: ex1Id, ex2Id: ex2Id);
  }

  Future<HiitWorkoutNotifier> startNotifier() async {
    final n = HiitWorkoutNotifier(sessionId: sessionId, db: db);
    await n.start();
    return n;
  }

  test('start() loads circuits and sets exerciseWork phase', () async {
    await makeCircuit();
    final n = await startNotifier();
    expect(n.state.isLoaded, isTrue);
    expect(n.state.phase, WorkoutPhase.exerciseWork);
    expect(n.state.round, 1);
    expect(n.state.exerciseIndex, 0);
    n.dispose();
  });

  test('tap() on reps exercise advances to next exercise', () async {
    await makeCircuit();
    final n = await startNotifier();
    n.tap();
    expect(n.state.exerciseIndex, 1);
    expect(n.state.phase, WorkoutPhase.exerciseWork);
    n.dispose();
  });

  test('tap() on last reps exercise in round triggers roundRest', () async {
    await makeCircuit(rounds: 2);
    final n = await startNotifier();
    n.tap();
    n.tap();
    expect(n.state.phase, WorkoutPhase.roundRest);
    expect(n.state.remainingSeconds, 60);
    n.dispose();
  });

  test('skip() during roundRest advances to round 2 exercise 0', () async {
    await makeCircuit(rounds: 2);
    final n = await startNotifier();
    n.tap();
    n.tap();
    n.skip();
    expect(n.state.phase, WorkoutPhase.exerciseWork);
    expect(n.state.round, 2);
    expect(n.state.exerciseIndex, 0);
    n.dispose();
  });

  test('tap() on last exercise last round sets done', () async {
    await makeCircuit(rounds: 1);
    final n = await startNotifier();
    n.tap();
    n.tap();
    expect(n.state.phase, WorkoutPhase.done);
    n.dispose();
  });

  test('exerciseRest phase inserted when restBetweenExercisesSec set', () async {
    await makeCircuit(restBetweenExercisesSec: 15);
    final n = await startNotifier();
    n.tap();
    expect(n.state.phase, WorkoutPhase.exerciseRest);
    expect(n.state.remainingSeconds, 15);
    n.dispose();
  });

  test('skip() during exerciseRest advances to next exercise', () async {
    await makeCircuit(restBetweenExercisesSec: 15);
    final n = await startNotifier();
    n.tap();
    n.skip();
    expect(n.state.phase, WorkoutPhase.exerciseWork);
    expect(n.state.exerciseIndex, 1);
    n.dispose();
  });

  test('tap() ignored for time exercises', () async {
    await makeCircuit(ex1Type: 'time');
    final n = await startNotifier();
    final before = n.state.exerciseIndex;
    n.tap();
    expect(n.state.exerciseIndex, before);
    n.dispose();
  });

  test('pause() and resume() toggle isPaused', () async {
    await makeCircuit();
    final n = await startNotifier();
    n.pause();
    expect(n.state.isPaused, isTrue);
    n.resume();
    expect(n.state.isPaused, isFalse);
    n.dispose();
  });
}
