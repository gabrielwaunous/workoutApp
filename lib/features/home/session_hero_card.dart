import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_app/core/database/app_database.dart';
import 'package:workout_app/core/theme/app_theme.dart';
import 'package:workout_app/features/calendar/providers.dart';
import 'package:workout_app/providers.dart';

class SessionHeroCard extends ConsumerWidget {
  const SessionHeroCard({super.key, required this.session});
  final WorkoutSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakProvider);
    final lastDay = ref.watch(lastActiveDayProvider);
    final isHiit = session.type == 'hiit';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _TypeBadge(isHiit: isHiit),
                  const SizedBox(width: 10),
                  Text(
                    _formatDate(session.date),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              _SessionTypeMenu(session: session),
            ],
          ),
          if (streak > 0) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.local_fire_department,
                    color: AppTheme.hiit, size: 16),
                const SizedBox(width: 4),
                Text(
                  '$streak ${streak == 1 ? 'día seguido' : 'días seguidos'}',
                  style: const TextStyle(color: AppTheme.hiit, fontSize: 13),
                ),
              ],
            ),
          ],
          if (lastDay != null) ...[
            const SizedBox(height: 2),
            Text(
              'Último: ${_formatShort(lastDay)}',
              style: const TextStyle(color: AppTheme.textMid, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.isHiit});
  final bool isHiit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isHiit ? AppTheme.hiitSoft : AppTheme.fuerzaSoft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isHiit ? 'HIIT' : 'FUERZA',
        style: TextStyle(
          color: isHiit ? AppTheme.hiit : AppTheme.fuerza,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
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

String _formatDate(DateTime d) {
  const days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
  const months = [
    'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
  ];
  return '${days[d.weekday - 1]} ${d.day} ${months[d.month - 1]}';
}

String _formatShort(DateTime d) {
  const months = [
    'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
  ];
  return '${d.day} ${months[d.month - 1]}';
}
