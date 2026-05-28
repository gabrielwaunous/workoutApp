# Phase 4 — Strength Screens Visual Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Restyle the strength workout screens to match the HIIT aesthetic — AppTheme tokens throughout, fuerza blue for accents and done state, JetBrainsMono for chip/set text, add-exercise button matching HIIT card style.

**Architecture:** Pure visual refactor across 3 existing files. No new files, no logic changes, no database changes. All raw `Colors.X` references (except `Colors.red` for destructive delete) replaced with AppTheme constants. Done-state color switches from green to `AppTheme.fuerza` (blue).

**Tech Stack:** Flutter ^3.11.5, flutter_riverpod ^2.6.1, google_fonts (already in pubspec), AppTheme (`lib/core/theme/app_theme.dart`)

---

## File Map

| Action | File | What changes |
|---|---|---|
| Modify | `lib/features/today/set_row.dart` | Toggle circle, reps/weight chips — AppTheme tokens + JetBrainsMono |
| Modify | `lib/features/today/exercise_card.dart` | Card bg, done state colors, rest label, add-serie button |
| Modify | `lib/features/today/today_screen.dart` | Muscle group header, add-exercise button |

---

### Task 1: Restyle SetRow

**Files:**
- Modify: `lib/features/today/set_row.dart`

There are no automated tests for visual changes. Verification is `flutter analyze` (0 errors/warnings).

**Context:** `SetRow` renders one set as a row: a circle toggle + reps chip + weight chip. Currently uses raw `Colors.grey[850]`, `Colors.green[700]`, `Colors.blue[900]`, etc. Replace all with AppTheme constants and add JetBrainsMono to chip/set-number text. Done state: blue (`AppTheme.fuerza`) instead of green.

- [ ] **Step 1: Replace set_row.dart with restyled version**

Replace the entire file `lib/features/today/set_row.dart` with:

```dart
// lib/features/today/set_row.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/database/app_database.dart';
import '../../core/theme/app_theme.dart';
import '../../providers.dart';

class SetRow extends ConsumerWidget {
  final WorkoutSet set;

  const SetRow({required this.set, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final done = set.isDone;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          GestureDetector(
            onTap: () =>
                ref.read(databaseProvider).setsDao.toggleDone(set.id, !done),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: done ? AppTheme.fuerzaSoft : AppTheme.bgCard2,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: done ? AppTheme.fuerza : AppTheme.textDim,
                  width: 1.5,
                ),
              ),
              child: done
                  ? const Icon(Icons.check, size: 16, color: AppTheme.fuerza)
                  : Center(
                      child: Text(
                        '${set.setNumber}',
                        style: GoogleFonts.jetBrainsMono(
                          color: AppTheme.textDim,
                          fontSize: 11,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => _repsDialog(context, ref),
              child: _chip(
                set.toFailure ? 'fallo' : '${set.reps ?? '?'} reps',
                done ? AppTheme.fuerzaSoft : AppTheme.bgCard2,
                done
                    ? AppTheme.fuerza
                    : (set.toFailure ? AppTheme.textMid : AppTheme.text),
                strikethrough: done,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => _weightDialog(context, ref),
              child: _chip(
                set.weight != null ? '${set.weight} kg' : '+ peso',
                set.weight != null ? AppTheme.fuerzaSoft : AppTheme.bgCard2,
                set.weight != null ? AppTheme.fuerza : AppTheme.textDim,
                strikethrough: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text, Color bg, Color fg,
          {required bool strikethrough}) =>
      Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.jetBrainsMono(
            color: fg,
            fontSize: 13,
            decoration: strikethrough ? TextDecoration.lineThrough : null,
            decorationColor: fg,
          ),
        ),
      );

  void _repsDialog(BuildContext context, WidgetRef ref) {
    final repsCtrl = TextEditingController(
      text: set.reps != null ? '${set.reps}' : '',
    );
    bool toFailure = set.toFailure;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text('Set ${set.setNumber} — Reps'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: repsCtrl,
                enabled: !toFailure,
                keyboardType: TextInputType.number,
                autofocus: !toFailure,
                decoration: const InputDecoration(hintText: 'ej: 10'),
              ),
              Row(
                children: [
                  Checkbox(
                    value: toFailure,
                    onChanged: (v) => setState(() => toFailure = v ?? false),
                  ),
                  const Text('Al fallo'),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final reps = toFailure
                    ? null
                    : int.tryParse(repsCtrl.text.trim());
                ref
                    .read(databaseProvider)
                    .setsDao
                    .updateReps(set.id, reps, toFailure);
                Navigator.pop(ctx);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  void _weightDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(
      text: set.weight != null ? set.weight.toString() : '',
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Set ${set.setNumber} — Peso (kg)'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
          decoration: const InputDecoration(hintText: 'ej: 60'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final w = double.tryParse(controller.text.trim());
              ref.read(databaseProvider).setsDao.updateWeight(set.id, w);
              Navigator.pop(ctx);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Verify analyze passes**

Run: `flutter analyze lib/features/today/set_row.dart`
Expected: No issues found.

- [ ] **Step 3: Commit**

```bash
git add lib/features/today/set_row.dart
git commit -m "style: restyle SetRow with AppTheme tokens and JetBrainsMono"
```

---

### Task 2: Restyle ExerciseCard

**Files:**
- Modify: `lib/features/today/exercise_card.dart`

**Context:** `ExerciseCard` is the collapsible card for each exercise. Done state currently uses `Colors.green[950]` bg and green text/icons. Rest time uses emoji + orange text. Replace all with AppTheme constants. Add-serie button gets `AppTheme.fuerza` foreground color. Card background becomes `AppTheme.bgCard2` (was null/default).

- [ ] **Step 1: Replace exercise_card.dart with restyled version**

Replace the entire file `lib/features/today/exercise_card.dart` with:

```dart
// lib/features/today/exercise_card.dart
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/theme/app_theme.dart';
import '../../core/volume.dart';
import '../../providers.dart';
import 'providers.dart';
import 'set_row.dart';

