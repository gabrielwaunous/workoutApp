import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout_app/core/database/app_database.dart';
import 'package:workout_app/core/theme/app_theme.dart';
import 'package:workout_app/features/calendar/providers.dart';
import 'package:workout_app/features/today/providers.dart';
import 'package:workout_app/providers.dart';

class SessionHeroCard extends ConsumerWidget {
  const SessionHeroCard({super.key, required this.session});
  final WorkoutSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHiit = session.type == 'hiit';
    final accent = isHiit ? AppTheme.hiit : AppTheme.fuerza;

    final exercises =
        ref.watch(exercisesBySessionProvider(session.id)).valueOrNull ?? [];
    final volume =
        ref.watch(dailyVolumeProvider(session.id)).valueOrNull ?? 0.0;
    final streak = ref.watch(streakProvider);
    final sessionsByDay =
        ref.watch(sessionsByDayProvider).valueOrNull ?? {};

    final groups = exercises
        .map((e) => e.muscleGroup)
        .whereType<String>()
        .toSet()
        .toList();

    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);
    final sessionDateNorm = DateTime(
        session.date.year, session.date.month, session.date.day);
    final dayLabel =
        sessionDateNorm == todayNorm ? 'HOY' : _shortDate(session.date);
    final weekStart =
        todayNorm.subtract(Duration(days: todayNorm.weekday - 1));

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Gradient hero card ──────────────────────────────────
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isHiit
                    ? [const Color(0xFF1A2A18), AppTheme.bg]
                    : [const Color(0xFF1A2438), AppTheme.bg],
              ),
              border: Border.all(color: AppTheme.lineStrong),
            ),
            padding: const EdgeInsets.fromLTRB(20, 18, 8, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Eyebrow row
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: accent),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isHiit ? '$dayLabel · HIIT' : '$dayLabel · FUERZA',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.12,
                        color: accent,
                      ),
                    ),
                    const Spacer(),
                    if (streak > 0) ...[
                      const Icon(Icons.local_fire_department,
                          color: AppTheme.hiit, size: 14),
                      const SizedBox(width: 3),
                      Text(
                        '$streak',
                        style: const TextStyle(
                            color: AppTheme.hiit,
                            fontSize: 13,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 4),
                    ],
                    _SessionTypeMenu(session: session),
                  ],
                ),
                const SizedBox(height: 12),
                // Title (muscle groups or default)
                if (groups.isNotEmpty) ...[
                  Text(
                    groups.first,
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.02,
                        height: 1.05),
                  ),
                  if (groups.length > 1)
                    Text(
                      '+ ${groups.skip(1).join(' · ')}',
                      style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.02,
                          height: 1.05,
                          color: AppTheme.textMid),
                    ),
                ] else
                  Text(
                    isHiit
                        ? 'Entrenamiento HIIT'
                        : 'Entrenamiento de Fuerza',
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.02),
                  ),
                const SizedBox(height: 16),
                // Stats row
                Row(
                  children: [
                    if (exercises.isNotEmpty)
                      _StatCell(
                        value: '${exercises.length}',
                        label: 'EJERCICIOS',
                      ),
                    if (exercises.isNotEmpty && !isHiit && volume > 0)
                      Container(
                        width: 1,
                        height: 32,
                        margin:
                            const EdgeInsets.symmetric(horizontal: 16),
                        color: AppTheme.line,
                      ),
                    if (!isHiit && volume > 0)
                      _StatCell(
                        value: volume.toStringAsFixed(0),
                        label: 'VOL TOTAL',
                        color: accent,
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // ── Week strip ──────────────────────────────────────────
          _WeekStrip(
            weekStart: weekStart,
            todayNorm: todayNorm,
            sessionsByDay: sessionsByDay,
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell(
      {required this.value, required this.label, this.color});
  final String value;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: color ?? AppTheme.text,
            letterSpacing: -0.02,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 9,
            fontWeight: FontWeight.w500,
            color: AppTheme.textDim,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}

class _WeekStrip extends StatelessWidget {
  const _WeekStrip({
    required this.weekStart,
    required this.todayNorm,
    required this.sessionsByDay,
  });
  final DateTime weekStart;
  final DateTime todayNorm;
  final Map<DateTime, WorkoutSession> sessionsByDay;

  static const _labels = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(7, (i) {
        final day = weekStart.add(Duration(days: i));
        final isToday = day == todayNorm;
        final session = sessionsByDay[day];
        final color = session == null
            ? null
            : session.type == 'hiit'
                ? AppTheme.hiit
                : AppTheme.fuerza;

        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isToday ? AppTheme.bgCard2 : AppTheme.bgCard,
              border: Border.all(
                color: isToday
                    ? (color ?? AppTheme.textMid)
                    : AppTheme.line,
              ),
            ),
            child: Column(
              children: [
                Text(
                  _labels[i],
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: isToday
                        ? (color ?? AppTheme.textMid)
                        : AppTheme.textDim,
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${day.day}',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isToday
                        ? (color ?? AppTheme.text)
                        : AppTheme.text,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color ?? AppTheme.textFaint,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _SessionTypeMenu extends ConsumerWidget {
  const _SessionTypeMenu({required this.session});
  final WorkoutSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHiit = session.type == 'hiit';
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert,
          color: isHiit ? AppTheme.hiit : AppTheme.fuerza),
      onSelected: (type) async {
        final db = ref.read(databaseProvider);
        await db.sessionsDao.updateType(session.id, type);
      },
      itemBuilder: (_) => const [
        PopupMenuItem(value: 'strength', child: Text('Fuerza')),
        PopupMenuItem(value: 'hiit', child: Text('HIIT')),
      ],
    );
  }
}

String _shortDate(DateTime d) {
  const days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
  const months = [
    'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
  ];
  return '${days[d.weekday - 1]} ${d.day} ${months[d.month - 1]}';
}
