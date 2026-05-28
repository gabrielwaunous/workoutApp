# HIIT Phase 1 — Design Spec
**Date:** 2026-05-25  
**Scope:** Theme tokens + HIIT DB schema + HIIT planning screens  
**Approach:** Feature-additive (Approach A) — existing strength flow untouched

## Context

Flutter app (`workout_app/`) with Riverpod + Drift. Three tabs: Hoy / Semana / Rutinas. Currently strength-only. HIIT circuit planning is the missing feature. Reference design: `docs/design/index.html` (open with local HTTP server).

Stack: Flutter SDK ^3.11.5, flutter_riverpod ^2.6.1, drift ^2.22.0.  
Target: Android, Galaxy S25 Ultra. No Android Studio (RAM constraint).

---

## Block 1 — Theme & Design Tokens

### File: `lib/core/theme/app_theme.dart`

Static color constants matching `docs/design/tokens.css` exactly:

```
Surfaces:
  bg          #0B0C0E
  bgElev      #14161B
  bgCard      #181B22
  bgCard2     #1F232C
  bgChip      #252934
  line        rgba(255,255,255,0.07)
  lineStrong  rgba(255,255,255,0.14)

Text:
  text        #F1F2F5
  textMid     #9DA0AA
  textDim     #5E626E
  textFaint   #3A3D46

Semantic accents:
  hiit        #B8FF45   (electric lime — HIIT work)
  hiitSoft    #B8FF4520
  fuerza      #6BA8FF   (blue — strength)
  fuerzaSoft  #6BA8FF22
  rest        #FF9A52   (warm orange — rest/recovery)
  restSoft    #FF9A5222
  danger      #FF5A5A
  ok          #5BE39A
```

`AppTheme.dark()` returns a `ThemeData` with:
- `scaffoldBackgroundColor`: `bg`
- `colorScheme` built from `ColorScheme.dark()` with manual overrides (primary = hiit, surface = bgCard, etc.)
- `cardTheme`: color bgCard, radius 18, no elevation shadow (border instead)
- `textTheme`: Space Grotesk via `google_fonts` package

Add `google_fonts: ^6.2.1` to `pubspec.yaml`.

JetBrains Mono used inline only (`GoogleFonts.jetBrainsMono()`) on numeric data widgets — not in global TextTheme.

`app.dart` uses `AppTheme.dark()` instead of `ThemeData.dark()`.

---

## Block 2 — DB Schema Additions

### Migration: version 1 → 2

**Modify** `WorkoutSessions` — add column:
```dart
TextColumn get type => text().withDefault(const Constant('strength'))();
// values: 'strength' | 'hiit'
```

**New table** `HiitCircuits`:
```dart
class HiitCircuits extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(WorkoutSessions, #id)();
  TextColumn get letter => text()();                    // 'A', 'B', 'C'
  TextColumn get name => text()();
  IntColumn get rounds => integer()();
  IntColumn get restBetweenRoundsSec => integer()();
  IntColumn get restBetweenExercisesSec => integer().nullable()();
  IntColumn get orderIndex => integer()();
}
```

**New table** `HiitExercises`:
```dart
class HiitExercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get circuitId => integer().references(HiitCircuits, #id)();
  TextColumn get name => text()();
  TextColumn get type => text()();   // 'reps' | 'time'
  IntColumn get value => integer()(); // rep count OR seconds
  IntColumn get orderIndex => integer()();
}
```

`AppDatabase` schemaVersion bumped to 2. Migration adds the `type` column to `workout_sessions` and creates both new tables.

### New DAOs

**`HiitCircuitsDao`** — methods:
- `watchBySession(int sessionId)` → `Stream<List<HiitCircuit>>`
- `insertCircuit(HiitCircuitsCompanion)` → `Future<int>`
- `updateCircuit(HiitCircuitsCompanion)` → `Future<void>`
- `deleteCircuit(int id)` → `Future<void>`
- `countBySession(int sessionId)` → `Future<int>`

**`HiitExercisesDao`** — methods:
- `watchByCircuit(int circuitId)` → `Stream<List<HiitExercise>>`
- `insertExercise(HiitExercisesCompanion)` → `Future<int>`
- `updateExercise(HiitExercisesCompanion)` → `Future<void>`
- `deleteExercise(int id)` → `Future<void>`
- `reorder(List<int> ids)` → `Future<void>` (updates orderIndex for each)

---

## Block 3 — HIIT Planning Screens

### Navigation change

`TodayContent` (in `today_screen.dart`) checks `session.type`:
- `'strength'` → existing UI (unchanged)
- `'hiit'` → pushes `HiitPlanningScreen(sessionId: session.id)`

