// lib/features/routines/review_lines_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import '../../core/database/app_database.dart';
import '../../core/parser/parsed_models.dart';
import '../../providers.dart';

class ReviewLinesScreen extends ConsumerStatefulWidget {
  final String routineName;
  final String rawText;
  final ParseResult parseResult;

  const ReviewLinesScreen({
    required this.routineName,
    required this.rawText,
    required this.parseResult,
    super.key,
  });

  @override
  ConsumerState<ReviewLinesScreen> createState() => _ReviewState();
}

class _ReviewState extends ConsumerState<ReviewLinesScreen> {
  late final List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = widget.parseResult.unrecognized
        .map((u) => TextEditingController(text: u.edited))
        .toList();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.parseResult;

    return Scaffold(
      appBar: AppBar(title: const Text('Revisar rutina')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '${r.exercises.length} ejercicios reconocidos',
            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...r.exercises.map(
            (ex) => ListTile(
              dense: true,
              leading: const Icon(Icons.check_circle, color: Colors.green, size: 18),
              title: Text(ex.name),
              subtitle: Text(_setsSummary(ex.sets)),
            ),
          ),
          if (r.unrecognized.isNotEmpty) ...[
            const Divider(height: 24),
            Text(
              '${r.unrecognized.length} líneas para revisar',
              style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...List.generate(r.unrecognized.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextField(
                  controller: _controllers[i],
                  decoration: InputDecoration(
                    labelText: 'Línea ${i + 1}',
                    helperText: 'Original: ${r.unrecognized[i].original}',
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (v) => r.unrecognized[i].edited = v,
                ),
              );
            }),
          ],
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _save,
            child: const Text('Guardar rutina'),
          ),
        ],
      ),
    );
  }

  String _setsSummary(List<ParsedSet> sets) {
    if (sets.length == 1 && sets.first.durationSeconds != null) {
      return '${sets.first.durationSeconds}s';
    }
    if (sets.every((s) => s.durationSeconds != null)) {
      return sets.map((s) => '${s.durationSeconds}s').join(' · ');
    }
    final reps = sets.map((s) => s.reps?.toString() ?? '?').join(' · ');
    return '${sets.length} ${sets.length == 1 ? 'set' : 'sets'} · $reps reps';
  }

  Future<void> _save() async {
    final db = ref.read(databaseProvider);
    await db.routinesDao.insertRoutine(
      RoutinesCompanion(
        name: Value(widget.routineName),
        rawText: Value(widget.rawText),
      ),
    );
    if (mounted) {
      Navigator.popUntil(context, (route) => route.isFirst);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rutina guardada')),
      );
    }
  }
}
