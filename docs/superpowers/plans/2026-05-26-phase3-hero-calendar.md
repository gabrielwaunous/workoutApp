# Phase 3 — Hero Card + Calendar Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a session hero card with streak/last-workout to Today tab, and replace the Week tab with a monthly calendar showing completed workout days.

**Architecture:** Two new DAO stream methods provide "active days" data per training type; calendar providers combine them via Riverpod's reactive `Provider` (no rxdart needed — two `StreamProvider`s watched by a plain `Provider`); `SessionHeroCard` replaces `_SessionHeader`; `CalendarScreen` (table_calendar) replaces `WeekScreen`; three dead files deleted.

**Tech Stack:** Flutter ^3.11.5, flutter_riverpod ^2.6.1, drift ^2.22.0, table_calendar ^3.1.2.

---

### Task 1: Add table_calendar package

**Files:**
- Modify: `pubspec.yaml`

- [ ] **Step 1: Add table_calendar to pubspec.yaml**

In `pubspec.yaml`, under `dependencies:`, add:
```yaml
  table_calendar: ^3.1.2
```

- [ ] **Step 2: Run pub get**

Run: `flutter pub get`
Expected: resolves dependencies, no errors.

- [ ] **Step 3: Commit**

```
git add pubspec.yaml pubspec.lock
git commit -m "feat: add table_calendar dependency"
```

---

### Task 2: Extend DAOs with active-days queries + rebuild generated code

**Files:**
- Modify: `lib/core/database/daos/sessions_dao.dart`
- Modify: `lib/core/database/daos/hiit_workout_logs_dao.dart`
- Regenerate: `lib/core/database/daos/sessions_dao.g.dart`
- Regenerate: `lib/core/database/daos/hiit_workout_logs_dao.g.dart`
- Create: `test/core/database/daos/sessions_dao_active_days_test.dart`

**Context:**
- `Sets` table class → row type `WorkoutSet` (via `@DataClassName`), companion `SetsCompanion`, DAO getter `sets`.
- `Exercises` table class → companion `ExercisesCompanion`, DAO getter `exercises`.
- Adding tables to `@DriftAccessor` requires build_runner to regenerate `.g.dart`.
- `flutter test` fails on this machine (Windows sqlite3.dll bug) — tests verified via `flutter analyze`.

- [ ] **Step 1: Write the failing test**

Create `test/core/database/daos/sessions_dao_active_days_test.dart`:

```dart
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_app/core/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  Future<int> makeSession(DateTime date) =>
      db.into(db.workoutSessions).insert(
            WorkoutSessionsCompanion.insert(date: date),
          );

  Future<int> makeExercise(int sessionId) =>
      db.into(db.exercises).insert(
            ExercisesCompanion.insert(
              sessionId: sessionId,
              name: 'Squat',
              orderIndex: 0,
            ),
          );

  Future<void> makeSet(int exerciseId) =>
      db.into(db.sets).insert(
            SetsCompanion.insert(exerciseId: exerciseId, setNumber: 1),
          );

  test('watchStrengthActiveDays returns empty when no sets', () async {
    await makeSession(DateTime(2026, 1, 10));
    final days = await db.sessionsDao.watchStrengthActiveDays().first;
    expect(days, isEmpty);
  });

  test('watchStrengthActiveDays returns date when session has a set', () async {
    final sessionId = await makeSession(DateTime(2026, 1, 10));
    final exId = await makeExercise(sessionId);
    await makeSet(exId);
    final days = await db.sessionsDao.watchStrengthActiveDays().first;
    expect(days, contains(DateTime(2026, 1, 10)));
  });

  test('watchStrengthActiveDays excludes sessions without sets', () async {
    final sessionId = await makeSession(DateTime(2026, 1, 10));
    final exId = await makeExercise(sessionId);
    await makeSet(exId);
    await makeSession(DateTime(2026, 1, 11));
    final days = await db.sessionsDao.watchStrengthActiveDays().first;
    expect(days, {DateTime(2026, 1, 10)});
  });

  test('watchAllSessions returns all sessions', () async {
    await makeSession(DateTime(2026, 1, 10));
    await makeSession(DateTime(2026, 1, 11));
    final sessions = await db.sessionsDao.watchAllSessions().first;
    expect(sessions.length, 2);
  });
}
```

