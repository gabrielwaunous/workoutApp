# Phase 3 — Hero Card + Calendar Design Spec
**Date:** 2026-05-26
**Scope:** Session hero card on Today tab + monthly calendar replacing Week tab
**Depends on:** Phase 1 (HiitCircuits, HiitExercises), Phase 2 (HiitWorkoutLogs, HiitExerciseLogs)

---

## Context

Flutter app (`workout_app/`) with Riverpod + Drift, schemaVersion 6. Phases 1–2 delivered HIIT planning and active workout execution. Phase 3 adds:

1. **Session Hero Card** — replaces `_SessionHeader` in `TodayScreen` with a richer widget showing session type, last workout, and consecutive-day streak.
2. **Monthly Calendar** — replaces `WeekScreen` in the "Semana" tab. Uses `table_calendar`. Days with completed work show a dot marker. Tapping a day shows a summary card; "Ver detalle" navigates to existing `DayDetailScreen`.

Stack: Flutter ^3.11.5, flutter_riverpod ^2.6.1, drift ^2.22.0, table_calendar ^3.1.x.
Target: Android, Galaxy S25 Ultra.

---

## Decisions

| Question | Answer |
|---|---|
| Calendar package | `table_calendar: ^3.1.2` |
| "Day trained" definition | HIIT: session with `HiitWorkoutLog.completedAt != null` — Strength: session with ≥1 `ExerciseSet` row |
| Streak | Consecutive calendar days going back from today with a "day trained" entry |
| Calendar tab name | Tab label changes from "Semana" to "Calendario" |
| Week screen fate | Removed — `CalendarScreen` replaces it entirely |
| Day detail on tap | Existing `DayDetailScreen` — no changes |
| Hero card placement | Replaces `_SessionHeader` in `TodayContent` |
| Streak zero | Streak line hidden when streak = 0 |
| No workout history | Last workout line hidden when no prior completed session |

---

## Block 1 — New Package

Add to `pubspec.yaml`:
```yaml
dependencies:
  table_calendar: ^3.1.2
```

---

## Block 2 — "Active Days" Query

### Two new methods — split across existing DAOs

**On `HiitWorkoutLogsDao`:**
```dart
/// Dates of sessions with a completed HIIT workout log.
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
```
`@DriftAccessor` for `HiitWorkoutLogsDao` already has `HiitWorkoutLogs` — add `WorkoutSessions`.

**On `SessionsDao`:**
```dart
/// Dates of sessions with ≥1 ExerciseSet (strength work).
Stream<Set<DateTime>> watchStrengthActiveDays() {
  final q = select(workoutSessions)
    ..where((s) => s.id.isInQuery(
        selectOnly(exercises)
          ..addColumns([exercises.sessionId])
          ..where(exercises.id.isInQuery(
              selectOnly(exerciseSets)
                ..addColumns([exerciseSets.exerciseId])))));
  return q
      .map((s) => DateTime(s.date.year, s.date.month, s.date.day))
      .watch()
      .map((list) => list.toSet());
}
```
`SessionsDao` already has `WorkoutSessions`, `Exercises`, `ExerciseSets` — no table changes needed.

**On `SessionsDao`** (also add):
```dart
Stream<List<WorkoutSession>> watchAllSessions() =>
    select(workoutSessions).watch();
```

Requires `rxdart: ^0.28.x` for `Rx.combineLatest2` in providers — add to `pubspec.yaml`.

---

## Block 3 — Providers

### File: `lib/features/calendar/providers.dart`

```dart
/// Stream of all dates with completed work.
final activeDaysProvider = StreamProvider<Set<DateTime>>((ref) {
  final db = ref.read(databaseProvider);
  return Rx.combineLatest2(
    db.hiitWorkoutLogsDao.watchHiitActiveDays(),
    db.sessionsDao.watchStrengthActiveDays(),
    (Set<DateTime> h, Set<DateTime> s) => {...h, ...s},
  );
});

/// Consecutive-day streak ending today.
final streakProvider = Provider<int>((ref) {
  final activeDays = ref.watch(activeDaysProvider).valueOrNull ?? {};
  if (activeDays.isEmpty) return 0;
  int streak = 0;
  DateTime day = DateTime.now();
  day = DateTime(day.year, day.month, day.day);
  while (activeDays.contains(day)) {
    streak++;
    day = day.subtract(const Duration(days: 1));
  }
  return streak;
});

/// Last session date with completed work (most recent active day before today).
final lastActiveDayProvider = Provider<DateTime?>((ref) {
  final activeDays = ref.watch(activeDaysProvider).valueOrNull ?? {};
  if (activeDays.isEmpty) return null;
  final today = DateTime.now();
  final todayNorm = DateTime(today.year, today.month, today.day);
  final past = activeDays
      .where((d) => d.isBefore(todayNorm))
      .toList()
    ..sort((a, b) => b.compareTo(a));
  return past.isEmpty ? null : past.first;
});

/// Sessions map keyed by normalized date — used by calendar event loader.
final sessionsByDayProvider = StreamProvider<Map<DateTime, WorkoutSession>>(
  (ref) {
    final db = ref.read(databaseProvider);
    return db.sessionsDao.watchAllSessions().map((sessions) => {
      for (final s in sessions)
        DateTime(s.date.year, s.date.month, s.date.day): s,
    });
  },
);
```

`SessionsDao` needs a `watchAllSessions()` stream — add if not present:
```dart
Stream<List<WorkoutSession>> watchAllSessions() => select(workoutSessions).watch();
```

---

## Block 4 — Session Hero Card

### File: `lib/features/home/session_hero_card.dart`

