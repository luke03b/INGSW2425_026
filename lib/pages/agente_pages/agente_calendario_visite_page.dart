import 'package:domus_app/theme/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AgenteCalendarioPrenotazioniPage extends StatefulWidget {
  const AgenteCalendarioPrenotazioniPage({super.key});

  @override
  State<AgenteCalendarioPrenotazioniPage> createState() =>
      _AgenteCalendarioPrenotazioniPageState();
}

class _AgenteCalendarioPrenotazioniPageState
    extends State<AgenteCalendarioPrenotazioniPage> {
  late final ValueNotifier<List<Map<String, dynamic>>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  final List<Map<String, dynamic>> listaEventi = [
    {
      'indirizzo': 'Via dalmazia, 13 Cavalleggeri (NA)',
      'data_e_ora': '04-02-2025 11:00'
    },
    {
      'indirizzo': 'Via raviscanina, 14 Rav (NA)',
      'data_e_ora': '14-02-2025 15:00'
    },
    {
      'indirizzo': 'Via orta d\'atella, 10 Orta (NA)',
      'data_e_ora': '14-02-2025 10:00'
    },
  ];

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    //recupera giorno-mese-anno dalla lista di eventi fittizi
    String giornoSelezionato = "${day.day.toString().padLeft(2, '0')}-${day.month.toString().padLeft(2, '0')}-${day.year}";

    return listaEventi.where((evento) {
      String dataEvento = evento['data_e_ora'].split(' ')[0];
      return dataEvento == giornoSelezionato;
    }).toList();
  }

  List<Map<String, dynamic>> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  List<DateTime> daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
      (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: context.surface,
        ),
        title: Text(
          "Calendario prenotazioni",
          style: TextStyle(color: context.onSecondary),
        ),
        centerTitle: true,
        backgroundColor: context.primary,
        elevation: 5,
        shadowColor: context.shadow,
      ),
      body: Column(
        children: [
          TableCalendar<Map<String, dynamic>>(
            weekendDays: [DateTime.sunday],
            enabledDayPredicate: (day) {
            // Rende la domenica non cliccabile
              return day.weekday != DateTime.sunday;
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(fontSize: 17.0, color: context.onSecondary),
            ),
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(Duration(days: 14)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              todayTextStyle: TextStyle(color: context.onPrimary),
              defaultTextStyle: TextStyle(color: context.onPrimary),
              defaultDecoration: BoxDecoration(
                  color: context.onPrimaryContainer,
                  shape: BoxShape.circle),
              rangeStartDecoration: BoxDecoration(
                  color: context.tertiary,
                  shape: BoxShape.circle),
              rangeEndDecoration: BoxDecoration(
                  color: context.tertiary,
                  shape: BoxShape.circle),
              rangeHighlightColor: context.tertiary,
              selectedDecoration: BoxDecoration(
                  color: context.onSecondary,
                  shape: BoxShape.circle),
              todayDecoration: BoxDecoration(
                  color: context.primary,
                  shape: BoxShape.circle),
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        title: Text('${value[index]['indirizzo']}'),
                        subtitle: Text('${value[index]['data_e_ora']}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}