import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:workout_app/core/database/app_database.dart';
import 'package:workout_app/core/theme/app_theme.dart';
import 'package:workout_app/features/calendar/providers.dart';
import 'package:workout_app/features/week/day_detail_screen.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final activeDays = ref.watch(activeDaysProvider);
    final sessionsByDay = ref.watch(sessionsByDayProvider).valueOrNull ?? {};

    final selected = _selectedDay ?? DateTime.now();
    final selectedNorm =
        DateTime(selected.year, selected.month, selected.day);

    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime(2024),
          lastDay: DateTime(2030),
          focusedDay: _focusedDay,
          selectedDayPredicate: (d) => isSameDay(_selectedDay, d),
          onDaySelected: (selected, focused) {
            setState(() {
              _selectedDay = selected;
              _focusedDay = focused;
            });
          },
          onPageChanged: (focused) =>
              setState(() => _focusedDay = focused),
          calendarFormat: CalendarFormat.month,
          availableCalendarFormats: const {CalendarFormat.month: 'Mes'},
          startingDayOfWeek: StartingDayOfWeek.monday,
          eventLoader: (day) {
            final norm = DateTime(day.year, day.month, day.day);
            return activeDays.contains(norm) ? [true] : [];
          },
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              border: Border.all(color: AppTheme.hiit),
              shape: BoxShape.circle,
            ),
            todayTextStyle: const TextStyle(color: AppTheme.text),
            selectedDecoration: const BoxDecoration(
              color: AppTheme.hiitSoft,
              shape: BoxShape.circle,
            ),
            selectedTextStyle: const TextStyle(color: AppTheme.hiit),
            markerDecoration: const BoxDecoration(
              color: AppTheme.hiit,
              shape: BoxShape.circle,
            ),
            outsideDaysVisible: false,
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: _SelectedDayCard(
            selectedDay: selected,
            session: sessionsByDay[selectedNorm],
          ),
        ),
      ],
    );
  }
}

class _SelectedDayCard extends StatelessWidget {
  const _SelectedDayCard({required this.selectedDay, this.session});
  final DateTime selectedDay;
  final WorkoutSession? session;

  @override
  Widget build(BuildContext context) {
    if (session == null) {
      return const Center(
        child: Text(
          'Sin entrenamiento',
          style: TextStyle(color: AppTheme.textMid),
        ),
      );
    }
    final isHiit = session!.type == 'hiit';
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatDate(selectedDay),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            isHiit ? 'HIIT' : 'Fuerza',
            style:
                TextStyle(color: isHiit ? AppTheme.hiit : AppTheme.fuerza),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DayDetailScreen(date: selectedDay),
              ),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: isHiit ? AppTheme.hiit : AppTheme.fuerza,
              foregroundColor: AppTheme.bg,
            ),
            child: const Text('Ver detalle'),
          ),
        ],
      ),
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