String _formatRest(int seconds) {
  final m = seconds ~/ 60;
  final s = seconds % 60;
  if (m == 0) return '${s}s descanso';
  return s == 0 ? '${m}min descanso' : '${m}m ${s}s descanso';
}

class ExerciseCard extends ConsumerStatefulWidget {
  final Exercise exercise;

  const ExerciseCard({required this.exercise, super.key});

  @override
  ConsumerState<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends ConsumerState<ExerciseCard> {
  bool _expanded = true;

  Future<void> _showAddSetDialog(int currentCount) async {
    final result = await showDialog<SetsCompanion>(
      context: context,
      builder: (_) => _AddSetDialog(
        exerciseId: widget.exercise.id,
        setNumber: currentCount + 1,
      ),
    );
    if (result == null) return;
    await ref.read(databaseProvider).setsDao.insertSet(result);
  }

  @override
  Widget build(BuildContext context) {
    final setsAsync = ref.watch(setsByExerciseProvider(widget.exercise.id));
    final sets = setsAsync.valueOrNull;
    final allDone =
        sets != null && sets.isNotEmpty && sets.every((s) => s.isDone);

    if (allDone && _expanded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _expanded = false);
      });
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: allDone ? AppTheme.fuerzaSoft : AppTheme.bgCard2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: allDone ? () => setState(() => _expanded = !_expanded) : null,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.exercise.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: allDone ? AppTheme.fuerza : AppTheme.text,
                        decoration: allDone && !_expanded
                            ? TextDecoration.lineThrough
                            : null,
                        decorationColor: AppTheme.fuerza,
                      ),
                    ),
                  ),
                  if (allDone && !_expanded)
                    const Icon(Icons.check_circle,
                        color: AppTheme.fuerza, size: 18),
                  if (!allDone && sets != null)
                    Text(
                      '${calculateExerciseVolume(sets).toStringAsFixed(0)} vol',
                      style:
                          const TextStyle(color: AppTheme.fuerza, fontSize: 12),
                    ),
                  if (allDone)
                    Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                      color: AppTheme.fuerza,
                      size: 20,
                    ),
                  if (!allDone)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 18),
                      color: Colors.red[400],
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Eliminar ejercicio'),
                            content:
                                Text('¿Eliminar "${widget.exercise.name}"?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text('Eliminar'),
                              ),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          final db = ref.read(databaseProvider);
                          await db.setsDao.deleteByExercise(widget.exercise.id);
                          await db.exercisesDao
                              .deleteExercise(widget.exercise.id);
                        }
                      },
                    ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _expanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.exercise.restSeconds != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                    child: Row(
                      children: [
                        const Icon(Icons.timer,
                            size: 12, color: AppTheme.textMid),
                        const SizedBox(width: 4),
                        Text(
                          _formatRest(widget.exercise.restSeconds!),
                          style: const TextStyle(
                              color: AppTheme.textMid, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                if (sets != null)
                  Column(children: sets.map((s) => SetRow(set: s)).toList())
                else if (setsAsync.isLoading)
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: LinearProgressIndicator(),
                  )
                else if (setsAsync.hasError)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text('Error: ${setsAsync.error}'),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                  child: TextButton.icon(
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Serie'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.fuerza,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed: () => _showAddSetDialog(sets?.length ?? 0),
                  ),
                ),
              ],
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _AddSetDialog extends StatefulWidget {
  final int exerciseId;
  final int setNumber;

  const _AddSetDialog({required this.exerciseId, required this.setNumber});

  @override
  State<_AddSetDialog> createState() => _AddSetDialogState();
}

class _AddSetDialogState extends State<_AddSetDialog> {
  final _repsCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  bool _toFailure = false;

  @override
  void dispose() {
    _repsCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  void _confirm() {
    final reps = int.tryParse(_repsCtrl.text.trim());
    final weight = double.tryParse(_weightCtrl.text.trim());
    Navigator.pop(
      context,
      SetsCompanion(
        exerciseId: Value(widget.exerciseId),
        setNumber: Value(widget.setNumber),
        reps: Value(_toFailure ? null : reps),
        weight: Value(weight),
        toFailure: Value(_toFailure),
        isPartial: const Value(false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Serie ${widget.setNumber}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _repsCtrl,
                  enabled: !_toFailure,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Reps'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _weightCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Peso (kg)'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Checkbox(
                value: _toFailure,
                onChanged: (v) => setState(() => _toFailure = v ?? false),
              ),
              const Text('Al fallo'),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: _confirm,
          child: const Text('Agregar'),
        ),
      ],
    );
  }
}
```

- [ ] **Step 2: Verify analyze passes**

Run: `flutter analyze lib/features/today/exercise_card.dart`
Expected: No issues found.

- [ ] **Step 3: Commit**

```bash
git add lib/features/today/exercise_card.dart
git commit -m "style: restyle ExerciseCard with AppTheme tokens and fuerza done state"
```

---

### Task 3: Restyle today_screen.dart (header + add button)

**Files:**
- Modify: `lib/features/today/today_screen.dart`

**Context:** Two changes:
1. `_MuscleGroupHeader` — replace `Theme.of(context).colorScheme.primary` with `AppTheme.fuerza` in both text color and divider color. Remove the `BuildContext` dependency on the theme.
2. `_StrengthContent` add-exercise — replace the plain `OutlinedButton` with a `GestureDetector` + styled `Container` matching the HIIT "Agregar circuito" button (blue border, centered icon + text).

Also add `import 'package:workout_app/core/theme/app_theme.dart';` to today_screen.dart.

- [ ] **Step 1: Add AppTheme import**

In `lib/features/today/today_screen.dart`, add the import after the existing imports:

```dart
import 'package:workout_app/core/theme/app_theme.dart';
```

The full import block at the top of the file should be:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import 'package:workout_app/core/database/app_database.dart';
import 'package:workout_app/core/muscle_group_detector.dart';
import 'package:workout_app/core/theme/app_theme.dart';
import 'package:workout_app/features/hiit/hiit_planning_content.dart';
import 'package:workout_app/features/home/session_hero_card.dart';
import 'package:workout_app/providers.dart';
import 'exercise_card.dart';
import 'providers.dart';
```

- [ ] **Step 2: Replace _MuscleGroupHeader**

Replace the current `_MuscleGroupHeader` class (lines ~159–188):

```dart
class _MuscleGroupHeader extends StatelessWidget {
  final String label;
  const _MuscleGroupHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Divider(
              thickness: 0.5,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }
}
```

With:

```dart
class _MuscleGroupHeader extends StatelessWidget {
  final String label;
  const _MuscleGroupHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: AppTheme.fuerza,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Divider(
              thickness: 0.5,
              color: Color(0x446BA8FF),
            ),
          ),
        ],
      ),
    );
  }
}
```

Note: `Color(0x446BA8FF)` = `AppTheme.fuerza` at ~27% opacity (alpha 0x44 = 68/255 ≈ 0.27). This matches the visual intent of the old `withValues(alpha: 0.3)`. Using a literal here because `AppTheme.fuerza.withValues(alpha: 0.3)` is not a const expression.

- [ ] **Step 3: Replace the add-exercise OutlinedButton in _StrengthContent**

In `_StrengthContent.build`, find the `SliverToBoxAdapter` at the bottom containing the `OutlinedButton`:

```dart
SliverToBoxAdapter(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: OutlinedButton(
      onPressed: () => _addExercise(context, ref, session.id),
      child: const Text('+ Agregar ejercicio'),
    ),
  ),
),
```

Replace with:

```dart
SliverToBoxAdapter(
  child: Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
    child: GestureDetector(
      onTap: () => _addExercise(context, ref, session.id),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.fuerza),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: AppTheme.fuerza, size: 18),
            SizedBox(width: 8),
            Text(
              'Agregar ejercicio',
              style: TextStyle(
                color: AppTheme.fuerza,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ),
  ),
),
```

- [ ] **Step 4: Verify analyze passes**

Run: `flutter analyze lib/features/today/today_screen.dart`
Expected: No issues found.

- [ ] **Step 5: Commit**

```bash
git add lib/features/today/today_screen.dart
git commit -m "style: restyle muscle group header and add-exercise button with AppTheme"
```

---

## Final Verification

- [ ] **Run full analyze**

Run: `flutter analyze`
Expected: No issues found (0 errors, 0 warnings, 0 infos).

- [ ] **Build APK to confirm no runtime issues**

Run: `flutter build apk --debug`
Expected: Build successful.
