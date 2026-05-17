// lib/features/routines/routines_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import '../../core/database/app_database.dart';
import '../../core/parser/routine_parser.dart';
import '../../providers.dart';
import 'providers.dart';
import 'paste_routine_screen.dart';

final _parserProvider = Provider((_) => RoutineParser());

class RoutinesScreen extends ConsumerWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routinesAsync = ref.watch(routinesProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: OutlinedButton.icon(
            icon: const Icon(Icons.paste),
            label: const Text('Pegar desde WhatsApp'),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PasteRoutineScreen()),
            ),
          ),
        ),
        Expanded(
          child: routinesAsync.when(
            data: (routines) => routines.isEmpty
                ? const Center(child: Text('Sin rutinas guardadas'))
                : ListView.builder(
                    itemCount: routines.length,
                    itemBuilder: (_, i) => _RoutineTile(routine: routines[i]),
                  ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }
}

class _RoutineTile extends ConsumerWidget {
  final Routine routine;
  const _RoutineTile({required this.routine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(routine.name),
      subtitle: Text(_exerciseCount(routine.rawText)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () => _loadForDate(context, ref, DateTime.now()),
            child: const Text('Hoy'),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today, size: 18),
            tooltip: 'Elegir fecha',
            onPressed: () => _pickDateAndLoad(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18),
            color: Colors.red[300],
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
    );
  }

  String _exerciseCount(String raw) {
    final lines = raw.split('\n').where((l) => l.trim().isNotEmpty).length;
    return '$lines líneas';
  }

  Future<void> _pickDateAndLoad(BuildContext context, WidgetRef ref) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null) return;
    if (!context.mounted) return;
    await _loadForDate(context, ref, date);
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar rutina'),
        content: Text('¿Eliminar "${routine.name}"?'),
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
      await ref.read(databaseProvider).routinesDao.deleteRoutine(routine.id);
    }
  }

  Future<void> _loadForDate(
      BuildContext context, WidgetRef ref, DateTime date) async {
    final db = ref.read(databaseProvider);
    final session = await db.sessionsDao.getOrCreateForDate(date);
    final parser = ref.read(_parserProvider);
    final result = parser.parse(routine.rawText);

    int order = await db.exercisesDao.countBySession(session.id);
    for (final ex in result.exercises) {
      final eid = await db.exercisesDao.insertExercise(
        ExercisesCompanion(
          sessionId: Value(session.id),
          name: Value(ex.name),
          orderIndex: Value(order++),
          restSeconds: Value(ex.restSeconds),
        ),
      );
      for (int i = 0; i < ex.sets.length; i++) {
        final s = ex.sets[i];
        await db.setsDao.insertSet(
          SetsCompanion(
            exerciseId: Value(eid),
            setNumber: Value(i + 1),
            reps: Value(s.reps),
            weight: Value(s.weight),
            toFailure: Value(s.toFailure),
            isPartial: Value(s.isPartial),
          ),
        );
      }
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${result.exercises.length} ejercicios cargados')),
      );
    }
  }
}
