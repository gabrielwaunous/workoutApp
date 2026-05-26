# HIIT Phase 2 — Active Workout Design Spec
**Date:** 2026-05-25
**Scope:** HIIT active workout — timers, reps tap, rest countdown, exercise logging
**Depends on:** Phase 1 (HiitCircuits, HiitExercises, AppTheme)

---

## Context

Flutter app (`workout_app/`) with Riverpod + Drift, schemaVersion 5. Phase 1 delivered circuit planning. Phase 2 adds the "run a workout" experience: a full-screen active session that progresses through circuits, exercises, and rounds with timers and feedback.

Stack: Flutter ^3.11.5, flutter_riverpod ^2.6.1, drift ^2.22.0.
Target: Android, Galaxy S25 Ultra.

---

## Decisions

| Question | Answer |
|---|---|
| Progression for `time` exercises | Auto-advance when countdown hits 0 |
| Progression for `reps` exercises | Wait for user tap ("Listo") |
| Rest between rounds | Countdown + skip button |
| Persist results | Yes — actual reps/time per exercise per round |
| Feedback | Haptic (`HapticFeedback.mediumImpact`) + audio (local assets) |
| Screen awake | Yes — `wakelock_plus` active during workout |
| Timer architecture | Riverpod `StateNotifier` with internal `Timer.periodic` |

---

## Block 1 — New Packages

Add to `pubspec.yaml`:
```yaml
dependencies:
  wakelock_plus: ^1.1.5
  audioplayers: ^6.0.0

flutter:
  assets:
    - assets/sounds/
```

Add audio assets:
- `assets/sounds/beep_short.mp3` — played each second of 3-2-1 countdown
- `assets/sounds/beep_long.mp3` — played on phase transition (exercise → rest, rest → exercise)

---

## Block 2 — DB Schema (schemaVersion 6)

### New tables

```dart
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
  IntColumn get actualValue => integer()(); // reps completed OR seconds elapsed
  DateTimeColumn get completedAt => dateTime()();
}
```

### Migration

```dart
if (from < 6) {
  await m.createTable(hiitWorkoutLogs);
  await m.createTable(hiitExerciseLogs);
}
```

### `HiitWorkoutLogsDao`

```dart
@DriftAccessor(tables: [HiitWorkoutLogs, HiitExerciseLogs])
class HiitWorkoutLogsDao extends DatabaseAccessor<AppDatabase>
    with _$HiitWorkoutLogsDaoMixin {
  Future<int> createLog(int sessionId);           // inserts log, returns id
  Future<void> completeLog(int logId);            // sets completedAt = now
  Future<void> logExercise(int workoutLogId, int exerciseId, int round, int actualValue);
  Stream<List<HiitWorkoutLog>> watchLogsForSession(int sessionId);
}
```

---

## Block 3 — State Machine

### `WorkoutPhase` enum

```dart
enum WorkoutPhase { exerciseWork, exerciseRest, roundRest, done }
```

### Transitions

```
exerciseWork
  time → countdown hits 0 or skip()  → exerciseRest (if restBetweenExercisesSec set and not last)
                                      → roundRest (if last exercise in round, not last round)
                                      → done (if last exercise, last round)
  reps → tap()                        → same as time above

exerciseRest → countdown hits 0 or skip() → exerciseWork (next exercise)

roundRest → countdown hits 0 or skip() → exerciseWork (exercise 0, next round)

done → terminal
```

### `HiitWorkoutState`

```dart
class HiitWorkoutState {
  final List<HiitCircuit> circuits;
  final Map<int, List<HiitExercise>> exercisesByCircuit; // keyed by circuitId
  final int circuitIndex;    // index into circuits list
  final int exerciseIndex;   // index into current circuit's exercises
  final int round;           // 1-based, up to circuit.rounds
  final WorkoutPhase phase;
  final int remainingSeconds; // active during time/rest phases; 0 for reps
  final bool isPaused;
  final int workoutLogId;
}
```

Convenience getters on state:
- `currentCircuit` → `circuits[circuitIndex]`
- `currentExercises` → `exercisesByCircuit[currentCircuit.id]!`
- `currentExercise` → `currentExercises[exerciseIndex]`
- `isTimeExercise` → `currentExercise.type == 'time'`

### `HiitWorkoutNotifier`

```dart
class HiitWorkoutNotifier extends StateNotifier<HiitWorkoutState> {
  Timer? _timer;
  final AudioPlayer _player;

  // Public API
  void start();           // creates DB log, starts timer, sets phase = exerciseWork
  void tap();             // reps exercise: log result, advance
  void skip();            // skip rest or time exercise early
  void pause();           // cancel timer, set isPaused = true
  void resume();          // restart timer, set isPaused = false

  // Internal
  void _tick();           // decrements remainingSeconds; fires audio on 3/2/1; transitions at 0
  void _advance();        // computes next circuitIndex/exerciseIndex/round/phase
  Future<void> _logCurrentExercise(int actualValue);
}
```