- [ ] **Step 2: Analyze test (will show method-not-found errors — expected)**

Run: `flutter analyze test/core/database/daos/sessions_dao_active_days_test.dart`
Expected: errors like "The method 'watchStrengthActiveDays' isn't defined" — confirms method names match what we'll implement.

- [ ] **Step 3: Replace sessions_dao.dart**

Replace the full content of `lib/core/database/daos/sessions_dao.dart`:

```dart
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'sessions_dao.g.dart';

@DriftAccessor(tables: [WorkoutSessions, Exercises, Sets])
class SessionsDao extends DatabaseAccessor<AppDatabase>
    with _$SessionsDaoMixin {
  SessionsDao(super.db);

  Future<WorkoutSession?> getByDate(DateTime date) {
    final dayOnly = DateTime(date.year, date.month, date.day);
    return (select(workoutSessions)
          ..where((t) => t.date.equals(dayOnly)))
        .getSingleOrNull();
  }

  Future<int> insertSession(WorkoutSessionsCompanion session) {
    final d = session.date.value;
    final dayOnly = DateTime(d.year, d.month, d.day);
    return into(workoutSessions)
        .insert(session.copyWith(date: Value(dayOnly)));
  }

  Stream<List<WorkoutSession>> watchWeek(DateTime monday) {
    final start = DateTime(monday.year, monday.month, monday.day);
    final end = start.add(const Duration(days: 7));
    return (select(workoutSessions)
          ..where((t) =>
              t.date.isBiggerOrEqualValue(start) &
              t.date.isSmallerThanValue(end)))
        .watch();
  }

  Future<List<WorkoutSession>> getWeek(DateTime monday) {
    final start = DateTime(monday.year, monday.month, monday.day);
    final end = start.add(const Duration(days: 7));
    return (select(workoutSessions)
          ..where((t) =>
              t.date.isBiggerOrEqualValue(start) &
              t.date.isSmallerThanValue(end)))
        .get();
  }

  Future<WorkoutSession> getOrCreateForDate(DateTime date) async {
    final existing = await getByDate(date);
    if (existing != null) return existing;
    await insertSession(WorkoutSessionsCompanion(date: Value(date)));
    return (await getByDate(date))!;
  }

  Future<void> updateType(int id, String type) =>
      (update(workoutSessions)..where((t) => t.id.equals(id)))
          .write(WorkoutSessionsCompanion(type: Value(type)));

  Stream<List<WorkoutSession>> watchAllSessions() =>
      select(workoutSessions).watch();

  Stream<Set<DateTime>> watchStrengthActiveDays() {
    final q = select(workoutSessions)
      ..where((s) => s.id.isInQuery(
          selectOnly(exercises)
            ..addColumns([exercises.sessionId])
            ..where(exercises.id.isInQuery(
                selectOnly(sets)..addColumns([sets.exerciseId])))));
    return q
        .map((s) => DateTime(s.date.year, s.date.month, s.date.day))
        .watch()
        .map((list) => list.toSet());
  }
}
```

- [ ] **Step 4: Replace hiit_workout_logs_dao.dart**

Replace the full content of `lib/core/database/daos/hiit_workout_logs_dao.dart`:

```dart
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'hiit_workout_logs_dao.g.dart';

@DriftAccessor(tables: [HiitWorkoutLogs, HiitExerciseLogs, WorkoutSessions])
class HiitWorkoutLogsDao extends DatabaseAccessor<AppDatabase>
    with _$HiitWorkoutLogsDaoMixin {
  HiitWorkoutLogsDao(super.db);

  Future<int> createLog(int sessionId) => into(hiitWorkoutLogs).insert(
        HiitWorkoutLogsCompanion.insert(
          sessionId: sessionId,
          startedAt: DateTime.now(),
        ),
      );

  Future<void> completeLog(int logId) =>
      (update(hiitWorkoutLogs)..where((t) => t.id.equals(logId)))
          .write(HiitWorkoutLogsCompanion(completedAt: Value(DateTime.now())));

  Future<void> logExercise(
    int workoutLogId,
    int exerciseId,
    int round,
    int actualValue,
  ) =>
      into(hiitExerciseLogs).insert(
        HiitExerciseLogsCompanion.insert(
          workoutLogId: workoutLogId,
          exerciseId: exerciseId,
          round: round,
          actualValue: actualValue,
          completedAt: DateTime.now(),
        ),
      );

  Stream<List<HiitWorkoutLog>> watchLogsForSession(int sessionId) =>
      (select(hiitWorkoutLogs)
            ..where((t) => t.sessionId.equals(sessionId))
            ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
          .watch();

  Future<List<HiitExerciseLog>> getExerciseLogsForWorkout(int workoutLogId) =>
      (select(hiitExerciseLogs)
            ..where((t) => t.workoutLogId.equals(workoutLogId)))
          .get();

  Stream<Set<DateTime>> watchHiitActiveDays() {
    final q = select(workoutSessions)
      ..where((s) => s.id.isInQuery(
          selectOnly(hiitWorkoutLogs)
            ..addColumns([hiitWorkoutLogs.sessionId])
            ..where(hiitWorkoutLogs.completedAt.isNotNull())));
    return q
        .map((s) => DateTime(s.date.year, s.date.month, s.date.day))
        .watch()
        .map((list) => list.toSet());
  }
}
```

- [ ] **Step 5: Run build_runner**

Run: `flutter pub run build_runner build --delete-conflicting-outputs`
Expected: completes without errors, regenerates `sessions_dao.g.dart` and `hiit_workout_logs_dao.g.dart`.

- [ ] **Step 6: Analyze**

Run: `flutter analyze lib/core/database/daos/ test/core/database/daos/sessions_dao_active_days_test.dart`
Expected: 0 errors.

- [ ] **Step 7: Commit**

```
git add lib/core/database/daos/sessions_dao.dart lib/core/database/daos/sessions_dao.g.dart lib/core/database/daos/hiit_workout_logs_dao.dart lib/core/database/daos/hiit_workout_logs_dao.g.dart test/core/database/daos/sessions_dao_active_days_test.dart
git commit -m "feat: add watchStrengthActiveDays, watchHiitActiveDays, watchAllSessions to DAOs"
```

---

### Task 3: Calendar providers

**Files:**
- Create: `lib/features/calendar/providers.dart`

**Context:** No rxdart needed — two private `StreamProvider`s feed a plain `Provider<Set<DateTime>>` which Riverpod re-evaluates reactively when either stream emits.

- [ ] **Step 1: Create providers file**

