# Phase 4 — Strength Screens Visual Redesign Spec
**Date:** 2026-05-26
**Scope:** Visual polish of strength workout UI to match HIIT aesthetic
**Depends on:** Phase 3 (AppTheme.fuerza, AppTheme.fuerzaSoft already added)

---

## Context

Flutter app (`workout_app/`) with Riverpod + Drift. Phases 1–3 delivered HIIT planning, active HIIT workout, and the hero card/calendar. The strength screens (`ExerciseCard`, `SetRow`, `_StrengthContent`, `_MuscleGroupHeader`) use raw `Colors.X` constants and don't match the HIIT visual language. Phase 4 is a pure visual refactor — no interaction model changes.

Stack: Flutter ^3.11.5, flutter_riverpod ^2.6.1.
Target: Android, Galaxy S25 Ultra.

---

## Decisions

| Question | Answer |
|---|---|
| Approach | Full HIIT-aligned restyle (Option B) |
| Done-state color | Fuerza blue (`AppTheme.fuerza`) — replaces green |
| Interaction model | Unchanged — dialogs stay |
| New files | None — 3 existing files modified |
| Dialog styling | Out of scope |

---

## Token Mapping

| Old | New | Usage |
|---|---|---|
| `Colors.green[950]` | `AppTheme.fuerzaSoft` | Done card background |
| `Colors.green[300]`, `Colors.green[400]` | `AppTheme.fuerza` | Done text, icons |
| `Colors.green[700]` | `AppTheme.fuerzaSoft` | Done toggle circle bg |
| `Colors.green` (icon) | `AppTheme.fuerza` | Check circle icon |
| `Colors.blue` | `AppTheme.fuerza` | Volume display |
| `Colors.blue[900]` | `AppTheme.fuerzaSoft` | Weight chip bg (has value) |
| `Colors.lightBlue` | `AppTheme.fuerza` | Weight chip text (has value) |
| `Colors.orange[300]` | `AppTheme.textMid` | Rest time label |
| `Colors.grey[850]` | `AppTheme.bgCard2` | Chip backgrounds (undone) |
| `Colors.grey[600]` | `AppTheme.textDim` | Toggle border (undone) |
| `Colors.grey` | `AppTheme.textDim` | Set number text |
| `Theme.of(context).colorScheme.primary` | `AppTheme.fuerza` | Muscle group header |

`Colors.red[300]` (delete icon) stays — AppTheme has no destructive constant.

---

## Block 1 — ExerciseCard

File: `lib/features/today/exercise_card.dart`

### Card background
- Active (not all done): `AppTheme.bgCard2` (instead of default card color)
- Done: `AppTheme.fuerzaSoft`

### Header row (active state)
- Exercise name: `AppTheme.text`, `FontWeight.w600`
- Volume text: `AppTheme.fuerza` (was `Colors.blue`)
- Delete icon: `Colors.red[400]` (unchanged — destructive signal)

### Header row (done state)
- Exercise name: `AppTheme.fuerza`, strikethrough uses `AppTheme.fuerza`
- Expand/collapse icon: `AppTheme.fuerza` (was `Colors.green[400]`)
- Check circle icon: `AppTheme.fuerza` (was `Colors.green`)

### Rest time label
- Replace emoji `⏱` + `Colors.orange[300]` with `Icons.timer` size 12 + `AppTheme.textMid`

### Add-serie button
- `TextButton.styleFrom(foregroundColor: AppTheme.fuerza)`

---

## Block 2 — SetRow

File: `lib/features/today/set_row.dart`

Add import: `package:google_fonts/google_fonts.dart`

### Toggle circle
| State | Background | Border | Content |
|---|---|---|---|
| Undone | `AppTheme.bgCard2` | `AppTheme.textDim` | Set number, JetBrainsMono, `AppTheme.textDim` |
| Done | `AppTheme.fuerzaSoft` | `AppTheme.fuerza` | `Icons.check` size 16, color `AppTheme.fuerza` |

### Reps chip
| State | Background | Text color | Font | Extra |
|---|---|---|---|---|
| Undone, normal | `AppTheme.bgCard2` | `AppTheme.text` | JetBrainsMono | — |
| Undone, "fallo" | `AppTheme.bgCard2` | `AppTheme.textMid` | JetBrainsMono | — |
| Done | `AppTheme.fuerzaSoft` | `AppTheme.fuerza` | JetBrainsMono | strikethrough `AppTheme.fuerza` |

### Weight chip
| State | Background | Text color | Font |
|---|---|---|---|
| No weight | `AppTheme.bgCard2` | `AppTheme.textDim` | JetBrainsMono |
| Has weight, undone | `AppTheme.fuerzaSoft` | `AppTheme.fuerza` | JetBrainsMono |
| Has weight, done | `AppTheme.fuerzaSoft` | `AppTheme.fuerza` | JetBrainsMono |

---

## Block 3 — today_screen.dart

File: `lib/features/today/today_screen.dart`

### _MuscleGroupHeader
Replace `Theme.of(context).colorScheme.primary` with `AppTheme.fuerza` in both the text style and divider color.

### Add-exercise button (_StrengthContent)
Replace `OutlinedButton` with a styled container matching HIIT's "Agregar circuito" button:
```dart
Container(
  height: 52,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppTheme.fuerza),
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.add, color: AppTheme.fuerza, size: 18),
      SizedBox(width: 8),
      Text('Agregar ejercicio',
          style: TextStyle(color: AppTheme.fuerza, fontSize: 15, fontWeight: FontWeight.w500)),
    ],
  ),
)
```
Wrap in `GestureDetector(onTap: () => _addExercise(...))`.

---

## File Map

| Action | Path |
|---|---|
| Modify | `lib/features/today/exercise_card.dart` |
| Modify | `lib/features/today/set_row.dart` |
| Modify | `lib/features/today/today_screen.dart` |

---

## Success Criteria

1. No raw `Colors.X` (except `Colors.red` for delete) in the 3 files
2. Done state: fuerza blue throughout — card bg, name, toggle, chips
3. Set number and chip text use JetBrainsMono
4. Muscle group header uses `AppTheme.fuerza`
5. Add-exercise button matches HIIT "Agregar circuito" style
6. `flutter analyze` 0 errors
