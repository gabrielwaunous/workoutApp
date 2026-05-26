import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout_app/core/database/app_database.dart';
import 'package:workout_app/core/theme/app_theme.dart';
import 'package:workout_app/providers.dart';

class EditCircuitSheet extends ConsumerStatefulWidget {
  const EditCircuitSheet({super.key, required this.circuit});
  final HiitCircuit circuit;

  @override
  ConsumerState<EditCircuitSheet> createState() => _EditCircuitSheetState();
}

class _EditCircuitSheetState extends ConsumerState<EditCircuitSheet> {
  late TextEditingController _nameCtrl;
  late int _rounds;
  late int _restRoundsSec;
  int? _restExercisesSec;

  static const _roundPresets = [30, 60, 90, 120, 180];
  static const _exercisePresets = [10, 15, 20, 30];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.circuit.name);
    _rounds = widget.circuit.rounds;
    _restRoundsSec = widget.circuit.restBetweenRoundsSec;
    _restExercisesSec = widget.circuit.restBetweenExercisesSec;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final db = ref.read(databaseProvider);
    await db.hiitCircuitsDao.updateCircuit(
      HiitCircuitsCompanion(
        id: Value(widget.circuit.id),
        name: Value(_nameCtrl.text.trim()),
        rounds: Value(_rounds),
        restBetweenRoundsSec: Value(_restRoundsSec),
        restBetweenExercisesSec: Value(_restExercisesSec),
      ),
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final hasExRest = _restExercisesSec != null;
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
            Row(
              children: [
                _LetterBadge(letter: widget.circuit.letter),
                const SizedBox(width: 12),
                const Text(
                  'Editar circuito',
                  style: TextStyle(
                    color: AppTheme.text,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameCtrl,
              style: const TextStyle(color: AppTheme.text),
              decoration: InputDecoration(
                labelText: 'Nombre del circuito',
                labelStyle: const TextStyle(color: AppTheme.textMid),
                filled: true,
                fillColor: AppTheme.bgCard,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.line),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.hiit, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Rondas',
              style: TextStyle(color: AppTheme.textMid, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, color: AppTheme.textMid),
                  onPressed:
                      _rounds > 1 ? () => setState(() => _rounds--) : null,
                ),
                const SizedBox(width: 16),
                Text(
                  '$_rounds',
                  style: GoogleFonts.jetBrainsMono(
                    color: AppTheme.hiit,
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.add, color: AppTheme.textMid),
                  onPressed: () => setState(() => _rounds++),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Descanso entre rondas',
              style: TextStyle(color: AppTheme.textMid, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _roundPresets
                  .map((sec) => _Chip(
                        label: sec >= 60
                            ? '${sec ~/ 60}:${(sec % 60).toString().padLeft(2, '0')}'
                            : '${sec}s',
                        selected: _restRoundsSec == sec,
                        color: AppTheme.rest,
                        onTap: () => setState(() => _restRoundsSec = sec),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Descanso entre ejercicios',
                    style: TextStyle(color: AppTheme.textMid, fontSize: 13),
                  ),
                ),
                Switch(
                  value: hasExRest,
                  activeColor: AppTheme.hiit,
                  onChanged: (v) => setState(() {
                    _restExercisesSec = v ? 15 : null;
                  }),
                ),
              ],
            ),
            if (hasExRest) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _exercisePresets
                    .map((sec) => _Chip(
                          label: '${sec}s',
                          selected: _restExercisesSec == sec,
                          color: AppTheme.hiit,
                          onTap: () => setState(() => _restExercisesSec = sec),
                        ))
                    .toList(),
              ),
            ],
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _save,
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.hiit,
                  foregroundColor: AppTheme.bg,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Guardar circuito',
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

class _LetterBadge extends StatelessWidget {
  const _LetterBadge({required this.letter});
  final String letter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppTheme.hiit,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: GoogleFonts.jetBrainsMono(
          color: AppTheme.bg,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.2) : AppTheme.bgChip,
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