Create `lib/features/calendar/providers.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_app/core/database/app_database.dart';
import 'package:workout_app/providers.dart';

final _hiitActiveDaysProvider = StreamProvider<Set<DateTime>>(
  (ref) => ref.read(databaseProvider).hiitWorkoutLogsDao.watchHiitActiveDays(),
);

final _strengthActiveDaysProvider = StreamProvider<Set<DateTime>>(
  (ref) =>
      ref.read(databaseProvider).sessionsDao.watchStrengthActiveDays(),
);

/// All dates with completed work — HIIT completed logs ∪ strength sessions with ≥1 set.
final activeDaysProvider = Provider<Set<DateTime>>((ref) {
  final hiit = ref.watch(_hiitActiveDaysProvider).valueOrNull ?? {};
  final strength = ref.watch(_strengthActiveDaysProvider).valueOrNull ?? {};
  return {...hiit, ...strength};
});

/// Consecutive days ending today with completed work.
final streakProvider = Provider<int>((ref) {
  final activeDays = ref.watch(activeDaysProvider);
  int streak = 0;
  var day = DateTime.now();
  day = DateTime(day.year, day.month, day.day);
  while (activeDays.contains(day)) {
    streak++;
    day = day.subtract(const Duration(days: 1));
  }
  return streak;
});

/// Most recent active day strictly before today, or null if none.
final lastActiveDayProvider = Provider<DateTime?>((ref) {
  final activeDays = ref.watch(activeDaysProvider);
  if (activeDays.isEmpty) return null;
  final today = DateTime.now();
  final todayNorm = DateTime(today.year, today.month, today.day);
  final past = activeDays.where((d) => d.isBefore(todayNorm)).toList()
    ..sort((a, b) => b.compareTo(a));
  return past.isEmpty ? null : past.first;
});

/// All sessions keyed by normalized date (midnight) — used by calendar.
final sessionsByDayProvider = StreamProvider<Map<DateTime, WorkoutSession>>(
  (ref) => ref
      .read(databaseProvider)
      .sessionsDao
      .watchAllSessions()
      .map((sessions) => {
            for (final s in sessions)
              DateTime(s.date.year, s.date.month, s.date.day): s,
          }),
);
```

- [ ] **Step 2: Analyze**

Run: `flutter analyze lib/features/calendar/providers.dart`
Expected: 0 issues.

- [ ] **Step 3: Commit**

```
git add lib/features/calendar/providers.dart
git commit -m "feat: add calendar providers (activeDays, streak, lastActiveDay, sessionsByDay)"
```

---

### Task 4: SessionHeroCard widget

**Files:**
- Create: `lib/features/home/session_hero_card.dart`

**Context:** `AppTheme.fuerza = Color(0xFF6BA8FF)` and `AppTheme.fuerzaSoft = Color(0x226BA8FF)` already exist — no AppTheme changes needed.

- [ ] **Step 1: Create SessionHeroCard**

Create `lib/features/home/session_hero_card.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_app/core/database/app_database.dart';
import 'package:workout_app/core/theme/app_theme.dart';
import 'package:workout_app/features/calendar/providers.dart';
import 'package:workout_app/providers.dart';

class SessionHeroCard extends ConsumerWidget {
  const SessionHeroCard({super.key, required this.session});
  final WorkoutSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakProvider);
    final lastDay = ref.watch(lastActiveDayProvider);
    final isHiit = session.type == 'hiit';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _TypeBadge(isHiit: isHiit),
                  const SizedBox(width: 10),
                  Text(
                    _formatDate(session.date),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              _SessionTypeMenu(session: session),
            ],
          ),
          if (streak > 0) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.local_fire_department,
                    color: AppTheme.hiit, size: 16),
                const SizedBox(width: 4),
                Text(
                  '$streak ${streak == 1 ? 'día seguido' : 'días seguidos'}',
                  style: const TextStyle(color: AppTheme.hiit, fontSize: 13),
                ),
              ],
            ),
          ],
          if (lastDay != null) ...[
            const SizedBox(height: 2),
            Text(
              'Último: ${_formatShort(lastDay)}',
              style: const TextStyle(color: AppTheme.textMid, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.isHiit});
  final bool isHiit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isHiit ? AppTheme.hiitSoft : AppTheme.fuerzaSoft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isHiit ? 'HIIT' : 'FUERZA',
        style: TextStyle(
          color: isHiit ? AppTheme.hiit : AppTheme.fuerza,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _SessionTypeMenu extends ConsumerWidget {
  const _SessionTypeMenu({required this.session});
  final WorkoutSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHiit = session.type == 'hiit';
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert,
          color: isHiit ? AppTheme.hiit : AppTheme.fuerza),
      onSelected: (type) async {
        final db = ref.read(databaseProvider);
        await db.sessionsDao.updateType(session.id, type);
      },
      itemBuilder: (_) => const [
        PopupMenuItem(value: 'strength', child: Text('Fuerza')),
        PopupMenuItem(value: 'hiit', child: Text('HIIT')),
      ],
    );
  }
}

String _formatDate(DateTime d) {
  const days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
  const months = [
    'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
  ];
  return '${days[d.weekday - 1]} ${d.day} ${months[d.month - 1]}';
}

String _formatShort(DateTime d) {
  const months = [
    'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
  ];
  return '${d.day} ${months[d.month - 1]}';
}
```