```dart
class SessionHeroCard extends ConsumerWidget {
  const SessionHeroCard({super.key, required this.session});
  final WorkoutSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakProvider);
    final lastDay = ref.watch(lastActiveDayProvider);
    final isHiit = session.type == 'hiit';
    final db = ref.read(databaseProvider);

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
                  Text(_formatDate(session.date),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              _SessionTypeMenu(session: session),
            ],
          ),
          if (streak > 0) ...[
            const SizedBox(height: 6),
            Row(children: [
              const Icon(Icons.local_fire_department,
                  color: AppTheme.hiit, size: 16),
              const SizedBox(width: 4),
              Text('$streak ${streak == 1 ? 'día seguido' : 'días seguidos'}',
                  style: const TextStyle(
                      color: AppTheme.hiit, fontSize: 13)),
            ]),
          ],
          if (lastDay != null) ...[
            const SizedBox(height: 2),
            Text('Último: ${_formatShort(lastDay)}',
                style: const TextStyle(
                    color: AppTheme.textMid, fontSize: 13)),
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
```

`_SessionTypeMenu` extracts the existing `PopupMenuButton` from `_SessionHeader` in `today_screen.dart`.

Modify `TodayContent.build` to use `SessionHeroCard` instead of `_SessionHeader`:
```dart
Column(
  children: [
    SessionHeroCard(session: session),
    Expanded(child: session.type == 'hiit'
        ? HiitPlanningContent(sessionId: session.id)
        : _StrengthContent(session: session)),
  ],
)
```

`AppTheme` needs:
- `fuerzaSoft` — blue with low opacity (analogous to `hiitSoft`)
- `fuerza` — blue accent (already used as `Colors.blue` in existing code — formalize as constant)

---

## Block 5 — Calendar Screen

### File: `lib/features/calendar/calendar_screen.dart`

```dart
class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});
  // ...
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final activeDaysAsync = ref.watch(activeDaysProvider);
    final sessionsByDay = ref.watch(sessionsByDayProvider).valueOrNull ?? {};
    final activeDays = activeDaysAsync.valueOrNull ?? {};

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
          onPageChanged: (focused) {
            setState(() => _focusedDay = focused);
          },
          calendarFormat: CalendarFormat.month,
          availableCalendarFormats: const {CalendarFormat.month: 'Mes'},
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
          startingDayOfWeek: StartingDayOfWeek.monday,
        ),
        const Divider(height: 1),
        Expanded(
          child: _SelectedDayCard(
            selectedDay: _selectedDay ?? DateTime.now(),
            session: sessionsByDay[DateTime(
              (_selectedDay ?? DateTime.now()).year,
              (_selectedDay ?? DateTime.now()).month,
              (_selectedDay ?? DateTime.now()).day,
            )],
          ),
        ),
      ],
    );
  }
}
```

### `_SelectedDayCard`

```dart
class _SelectedDayCard extends StatelessWidget {
  const _SelectedDayCard({required this.selectedDay, this.session});
  final DateTime selectedDay;
  final WorkoutSession? session;

  @override
  Widget build(BuildContext context) {
    if (session == null) {
      return const Center(
        child: Text('Sin entrenamiento', style: TextStyle(color: AppTheme.textMid)),
      );
    }
    final isHiit = session!.type == 'hiit';
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_formatDate(selectedDay),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(isHiit ? 'HIIT' : 'Fuerza',
              style: TextStyle(color: isHiit ? AppTheme.hiit : AppTheme.fuerza)),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => DayDetailScreen(date: selectedDay))),
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
```

### Modify `app.dart`

```dart
// Tab label: 'Semana' → 'Calendario'
// Import: CalendarScreen instead of WeekScreen
Tab(text: 'Calendario'),
// ...
CalendarScreen(),
```

---

## File Map

| Action | Path | Responsibility |
|---|---|---|
| Modify | `pubspec.yaml` | Add `table_calendar`, `rxdart` |
| Modify | `lib/core/database/daos/sessions_dao.dart` | Add `watchActiveDays()`, `watchAllSessions()` |
| Create | `lib/features/calendar/providers.dart` | `activeDaysProvider`, `streakProvider`, `lastActiveDayProvider`, `sessionsByDayProvider` |
| Create | `lib/features/home/session_hero_card.dart` | Hero card widget + `_TypeBadge` + `_SessionTypeMenu` |
| Modify | `lib/features/today/today_screen.dart` | Replace `_SessionHeader` with `SessionHeroCard`; extract `_SessionTypeMenu` |
| Create | `lib/features/calendar/calendar_screen.dart` | Monthly calendar + `_SelectedDayCard` |
| Modify | `lib/app.dart` | Tab label + replace `WeekScreen` with `CalendarScreen` |
| Modify | `lib/core/theme/app_theme.dart` | Add `fuerza`, `fuerzaSoft` constants |
| Delete | `lib/features/week/week_screen.dart` | Replaced by `CalendarScreen` |
| Delete | `lib/features/week/day_card.dart` | Only used by WeekScreen — dead code |
| Delete | `lib/features/week/providers.dart` | Only used by WeekScreen and DayCard — dead code |
| Keep | `lib/features/week/day_detail_screen.dart` | Still used by CalendarScreen |

---

## Success Criteria

1. Tab "Semana" renamed "Calendario" — monthly calendar grid visible
2. Days with completed HIIT logs or ≥1 strength set show a lime dot
3. Tapping a day with a session shows summary card + "Ver detalle" navigates to `DayDetailScreen`
4. Tapping a day without a session shows "Sin entrenamiento"
5. Hero card shows session type badge, streak (hidden if 0), last active day (hidden if none)
6. Streak increments correctly for consecutive days (HIIT completed + strength with sets)
7. `WeekScreen` removed — no dead code
8. `flutter analyze` 0 errors
