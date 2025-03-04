import 'dart:async';
import 'package:domus_app/back_end_communication/class_services/previsioni_meteo_service.dart';
import 'package:domus_app/back_end_communication/class_services/visita_service.dart';
import 'package:domus_app/back_end_communication/communication_utils/status_code_controller.dart';
import 'package:domus_app/back_end_communication/dto/annuncio_dto.dart';
import 'package:domus_app/back_end_communication/dto/previsioni_meteo_dto.dart';
import 'package:domus_app/back_end_communication/dto/visita_dto.dart';
import 'package:domus_app/services/formatStrings.dart';
import 'package:domus_app/ui_elements/theme/ui_constants.dart';
import 'package:domus_app/ui_elements/utils/my_pop_up_widgets.dart';
import 'package:domus_app/ui_elements/utils/my_previsioni_meteo_ui_provider.dart';
import 'package:domus_app/ui_elements/utils/my_ui_messages_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClienteCreaVisitaPage extends StatefulWidget {
  final AnnuncioDto annuncioSelezionato;

  const ClienteCreaVisitaPage({super.key, required this.annuncioSelezionato});

  @override
  _ClienteCreaVisitaPageState createState() => _ClienteCreaVisitaPageState();
}

class _ClienteCreaVisitaPageState extends State<ClienteCreaVisitaPage> {
  bool areOursServersAvailable = false;
  bool areOpenMeteoServersAvailable = false;
  bool areVisiteRetrieved = false;
  bool arePrevisioniMeteoRetrieved = false;
  bool hasAnnuncioVisite = false;
  List<VisitaDto> listaVisite = [];
  PrevisioniMeteoDto? previsioniMeteo;

  Future<void> getVisiteAnnuncio() async {
    try {
      listaVisite = await VisitaService.recuperaVisiteAnnuncio(widget.annuncioSelezionato);
      if (mounted) {
        setState(() {
          areVisiteRetrieved = true;
          areOursServersAvailable = true;
        });
      }
    } on TimeoutException {
      if (mounted) {
        setState(() {
          areVisiteRetrieved = true;
          areOursServersAvailable = false;
        });
      }
    } catch (error) {
      setState(() {
        areVisiteRetrieved = true;
        areOursServersAvailable = false;
      });
      print('Errore con il recupero delle visite (il server potrebbe non essere raggiungibile) $error');
    }
  }

  Future<void> recuperaPrevisioniMeteo(double latitudine, double longitudine) async {
    try {
      previsioniMeteo = await PrevisioniMeteoService.recuperaPrevisioniMeteo(latitudine, longitudine);
      if (mounted) {
        setState(() {
          arePrevisioniMeteoRetrieved = true;
          areOpenMeteoServersAvailable = true;
        });
      }
    } on TimeoutException {
      if (mounted) {
        setState(() {
          arePrevisioniMeteoRetrieved = true;
          areOpenMeteoServersAvailable = false;
        });
      }
    } catch (error) {
      setState(() {
        arePrevisioniMeteoRetrieved = true;
        areOpenMeteoServersAvailable = false;
      });
      print('Errore con il recupero delle previsioni meteo (il server potrebbe non essere raggiungibile) $error');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Esegui dopo la fase di build
    Future.delayed(Duration.zero, () {
      recuperaPrevisioniMeteo(widget.annuncioSelezionato.latitudine, widget.annuncioSelezionato.longitudine);
      getVisiteAnnuncio();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: context.onSecondary,
        ),
        title: Text("Previsioni Meteo", style: TextStyle(color: context.onSecondary),),
        centerTitle: true,
        backgroundColor: context.primary,
        elevation: 5,
        shadowColor: context.shadow,
      ),
      body: switch ((areVisiteRetrieved, areOursServersAvailable, arePrevisioniMeteoRetrieved, areOpenMeteoServersAvailable)) {
              (false, _, _, _) => MyUiMessagesWidgets.myTextWithLoading(
                    context,
                    "Sto recuperando le previsioni meteo, un po' di pazienza",
                  ),
              (true, false, _, _) => MyUiMessagesWidgets.myErrorWithButton(
                    context,
                    "Server non raggiungibili. Controlla la tua connessione a internet e riprova",
                    "Riprova",
                    () {
                      setState(() {
                        arePrevisioniMeteoRetrieved = false;
                        areVisiteRetrieved = false;
                        areOursServersAvailable = false;
                        areOpenMeteoServersAvailable = false;
                      });
                      getVisiteAnnuncio();
                    },
                  ),
              (true, true, false, _) => MyUiMessagesWidgets.myTextWithLoading(
                    context,
                    "Sto recuperando le previsioni meteo, un po' di pazienza",
                  ),
              (true, true, true, false) => MyUiMessagesWidgets.myErrorWithButton(
                    context,
                    "Open Meteo non risponde. Controlla la tua connessione a internet e riprova",
                    "Riprova",
                    () {
                      setState(() {
                        arePrevisioniMeteoRetrieved = false;
                        areVisiteRetrieved = false;
                        areOpenMeteoServersAvailable = false;
                        areOursServersAvailable = false;
                      });
                      getVisiteAnnuncio();
                    },
                  ),
              (true, true, true, true) => buildWeatherList(context),
            }
    );
  }