- [ ] **Step 2: Analyze**

Run: `flutter analyze lib/features/home/session_hero_card.dart`
Expected: 0 issues.

- [ ] **Step 3: Commit**

```
git add lib/features/home/session_hero_card.dart
git commit -m "feat: add SessionHeroCard with type badge, streak, and last workout"
```

---

### Task 5: Update TodayScreen to use SessionHeroCard

**Files:**
- Modify: `lib/features/today/today_screen.dart`

**Context:** Remove `_SessionHeader` class entirely (it had date, volume, popup menu). Remove the top-level `_formatDate` function (also dead after this change). Add import for `SessionHeroCard`. The volume display (was in `_SessionHeader` for strength) is dropped per spec — it was secondary info and `_StrengthContent` still shows all sets.

- [ ] **Step 1: Add import to today_screen.dart**

At the top of `lib/features/today/today_screen.dart`, after the existing imports, add:
```dart
import 'package:workout_app/features/home/session_hero_card.dart';
```

- [ ] **Step 2: Replace TodayContent.build**

Find `TodayContent.build` and replace it:

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  return Column(
    children: [
      SessionHeroCard(session: session),
      Expanded(
        child: session.type == 'hiit'
            ? HiitPlanningContent(sessionId: session.id)
            : _StrengthContent(session: session),
      ),
    ],
  );
}
```

- [ ] **Step 3: Delete _SessionHeader class**

Delete the entire `_SessionHeader` class (from `class _SessionHeader` to its closing `}`). This removes the `dailyVolumeProvider` usage and the volume display.

- [ ] **Step 4: Delete _formatDate top-level function**

Delete the 6-line `_formatDate` top-level function (no longer needed — `SessionHeroCard` has its own copy).

- [ ] **Step 5: Analyze**

Run: `flutter analyze lib/features/today/today_screen.dart`
Expected: 0 errors. (Pre-existing `use_build_context_synchronously` warnings in `_addExercise` and `_AddCircuitButton` are acceptable.)

- [ ] **Step 6: Commit**

```
git add lib/features/today/today_screen.dart
git commit -m "feat: replace _SessionHeader with SessionHeroCard in TodayScreen"
```

---

### Task 6: CalendarScreen

**Files:**
- Create: `lib/features/calendar/calendar_screen.dart`

**Context:** `DayDetailScreen` lives at `lib/features/week/day_detail_screen.dart` — that file is NOT deleted (kept for reuse here). `isSameDay` comes from `table_calendar`.

- [ ] **Step 1: Create CalendarScreen**

Create `lib/features/calendar/calendar_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:workout_app/core/database/app_database.dart';
import 'package:workout_app/core/theme/app_theme.dart';
import 'package:workout_app/features/calendar/providers.dart';
import 'package:workout_app/features/week/day_detail_screen.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final activeDays = ref.watch(activeDaysProvider);
    final sessionsByDay = ref.watch(sessionsByDayProvider).valueOrNull ?? {};

    final selected = _selectedDay ?? DateTime.now();
    final selectedNorm =
        DateTime(selected.year, selected.month, selected.day);

    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime(2024),
          lastDay: DateTime(2030),
          focusedDay: _focusedDay,
          selectedDayPredicate: (d) => isSameDay(_selectedDay, d),
          onDaySelected: (selected, focused) {
            setState(() {
              _selectedDay = selected;
              _focusedDay = focused;
            });
          },
          onPageChanged: (focused) =>
              setState(() => _focusedDay = focused),
          calendarFormat: CalendarFormat.month,
          availableCalendarFormats: const {CalendarFormat.month: 'Mes'},
          startingDayOfWeek: StartingDayOfWeek.monday,
          eventLoader: (day) {
            final norm = DateTime(day.year, day.month, day.day);
            return activeDays.contains(norm) ? [true] : [];
          },
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              border: Border.all(color: AppTheme.hiit),
              shape: BoxShape.circle,
            ),
            todayTextStyle: const TextStyle(color: AppTheme.text),
            selectedDecoration: const BoxDecoration(
              color: AppTheme.hiitSoft,
              shape: BoxShape.circle,
            ),
            selectedTextStyle: const TextStyle(color: AppTheme.hiit),
            markerDecoration: const BoxDecoration(
              color: AppTheme.hiit,
              shape: BoxShape.circle,
            ),
            outsideDaysVisible: false,
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: _SelectedDayCard(
            selectedDay: selected,
            session: sessionsByDay[selectedNorm],
          ),
        ),
      ],
    );
  }
}