Provider definition:
```dart
final hiitWorkoutProvider = StateNotifierProvider.autoDispose
    .family<HiitWorkoutNotifier, HiitWorkoutState, int>(
  (ref, sessionId) => HiitWorkoutNotifier(
    sessionId: sessionId,
    db: ref.read(databaseProvider),
  ),
);
```

`.autoDispose` — notifier and timer destroyed when screen pops.

---

## Block 4 — Screens & Widgets

### File map

| Action | Path | Responsibility |
|---|---|---|
| Create | `lib/features/hiit/workout/hiit_workout_state.dart` | State model + WorkoutPhase enum |
| Create | `lib/features/hiit/workout/hiit_workout_notifier.dart` | StateNotifier + timer logic |
| Create | `lib/features/hiit/workout/hiit_workout_provider.dart` | Provider definition |
| Create | `lib/features/hiit/workout/hiit_workout_screen.dart` | Full-screen workout UI |
| Create | `lib/features/hiit/workout/workout_timer_display.dart` | Large countdown widget |
| Create | `lib/features/hiit/workout/workout_exercise_card.dart` | Current exercise info card |
| Create | `lib/features/hiit/workout/workout_done_screen.dart` | Summary screen after completion |
| Modify | `lib/features/hiit/hiit_planning_content.dart` | Add "▶ Iniciar" button |
| Modify | `lib/core/database/tables.dart` | Add HiitWorkoutLogs, HiitExerciseLogs |
| Modify | `lib/core/database/app_database.dart` | schemaVersion 6, migration, DAO wiring |
| Create | `lib/core/database/daos/hiit_workout_logs_dao.dart` | DAO |
| Modify | `pubspec.yaml` | Add wakelock_plus, audioplayers, assets |
| Create | `assets/sounds/beep_short.mp3` | 1-second countdown beep |
| Create | `assets/sounds/beep_long.mp3` | Phase transition tone |
| Create | `test/features/hiit/workout/hiit_workout_notifier_test.dart` | State machine unit tests |
| Create | `test/core/database/daos/hiit_workout_logs_dao_test.dart` | DAO integration tests |

### `HiitWorkoutScreen` layout

```
┌─────────────────────────────────┐
│ [A] Circuito A · Ronda 1/3  [⏸] │  AppBar — letter badge + round info + pause
├─────────────────────────────────┤
│                                 │
│  TRABAJO                        │  eyebrow label — hiit lime (work) / rest orange (rest)
│                                 │
│         00:30                   │  JetBrains Mono 80px — lime (work) / orange (rest)
│                                 │  reps exercises: shows planned value, no countdown
│      Burpees                    │  exercise name 22px
│      ×10  ·  planificado        │  planned value, textMid 14px
│                                 │
│    ● ● ○ ○                      │  exercise progress dots within circuit
│                                 │
├─────────────────────────────────┤
│  [       LISTO ✓      ]         │  reps only — lime FilledButton
│  [      SALTAR →      ]         │  time/rest — outline button, textMid
└─────────────────────────────────┘
```

During `roundRest`:
- Countdown in orange
- Label: "DESCANSO · RONDA X/Y"
- Below countdown: "Siguiente → [exercise name]"
- Button: "SALTAR DESCANSO"

### `WorkoutDoneScreen` layout

- Large "✓" icon in lime
- "¡Circuito completado!" heading
- Stats row: total time, rounds done, exercises done
- Scrollable list: each exercise with planned value vs actual value (green if met/exceeded, orange if under)
- "Volver" button → `Navigator.pop()`

### Visual rules

- Work phases: `AppTheme.hiit` (#B8FF45)
- Rest phases: `AppTheme.rest` (#FF9A52)
- Numbers: `GoogleFonts.jetBrainsMono()`
- Background: `AppTheme.bg` full-screen (no scaffold surface)
- Screen awake: `WakeLock.enable()` on `start()`, `WakeLock.disable()` on `done` or screen pop

### Audio + Haptic

- Seconds 3, 2, 1 of any countdown: `beep_short.mp3` + `HapticFeedback.lightImpact()`
- Phase transition (work → rest, rest → work): `beep_long.mp3` + `HapticFeedback.mediumImpact()`
- Workout done: `beep_long.mp3` × 2 + `HapticFeedback.heavyImpact()`

---

## Out of Scope (Phase 2)

- Background audio / notification while screen off — Phase 3+
- Mid-workout circuit editing — not planned
- Strength screens redesign — Phase 4
- Home hero card / Calendar — Phase 3

---

## Success Criteria

1. Tapping "▶ Iniciar" from planning screen opens `HiitWorkoutScreen`
2. `time` exercises count down and auto-advance; `reps` exercises wait for "Listo" tap
3. Rest between rounds shows countdown with skip button
4. Screen stays on throughout workout (`wakelock_plus`)
5. Audio beeps on 3-2-1 and phase transitions; haptic fires on transitions
6. Each exercise completion is logged to `HiitExerciseLogs`
7. `WorkoutDoneScreen` shows planned vs actual for all exercises
8. Navigating away and back preserves workout state (notifier alive via Riverpod)
9. DB migrates cleanly from v5 → v6 on existing data
10. State machine unit tests cover all phase transitions