  Widget buildWeatherList(BuildContext context) {
    final dates = previsioniMeteo!.daily.time;
    final maxTemps = previsioniMeteo!.daily.temperaturaMax;
    final minTemps = previsioniMeteo!.daily.temperaturaMin;
    final weatherCodes = previsioniMeteo!.daily.weatherCode;
    final availabities = false;

    return ListView.builder(
      itemCount: dates.length,
      itemBuilder: (context, index) {
        final date = dates[index];
        DateTime dataBuona = DateTime.parse(date);
        String dataFormattataBene = DateFormat('dd-MM').format(dataBuona); 
        final maxTemp = maxTemps[index];
        final minTemp = minTemps[index];
        final weatherCode = weatherCodes[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClienteFasceOrarieVisita(
                  annuncioSelezionato: widget.annuncioSelezionato,
                  listaVisite: listaVisite,
                  hourlyData: previsioniMeteo!.hourly,
                  selectedDate: date,
                ),
              ),
            );
          },
          child: Card(
            color: MyPrevisioniMeteoUiProvider.getWeatherColor(weatherCode, context),
            child: ListTile(
              title: Text("Data: $dataFormattataBene", style: TextStyle(color: context.outline),),
              subtitle: Text("Max: $maxTemp°C, Min: $minTemp°C", style: TextStyle(color: context.outline),),
              leading: Icon(MyPrevisioniMeteoUiProvider.getWeatherIcon(weatherCode), color: context.outline,),
              trailing: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12, // space between two icons
                children: <Widget>[
                  Icon(Icons.arrow_circle_right_outlined, color: context.outline),
                ],
              ),
              
            ),
          ),
        );
      },
    );
  }
}



class ClienteFasceOrarieVisita extends StatefulWidget {
  final PrevisioniMeteoOrarieDto hourlyData;
  final String selectedDate;
  final AnnuncioDto annuncioSelezionato;
  final List<VisitaDto> listaVisite;

  const ClienteFasceOrarieVisita({super.key, required this.annuncioSelezionato, required this.listaVisite, required this.hourlyData, required this.selectedDate});

  @override
  _ClienteFasceOrarieVisitaState createState() => _ClienteFasceOrarieVisitaState();
}

class _ClienteFasceOrarieVisitaState extends State<ClienteFasceOrarieVisita> {
  bool hasAnnuncioVisitePrenotabili = false;