class _SelectedDayCard extends StatelessWidget {
  const _SelectedDayCard({required this.selectedDay, this.session});
  final DateTime selectedDay;
  final WorkoutSession? session;

  @override
  Widget build(BuildContext context) {
    if (session == null) {
      return const Center(
        child: Text(
          'Sin entrenamiento',
          style: TextStyle(color: AppTheme.textMid),
        ),
      );
    }
    final isHiit = session!.type == 'hiit';
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatDate(selectedDay),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            isHiit ? 'HIIT' : 'Fuerza',
            style:
                TextStyle(color: isHiit ? AppTheme.hiit : AppTheme.fuerza),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DayDetailScreen(date: selectedDay),
              ),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: isHiit ? AppTheme.hiit : AppTheme.fuerza,
              foregroundColor: AppTheme.bg,
            ),
            child: const Text('Ver detalle'),
          ),
        ],
      ),
    );
  }
}

String _formatDate(DateTime d) {
  const days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
  const months = [
    'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
  ];
  return '${days[d.weekday - 1]} ${d.day} ${months[d.month - 1]}';
}
```

- [ ] **Step 2: Analyze**

Run: `flutter analyze lib/features/calendar/calendar_screen.dart`
Expected: 0 issues.

- [ ] **Step 3: Commit**

```
git add lib/features/calendar/calendar_screen.dart
git commit -m "feat: add CalendarScreen with monthly view and day detail card"
```

---

### Task 7: Wire app, delete dead files, final verify

**Files:**
- Modify: `lib/app.dart`
- Delete: `lib/features/week/week_screen.dart`
- Delete: `lib/features/week/day_card.dart`
- Delete: `lib/features/week/providers.dart`

**Context:** `lib/features/week/day_detail_screen.dart` is NOT deleted — still used by `CalendarScreen`. The `watchWeek`/`getWeek` methods remain in `SessionsDao` (harmless, no warnings for public methods).

- [ ] **Step 1: Replace app.dart**

Replace the full content of `lib/app.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/today/today_screen.dart';
import 'features/calendar/calendar_screen.dart';
import 'features/routines/routines_screen.dart';

class WorkoutApp extends ConsumerWidget {
  const WorkoutApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Workout',
      theme: AppTheme.dark(),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Workout'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Hoy'),
                Tab(text: 'Calendario'),
                Tab(text: 'Rutinas'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              TodayScreen(),
              CalendarScreen(),
              RoutinesScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Delete dead files**

Run:
```
git rm lib/features/week/week_screen.dart lib/features/week/day_card.dart lib/features/week/providers.dart
```

- [ ] **Step 3: Analyze full project**

Run: `flutter analyze`
Expected: 0 errors. (Pre-existing info/warning level issues are acceptable.)

- [ ] **Step 4: Build APK**

Run: `flutter build apk --debug`
Expected: `✓ Built build\app\outputs\flutter-apk\app-debug.apk`

- [ ] **Step 5: Commit**

```
git add lib/app.dart
git commit -m "feat: wire CalendarScreen as Calendario tab, remove WeekScreen and dead files"
```