`WeekScreen` / day creation: when creating a new session, show a dialog asking "¿Fuerza o HIIT?" to set `type`. Existing sessions default to `'strength'` via migration.

### Riverpod providers (`lib/features/hiit/providers.dart`)

```dart
final circuitsBySessionProvider = StreamProvider.family<List<HiitCircuit>, int>(
  (ref, sessionId) => ref.read(databaseProvider).hiitCircuitsDao.watchBySession(sessionId),
);

final exercisesByCircuitProvider = StreamProvider.family<List<HiitExercise>, int>(
  (ref, circuitId) => ref.read(databaseProvider).hiitExercisesDao.watchByCircuit(circuitId),
);
```

### Screens and widgets

#### `hiit_planning_screen.dart`
- `AppBar` with "Guardar" action (lime, dark text)
- Header: eyebrow "RUTINA · HIIT", date large, subtitle "N circuitos · X min trabajo"
- If no circuits → `_HiitEmptyState` widget (loop icon, "Arrancá tu primer circuito" CTA, 3 template suggestions)
- If circuits → `SectionLabel("CIRCUITOS · N")` + list of `CircuitCard` + "Agregar circuito" dashed button

#### `circuit_card.dart`
- Container: bgCard, radius 20, border line, overflow hidden
- Header (lime gradient): letter badge (lime bg, dark text), name, more button; rounds + rest meta row
- Exercise list: `CircuitExerciseRow` per exercise (index chip, name, value chip in hiit/rest soft color, drag handle)
- Footer: "+ Ejercicio" button (hiit accent, borderTop)

#### `edit_circuit_sheet.dart`
Bottom sheet shown via `showModalBottomSheet`. Contains:
- Circuit letter badge + "Editar circuito" title
- Name field (text input, hiit border when focused)
- Rounds stepper: − / value / + (value in lime, large mono)
- Rest between rounds: preset chips [0:30, 1:00, 1:30, 2:00, 3:00, +], active chip in rest color (orange)
- Rest between exercises toggle (on = hiit color); when on, chips [10s, 15s, 20s, 30s]
- "Guardar circuito" CTA button (lime)

#### `add_exercise_sheet.dart`
Bottom sheet. Contains:
- "Agregar ejercicio" title + circuit letter eyebrow
- Exercise name text field + recent suggestions chips
- Type toggle: Repeticiones / Tiempo (segmented, active = lime for reps, orange for time)
- Reps mode: large mono value display + quick chips [4, 6, 8, 10, 12, 15, 20]
- Time mode: mm:ss display + quick chips [0:10, 0:15, 0:20, 0:30, 0:45, 1:00]
- "Agregar al circuito" CTA (lime)

#### `reorder_exercises_screen.dart`
Full screen (not sheet). `ReorderableListView` of exercises. Each row: drag handle (hiit color when dragging), index chip, name, value chip. "Listo" button in AppBar (lime). Info card at bottom explaining order applies to all rounds.

### Visual rules (apply throughout HIIT feature)

- All HIIT work elements: `AppTheme.hiit` (#B8FF45), dark text (#0B0C0E) on filled surfaces
- Rest/pause elements: `AppTheme.rest` (#FF9A52)
- Card borders: `AppTheme.line` (never elevation shadows)
- Monospace numbers: `GoogleFonts.jetBrainsMono()`
- Eyebrow labels: uppercase, 11px, letter-spacing 0.12em, JetBrains Mono

---

## File Structure

```
lib/
  core/
    theme/
      app_theme.dart
    database/
      tables.dart              ← add HiitCircuits, HiitExercises; add type to WorkoutSessions
      app_database.dart        ← schemaVersion 2, migration
      daos/
        hiit_circuits_dao.dart
        hiit_exercises_dao.dart
  features/
    hiit/
      providers.dart
      hiit_planning_screen.dart
      circuit_card.dart
      edit_circuit_sheet.dart
      add_exercise_sheet.dart
      reorder_exercises_screen.dart
```

---

## Out of Scope (Phase 1)

- HIIT active workout (timers, reps tap, rest countdown) — Phase 2
- Home hero card / Calendar — Phase 3
- Strength screens redesign — Phase 4
- Session map visualization — Phase 4

---

## Success Criteria

1. App compiles and runs on Android without Android Studio (`flutter run`)
2. DB migration runs cleanly on existing data (existing strength sessions unaffected)
3. Creating a HIIT session shows HIIT planning screen instead of strength screen
4. Can create circuits with exercises (reps and time types)
5. Can edit circuit config (rounds, rest) via bottom sheet
6. Can reorder exercises within a circuit
7. All colors, typography, and spacing match `docs/design/index.html` visually
8. No existing strength functionality broken
