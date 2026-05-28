import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout_app/core/database/app_database.dart';
import 'package:workout_app/core/theme/app_theme.dart';
import 'package:workout_app/features/hiit/circuit_card.dart';
import 'package:workout_app/features/hiit/edit_circuit_sheet.dart';
import 'package:workout_app/features/hiit/providers.dart';
import 'package:workout_app/features/hiit/workout/hiit_workout_screen.dart';
import 'package:workout_app/providers.dart';

class HiitPlanningContent extends ConsumerWidget {
  const HiitPlanningContent({super.key, required this.sessionId});
  final int sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final circuitsAsync = ref.watch(circuitsBySessionProvider(sessionId));

    return circuitsAsync.when(
      data: (circuits) => circuits.isEmpty
          ? _EmptyState(sessionId: sessionId)
          : _FilledState(sessionId: sessionId, circuits: circuits),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _EmptyState extends ConsumerWidget {
  const _EmptyState({required this.sessionId});
  final int sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: AppTheme.hiitSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.loop, color: AppTheme.hiit, size: 36),
            ),
            const SizedBox(height: 20),
            const Text(
              'Arrancá tu primer circuito',
              style: TextStyle(
                color: AppTheme.text,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Agregá ejercicios por rondas. Podés combinar repeticiones y tiempo.',
              style: TextStyle(color: AppTheme.textMid, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Nuevo circuito'),
              onPressed: () => _addCircuit(context, ref),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.hiit,
                foregroundColor: AppTheme.bg,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addCircuit(BuildContext context, WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    final count = await db.hiitCircuitsDao.countBySession(sessionId);
    final letter = String.fromCharCode(65 + count);
    final id = await db.hiitCircuitsDao.insertCircuit(
      HiitCircuitsCompanion.insert(
        sessionId: sessionId,
        letter: letter,
        name: 'Circuito $letter',
        rounds: 3,
        restBetweenRoundsSec: 90,
        orderIndex: count,
      ),
    );
    if (!context.mounted) return;
    final circuits = await db.hiitCircuitsDao.watchBySession(sessionId).first;
    if (!context.mounted) return;
    final circuit = circuits.firstWhere((c) => c.id == id);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.bgCard2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => EditCircuitSheet(circuit: circuit),
    );
  }
}

class _FilledState extends ConsumerWidget {
  const _FilledState({required this.sessionId, required this.circuits});
  final int sessionId;
  final List<HiitCircuit> circuits;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'CIRCUITOS · ${circuits.length}',
                style: GoogleFonts.jetBrainsMono(
                  color: AppTheme.textDim,
                  fontSize: 11,
                  letterSpacing: 0.12 * 11,
                ),
              ),
            ),
            ...circuits.map((c) => CircuitCard(circuit: c)),
            const SizedBox(height: 8),
            _AddCircuitButton(sessionId: sessionId, count: circuits.length),
          ],
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: FilledButton.icon(
            icon: const Icon(Icons.play_arrow),
            label: const Text('Iniciar'),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HiitWorkoutScreen(sessionId: sessionId),
              ),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.hiit,
              foregroundColor: AppTheme.bg,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AddCircuitButton extends ConsumerWidget {
  const _AddCircuitButton({required this.sessionId, required this.count});
  final int sessionId;
  final int count;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        final db = ref.read(databaseProvider);
        final letter = String.fromCharCode(65 + count);
        final id = await db.hiitCircuitsDao.insertCircuit(
          HiitCircuitsCompanion.insert(
            sessionId: sessionId,
            letter: letter,
            name: 'Circuito $letter',
            rounds: 3,
            restBetweenRoundsSec: 90,
            orderIndex: count,
          ),
        );
        if (!context.mounted) return;
        final circuits =
            await db.hiitCircuitsDao.watchBySession(sessionId).first;
        if (!context.mounted) return;
        final circuit = circuits.firstWhere((c) => c.id == id);
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: AppTheme.bgCard2,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (_) => EditCircuitSheet(circuit: circuit),
        );
      },
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.hiit),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: AppTheme.hiit, size: 18),
            SizedBox(width: 8),
            Text(
              'Agregar circuito',
              style: TextStyle(
                color: AppTheme.hiit,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
