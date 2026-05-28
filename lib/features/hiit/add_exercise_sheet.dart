import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout_app/core/database/app_database.dart';
import 'package:workout_app/core/theme/app_theme.dart';
import 'package:workout_app/providers.dart';

class AddExerciseSheet extends ConsumerStatefulWidget {
  const AddExerciseSheet({super.key, required this.circuit});
  final HiitCircuit circuit;

  @override
  ConsumerState<AddExerciseSheet> createState() => _AddExerciseSheetState();
}

class _AddExerciseSheetState extends ConsumerState<AddExerciseSheet> {
  final _nameCtrl = TextEditingController();
  bool _isTime = false;
  int _repsValue = 10;
  int _timeValue = 30;

  static const _repsPresets = [4, 6, 8, 10, 12, 15, 20];
  static const _timePresets = [10, 15, 20, 30, 45, 60];

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  String _timeLabel(int sec) =>
      '${sec ~/ 60}:${(sec % 60).toString().padLeft(2, '0')}';

  Future<void> _add() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;

    final db = ref.read(databaseProvider);
    final existing = await (db.select(db.hiitExercises)
          ..where((t) => t.circuitId.equals(widget.circuit.id)))
        .get();
    final count = existing.length;

    await db.hiitExercisesDao.insertExercise(
      HiitExercisesCompanion.insert(
        circuitId: widget.circuit.id,
        name: name,
        type: _isTime ? 'time' : 'reps',
        value: _isTime ? _timeValue : _repsValue,
        orderIndex: count,
      ),
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'CIRCUITO ${widget.circuit.letter}',
              style: GoogleFonts.jetBrainsMono(
                color: AppTheme.hiit,
                fontSize: 11,
                letterSpacing: 0.12 * 11,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Agregar ejercicio',
              style: TextStyle(
                color: AppTheme.text,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameCtrl,
              style: const TextStyle(color: AppTheme.text),
              decoration: InputDecoration(
                labelText: 'Nombre del ejercicio',
                labelStyle: const TextStyle(color: AppTheme.textMid),
                filled: true,
                fillColor: AppTheme.bgCard,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.line),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppTheme.hiit, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _TypeToggle(
              isTime: _isTime,
              onChanged: (v) => setState(() => _isTime = v),
            ),
            const SizedBox(height: 24),
            if (!_isTime) ...[
              Center(
                child: Text(
                  '$_repsValue',
                  style: GoogleFonts.jetBrainsMono(
                    color: AppTheme.hiit,
                    fontSize: 56,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                alignment: WrapAlignment.center,
                children: _repsPresets
                    .map((v) => _QuickChip(
                          label: '$v',
                          selected: _repsValue == v,
                          color: AppTheme.hiit,
                          onTap: () => setState(() => _repsValue = v),
                        ))
                    .toList(),
              ),
            ] else ...[
              Center(
                child: Text(
                  _timeLabel(_timeValue),
                  style: GoogleFonts.jetBrainsMono(
                    color: AppTheme.rest,
                    fontSize: 56,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                alignment: WrapAlignment.center,
                children: _timePresets
                    .map((v) => _QuickChip(
                          label: _timeLabel(v),
                          selected: _timeValue == v,
                          color: AppTheme.rest,
                          onTap: () => setState(() => _timeValue = v),
                        ))
                    .toList(),
              ),
            ],
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _add,
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.hiit,
                  foregroundColor: AppTheme.bg,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Agregar al circuito',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeToggle extends StatelessWidget {
  const _TypeToggle({required this.isTime, required this.onChanged});
  final bool isTime;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgChip,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _Segment(
            label: 'Repeticiones',
            selected: !isTime,
            color: AppTheme.hiit,
            onTap: () => onChanged(false),
          ),
          _Segment(
            label: 'Tiempo',
            selected: isTime,
            color: AppTheme.rest,
            onTap: () => onChanged(true),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color:
                selected ? color.withValues(alpha: 0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: selected
                ? Border.all(color: color.withValues(alpha: 0.4))
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? color : AppTheme.textMid,
              fontSize: 14,
              fontWeight:
                  selected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.15) : AppTheme.bgChip,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? color : AppTheme.line),
        ),
        child: Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            color: selected ? color : AppTheme.textMid,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
