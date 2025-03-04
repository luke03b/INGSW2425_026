import 'dart:async';

import 'package:domus_app/back_end_communication/class_services/visita_service.dart';
import 'package:domus_app/back_end_communication/dto/visita_dto.dart';
import 'package:domus_app/costants/enumerations.dart';
import 'package:domus_app/pages/agente_pages/agente_annuncio_page.dart';
import 'package:domus_app/services/formatStrings.dart';
import 'package:domus_app/ui_elements/theme/ui_constants.dart';
import 'package:domus_app/ui_elements/utils/my_ui_messages_widgets.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AgenteCalendarioPrenotazioniPage extends StatefulWidget {
  const AgenteCalendarioPrenotazioniPage({super.key});

  @override
  State<AgenteCalendarioPrenotazioniPage> createState() =>
      _AgenteCalendarioPrenotazioniPageState();
}

class _AgenteCalendarioPrenotazioniPageState extends State<AgenteCalendarioPrenotazioniPage> {
  late final ValueNotifier<List<VisitaDto>> _visiteSelezionate;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  bool areServersAvailable = false;
  bool areDataRetrieved = false;
  bool hasAgenteVisite = false;
  List<VisitaDto> listaVisite = [];

  void getVisiteInAttesa() async {
    try{
      List<VisitaDto> data = await VisitaService.recuperaTutteOfferteConStatoByAgenteLoggato(Enumerations.statoVisite[1]);
      if (mounted) {
        setState(() {
          listaVisite = data;
          hasAgenteVisite = listaVisite.isNotEmpty;
          areDataRetrieved = true;
          areServersAvailable = true;
        });
      }
    } on TimeoutException {
      if (mounted) {
        setState(() {
          areServersAvailable = false;
          areDataRetrieved = true;
        });
      }
    } catch (error) {
      setState(() {
        areServersAvailable = false;
        areDataRetrieved = true;
      });
      print('Errore con il recupero delle visite (il server potrebbe non essere raggiungibile) $error');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Esegui getAnnunci dopo la fase di build
    Future.delayed(Duration.zero, () {
      getVisiteInAttesa();
    });
  }

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _visiteSelezionate = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _visiteSelezionate.dispose();
    super.dispose();
  }

  List<VisitaDto> _getEventsForDay(DateTime giornoSelezionato) {
    return listaVisite.where((visita) {
      return FormatStrings.formattaDataGGMMAAAA(visita.data) == FormatStrings.formattaDataGGMMAAAA(giornoSelezionato);
    }).toList();
  }

  List<VisitaDto> _getEventsForRange(DateTime start, DateTime end) {
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

      _visiteSelezionate.value = _getEventsForDay(selectedDay);
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
      _visiteSelezionate.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _visiteSelezionate.value = _getEventsForDay(start);
    } else if (end != null) {
      _visiteSelezionate.value = _getEventsForDay(end);
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
      body: switch ((areDataRetrieved, areServersAvailable, hasAgenteVisite)) {
            (false, _, _) => MyUiMessagesWidgets.myTextWithLoading(context, "Sto recuperando i tuoi impegni, un po' di pazienza"),
            (true, false, _) => MyUiMessagesWidgets.myErrorWithButton(
              context, 
              "Server non raggiungibili. Controlla la tua connessione a internet e riprova", 
              "Riprova", 
              (){
                setState(() {
                  hasAgenteVisite = false;
                  areDataRetrieved = false;
                  areServersAvailable = false;
                });
                getVisiteInAttesa();
              }
            ),
            (true, true, false) => MyUiMessagesWidgets.myText(context, "Non hai visite prenotate"),
            (true, true, true) => myTableCalendar(context),
          },
    );
  }

  Column myTableCalendar(BuildContext context) {
    return Column(
            children: [
              TableCalendar<VisitaDto>(
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
                  child: ValueListenableBuilder<List<VisitaDto>>(
                    valueListenable: _visiteSelezionate,
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
                              color: context.onPrimaryContainer,
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ListTile(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AgenteAnnuncioPage(annuncioSelezionato: value[index].annuncio))),
                              title: Column(
                                children: [
                                  Text(value[index].annuncio.indirizzo, style: TextStyle(color: context.outline),),
                                  Row(
                                    children: [
                                      Text("${value[index].cliente.nome} ${value[index].cliente.cognome}", style: TextStyle(color: context.outline),),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(value[index].cliente.email, style: TextStyle(color: context.outline),),
                                    ],
                                  ),
                                ],
                              ),
                            subtitle: Text('${FormatStrings.formattaDataGGMMAAAA(value[index].data)} ${FormatStrings.formattaOrario(value[index].orarioInizio)} - ${FormatStrings.formattaOrario(value[index].orarioFine!)}', style: TextStyle(color: context.outline),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ]
          );
  }
}