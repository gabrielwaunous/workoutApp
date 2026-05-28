import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final sessionsByDay =
        ref.watch(sessionsByDayProvider).valueOrNull ?? {};
    final volumeByDay = ref.watch(volumeByDayProvider);

    final selected = _selectedDay ?? DateTime.now();
    final selectedNorm =
        DateTime(selected.year, selected.month, selected.day);

    // Month totals for the focused month
    final monthEntries = sessionsByDay.entries
        .where((e) =>
            e.key.year == _focusedDay.year &&
            e.key.month == _focusedDay.month)
        .toList();
    final strengthCount =
        monthEntries.where((e) => e.value.type != 'hiit').length;
    final hiitCount =
        monthEntries.where((e) => e.value.type == 'hiit').length;
    final totalVol = monthEntries.fold(
        0.0, (sum, e) => sum + (volumeByDay[e.key] ?? 0));

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
          rowHeight: 54,
          calendarStyle: CalendarStyle(
            outsideDaysVisible: true,
            cellMargin: EdgeInsets.zero,
            cellPadding: EdgeInsets.zero,
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600),
            leftChevronIcon: const Icon(Icons.chevron_left,
                color: AppTheme.textMid),
            rightChevronIcon: const Icon(Icons.chevron_right,
                color: AppTheme.textMid),
          ),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (_, __, ___) => const SizedBox.shrink(),
            defaultBuilder: (_, day, __) => _DayCell(
              day: day,
              sessionsByDay: sessionsByDay,
              volumeByDay: volumeByDay,
            ),
            todayBuilder: (_, day, __) => _DayCell(
              day: day,
              sessionsByDay: sessionsByDay,
              volumeByDay: volumeByDay,
              isToday: true,
              isSelected: _selectedDay == null || isSameDay(_selectedDay, day),
            ),
            selectedBuilder: (_, day, __) => _DayCell(
              day: day,
              sessionsByDay: sessionsByDay,
              volumeByDay: volumeByDay,
              isSelected: true,
            ),
            outsideBuilder: (_, day, __) => _DayCell(
              day: day,
              sessionsByDay: sessionsByDay,
              volumeByDay: volumeByDay,
              isOutside: true,
            ),
          ),
        ),
        // ── Month totals ──────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.line),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _MonthStat(
                    value: '$strengthCount',
                    label: 'FUERZA',
                    color: AppTheme.fuerza),
                Container(
                    width: 1, height: 28, color: AppTheme.line),
                _MonthStat(
                    value: '$hiitCount',
                    label: 'HIIT',
                    color: AppTheme.hiit),
                Container(
                    width: 1, height: 28, color: AppTheme.line),
                _MonthStat(
                  value:
                      totalVol > 0 ? totalVol.toStringAsFixed(0) : '—',
                  label: 'VOL TOTAL',
                  color: AppTheme.fuerza,
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 1),
        // ── Selected day detail ───────────────────────────────────
        Expanded(
          child: _SelectedDayCard(
            selectedDay: selected,
            session: sessionsByDay[selectedNorm],
            volume: volumeByDay[selectedNorm] ?? 0,
          ),
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.sessionsByDay,
    required this.volumeByDay,
    this.isToday = false,
    this.isSelected = false,
    this.isOutside = false,
  });

  final DateTime day;
  final Map<DateTime, WorkoutSession> sessionsByDay;
  final Map<DateTime, double> volumeByDay;
  final bool isToday;
  final bool isSelected;
  final bool isOutside;

  @override
  Widget build(BuildContext context) {
    final norm = DateTime(day.year, day.month, day.day);
    final session = sessionsByDay[norm];
    final vol = volumeByDay[norm];
    final isHiit = session?.type == 'hiit';
    final color = session == null
        ? null
        : isHiit
            ? AppTheme.hiit
            : AppTheme.fuerza;

    return Opacity(
      opacity: isOutside ? 0.4 : 1.0,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: session != null ? AppTheme.bgCard : null,
            border: Border.all(
              color: isSelected
                  ? (color ?? AppTheme.textMid)
                  : isToday
                      ? (color ?? AppTheme.textMid).withValues(alpha: 0.4)
                      : session != null
                          ? AppTheme.line
                          : Colors.transparent,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Vol + number
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 4, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (vol != null && vol > 0)
                      Text(
                        vol.toStringAsFixed(0),
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 7,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      )
                    else
                      const SizedBox(height: 9),
                    Expanded(
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isToday
                                ? (color ?? AppTheme.text)
                                : AppTheme.text,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Accent bar at bottom
              if (color != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(height: 3, color: color),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthStat extends StatelessWidget {
  const _MonthStat(
      {required this.value,
      required this.label,
      required this.color});
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 3),
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

class _SelectedDayCard extends StatelessWidget {
  const _SelectedDayCard({
    required this.selectedDay,
    this.session,
    required this.volume,
  });
  final DateTime selectedDay;
  final WorkoutSession? session;
  final double volume;

  @override
  Widget build(BuildContext context) {
    if (session == null) {
      return const Center(
        child: Text('Sin entrenamiento',
            style: TextStyle(color: AppTheme.textMid)),
      );
    }
    final isHiit = session!.type == 'hiit';
    final color = isHiit ? AppTheme.hiit : AppTheme.fuerza;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDate(selectedDay),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isHiit ? 'HIIT' : 'Fuerza',
                      style:
                          TextStyle(color: color, fontSize: 13),
                    ),
                  ],
                ),
              ),
              if (!isHiit && volume > 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      volume.toStringAsFixed(0),
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.fuerza,
                      ),
                    ),
                    Text(
                      'VOL',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 9,
                        color: AppTheme.textDim,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    DayDetailScreen(date: selectedDay),
              ),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: color,
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
  const days = [
    'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'
  ];
  const months = [
    'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
  ];
  return '${days[d.weekday - 1]} ${d.day} ${months[d.month - 1]}';
}