  @override
  Widget build(BuildContext context) {
    final times = widget.hourlyData.time;
    final temperatures = widget.hourlyData.temperatura2m;
    final weatherCodes = widget.hourlyData.weatherCode;
    DateTime dataBuona = DateTime.parse(widget.selectedDate);
    String dataFormattataBene = DateFormat('dd-MM').format(dataBuona);

    // Converti le visite prenotate in un set di orari prenotati per un confronto rapido
    final Set<String> orariPrenotati = widget.listaVisite
        .where((visita) => visita.data == dataBuona)
        .map((visita) => visita.orarioInizio)
        .toSet();

    // Filtra i dati orari per la data selezionata e rimuove quelli già prenotati
    final filteredData = List.generate(times.length, (index) {
      if (times[index].startsWith(widget.selectedDate)) {
        final hour = DateTime.parse(times[index]).hour;
        final formattedHour = "${hour.toString().padLeft(2, '0')}:00";

        if ((hour >= 9 && hour < 13 || hour >= 14 && hour < 18) && 
            !orariPrenotati.contains(formattedHour)) {
          return {
            "time": times[index],
            "temperature": temperatures[index],
            "weatherCode": weatherCodes[index]
          };
        }
      }
      return null;
    }).where((element) => element != null).toList();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: context.onSecondary,
        ),
        title: Text("Fasce orarie", style: TextStyle(color: context.onSecondary),),
        centerTitle: true,
        backgroundColor: context.primary,
        elevation: 5,
        shadowColor: context.shadow,
      ),
      body: myListaOrariVisitabili(filteredData, context));
  }

  ListView myListaOrariVisitabili(List<Map<String, dynamic>?> filteredData, BuildContext context) {
  return ListView.builder(
    itemCount: filteredData.length,
    itemBuilder: (context, index) {
      final entry = filteredData[index];
      final time = entry!["time"].substring(11, 16);
      final temp = entry["temperature"];
      final weatherCode = entry["weatherCode"];

      // Controlla se l'orario è già prenotato
      bool isTimeSlotBooked = widget.listaVisite.any((visita) {
        return visita.data == DateTime.parse(widget.selectedDate) && FormatStrings.formattaOrario(visita.orarioInizio) == time;
      });

      // Se l'orario è già prenotato, non mostrarlo
      if (isTimeSlotBooked) {
        return SizedBox.shrink(); // Non visualizzare nulla per questo orario
      }

      return GestureDetector(
        onTap: (){
          showDialog(
            context: context, 
            builder: (BuildContext context) => 
              MyOptionsDialog(
                title: "Conferma", 
                bodyText: "Vuoi prenotare una visita per il giorno ${widget.selectedDate} alle ore $time?", 
                leftButtonText: "No", 
                leftButtonColor: context.scrim, 
                rightButtonText: "Si", 
                rightButtonColor: context.tertiary, 
                onPressLeftButton: (){Navigator.pop(context);}, 
                onPressRightButton: () async {
                  try {
                    int statusCode = await VisitaService.creaVisita(widget.annuncioSelezionato, widget.selectedDate, time);
                    Navigator.pop(context);
                    await StatusCodeController.controllaStatusCodeAndShowPopUp(context, statusCode, 201, "Conferma", "Visita creata", "Errore", "Visita non creata");
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  } on TimeoutException {
                    Navigator.pop(context);
                    showDialog(
                      context: context, 
                      builder: (BuildContext context) => MyInfoDialog(
                        title: "Connessione non riuscita", 
                        bodyText: "Visita non creata, la connessione con i nostri server non è stata stabilita correttamente. Riprova più tardi.", 
                        buttonText: "Ok", 
                        onPressed: () {Navigator.pop(context);},
                      )
                    );
                  } catch (e) {
                    Navigator.pop(context);
                    showDialog(
                      context: context, 
                      builder: (BuildContext context) => MyInfoDialog(
                        title: "Errore",
                        bodyText: "Visita non creata. Hai già inoltrato una richiesta di visita per questo annuncio. Prima di poterne creare un'altra devi aspettare che un agente la esamini e la rifiuti.", 
                        buttonText: "Ok", 
                        onPressed: () {Navigator.pop(context);},
                      )
                    );
                  }
                }
              )
            );
        },
        child: Card(
          color: MyPrevisioniMeteoUiProvider.getWeatherColor(weatherCode, context),
          child: ListTile(
            title: Text("Orario: $time - ${int.parse(FormatStrings.formattaOrario(time)) + 1}:00", style: TextStyle(color: context.outline),),
            subtitle: Text("Temp: $temp°C", style: TextStyle(color: context.outline),),
            leading: Icon(MyPrevisioniMeteoUiProvider.getWeatherIcon(weatherCode), color: context.outline,),
            trailing: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12, // space between two icons
              children: <Widget>[
                Icon(Icons.arrow_circle_right_outlined, color: context.outline),
              ],
            ),
          ),
        ),
      );
    },
  );
}
}