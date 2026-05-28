import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout_app/core/theme/app_theme.dart';
import 'package:workout_app/features/hiit/workout/hiit_workout_state.dart';

class WorkoutDoneScreen extends StatelessWidget {
  const WorkoutDoneScreen({super.key, required this.workoutState});
  final HiitWorkoutState workoutState;

  String _elapsed() {
    final secs =
        DateTime.now().difference(workoutState.startedAt).inSeconds;
    final m = secs ~/ 60;
    final s = (secs % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final totalSeries = workoutState.circuits.fold<int>(
      0,
      (sum, c) =>
          sum +
          (workoutState.exercisesByCircuit[c.id]?.length ?? 0) * c.rounds,
    );

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: AppTheme.hiitSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: AppTheme.hiit, size: 44),
              ),
              const SizedBox(height: 24),
              const Text(
                '¡Listo!',
                style: TextStyle(
                  color: AppTheme.text,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Circuito completado',
                style: TextStyle(color: AppTheme.textMid, fontSize: 15),
              ),
              const SizedBox(height: 32),
              _StatsRow(elapsed: _elapsed(), totalSeries: totalSeries),
              const Spacer(),
              _CircuitSummary(workoutState: workoutState),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.hiit,
                    foregroundColor: AppTheme.bg,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Volver',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.elapsed, required this.totalSeries});
  final String elapsed;
  final int totalSeries;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _Stat(label: 'Tiempo', value: elapsed),
        _Stat(label: 'Series', value: '$totalSeries'),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(
            color: AppTheme.hiit,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: AppTheme.textMid, fontSize: 13),
        ),
      ],
    );
  }
}

class _CircuitSummary extends StatelessWidget {
  const _CircuitSummary({required this.workoutState});
  final HiitWorkoutState workoutState;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: workoutState.circuits.map((c) {
        final exercises =
            workoutState.exercisesByCircuit[c.id] ?? [];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Circuito ${c.letter} · ${c.rounds} rondas',
                style: GoogleFonts.jetBrainsMono(
                  color: AppTheme.textDim,
                  fontSize: 11,
                  letterSpacing: 0.12 * 11,
                ),
              ),
              const SizedBox(height: 8),
              ...exercises.map((ex) {
                final isTime = ex.type == 'time';
                final val = isTime
                    ? '${ex.value ~/ 60}:${(ex.value % 60).toString().padLeft(2, '0')}'
                    : '×${ex.value}';
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle,
                          color: AppTheme.ok, size: 16),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          ex.name,
                          style: const TextStyle(
                              color: AppTheme.text, fontSize: 14),
                        ),
                      ),
                      Text(
                        val,
                        style: GoogleFonts.jetBrainsMono(
                          color: AppTheme.hiit,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      }).toList(),
    );
  }
}
