import 'dart:async';
import 'dart:convert';
import 'package:domus_app/back_end_communication/class_services/visita_service.dart';
import 'package:domus_app/back_end_communication/dto/annuncio_dto.dart';
import 'package:domus_app/back_end_communication/dto/visita_dto.dart';
import 'package:domus_app/services/formatStrings.dart';
import 'package:domus_app/theme/ui_constants.dart';
import 'package:domus_app/utils/my_pop_up_widgets.dart';
import 'package:domus_app/utils/my_ui_messages_widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

IconData _getWeatherIcon(int weatherCode) {
    switch (weatherCode) {
      case 0:
        return Icons.wb_sunny;
      case 1:
      case 2:
      case 3:
      case 45:
      case 48:
        return Icons.cloud;
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
      case 95:
      case 96:
      case 99:
        return Icons.water_drop;
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return Icons.ac_unit;
      default:
        return Icons.help_outline;
    }
  }

  Color _getWeatherColor(int weatherCode, BuildContext context) {
    switch (weatherCode) {
      case 0:
        return context.primaryFixed;
      case 1:
      case 2:
      case 3:
      case 45:
      case 48:
        return context.secondaryFixed;
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
      case 95:
      case 96:
      case 99:
        return context.tertiaryFixedDim;
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return context.surfaceBright;
      default:
        return context.secondaryFixedDim;
    }
  }


class ClienteCreaVisitaPage extends StatefulWidget {
  final AnnuncioDto annuncioSelezionato;

  const ClienteCreaVisitaPage({super.key, required this.annuncioSelezionato});

  @override
  _ClienteCreaVisitaPageState createState() => _ClienteCreaVisitaPageState();
}

class _ClienteCreaVisitaPageState extends State<ClienteCreaVisitaPage> {
  final String apiUrl = "https://api.open-meteo.com/v1/forecast";
  Map<String, dynamic>? weatherData;
  bool isLoading = true;
  bool areServersAvailable = false;
  bool areDataRetrieved = false;
  bool hasAnnuncioOfferte = false;

  Future<void> getVisiteAnnuncio() async {
  try {
    List<VisitaDto> data = await VisitaService.recuperaVisiteAnnuncio(widget.annuncioSelezionato);
    if (mounted) {
      setState(() {
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
    print('Errore con il recupero delle offerte (il server potrebbe non essere raggiungibile) $error');
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

  Future<void> recuperaPrevisioniMeteo(double latitude, double longitude) async {
    final url = Uri.parse(
        "$apiUrl?latitude=$latitude&longitude=$longitude&daily=temperature_2m_max,temperature_2m_min,weathercode&hourly=temperature_2m,weathercode&timezone=Europe/Rome&forecast_days=14");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          weatherData = jsonDecode(response.body);
          print(response.body);
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load weather data");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error: $e");
    }
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : weatherData != null
              ? buildWeatherList()
              : Center(child: Text("Impossibile caricare i dati meteo.")),
    );
  }

  Widget buildWeatherList() {
    final dailyData = weatherData!["daily"];
    final dates = dailyData["time"];
    final maxTemps = dailyData["temperature_2m_max"];
    final minTemps = dailyData["temperature_2m_min"];
    final weatherCodes = dailyData["weathercode"];
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
        final availability = availabities;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClienteFasceOrarieVisita(
                  annuncioSelezionato: widget.annuncioSelezionato,
                  hourlyData: weatherData!["hourly"],
                  selectedDate: date,
                ),
              ),
            );
          },
          child: Card(
            color: _getWeatherColor(weatherCode, context),
            child: ListTile(
              title: Text("Data: $dataFormattataBene", style: TextStyle(color: context.outline),),
              subtitle: Text("Max: $maxTemp°C, Min: $minTemp°C", style: TextStyle(color: context.outline),),
              leading: Icon(_getWeatherIcon(weatherCode), color: context.outline,),
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
  final Map<String, dynamic> hourlyData;
  final String selectedDate;
  final AnnuncioDto annuncioSelezionato;

  const ClienteFasceOrarieVisita({super.key, required this.annuncioSelezionato, required this.hourlyData, required this.selectedDate});

  @override
  _ClienteFasceOrarieVisitaState createState() => _ClienteFasceOrarieVisitaState();
}

class _ClienteFasceOrarieVisitaState extends State<ClienteFasceOrarieVisita> {
  bool areServersAvailable = false;
  bool areDataRetrieved = false;
  bool hasAnnuncioVisitePrenotabili = false;
  List<VisitaDto> listaVisite = [];


  Future<void> getVisiteAnnuncio() async {
  try {
    List<VisitaDto> data = await VisitaService.recuperaVisiteAnnuncio(widget.annuncioSelezionato);
    if (mounted) {
      setState(() {
        listaVisite = data;
        hasAnnuncioVisitePrenotabili = listaVisite.isNotEmpty;
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
    print('Errore con il recupero delle offerte (il server potrebbe non essere raggiungibile) $error');
  }
}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Esegui dopo la fase di build
    Future.delayed(Duration.zero, () {
      getVisiteAnnuncio();
    });
  }

  @override
  Widget build(BuildContext context) {
    final times = widget.hourlyData["time"];
    final temperatures = widget.hourlyData["temperature_2m"];
    final weatherCodes = widget.hourlyData["weathercode"];
    DateTime dataBuona = DateTime.parse(widget.selectedDate);
    String dataFormattataBene = DateFormat('dd-MM').format(dataBuona);

//     // Filtra i dati orari per la data selezionata
//     final filteredData = List.generate(times.length, (index) {
//       if (times[index].startsWith(widget.selectedDate)) {
//         final hour = DateTime.parse(times[index]).hour;
//         if (hour >= 9 && hour < 13 || hour >= 14 && hour < 18) {
//           return {
//             "time": times[index],
//             "temperature": temperatures[index],
//             "weatherCode": weatherCodes[index]
//           };
//         }
//       }
//       return null;
//     }).where((element) => element != null).toList();

        // Converti le visite prenotate in un set di orari prenotati per un confronto rapido
    final Set<String> orariPrenotati = listaVisite
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
      body: switch ((areDataRetrieved, areServersAvailable, hasAnnuncioVisitePrenotabili)) {
                (false, _, _) => MyUiMessagesWidgets.myTextWithLoading(context, "Sto recuperando le tue attività recenti, un po' di pazienza"),
                (true, false, _) => MyUiMessagesWidgets.myErrorWithButton(context, 
                                      "Server non raggiungibili. Controlla la tua connessione a internet e riprova", 
                                      "Riprova", 
                                      (){
                                        setState(() {
                                          hasAnnuncioVisitePrenotabili = false;
                                          areDataRetrieved = false;
                                          areServersAvailable = false;
                                        });
                                        getVisiteAnnuncio();
                                      }
                                    ),
                (true, true, false) => MyUiMessagesWidgets.myText(context, "Benvenuto! Non hai ancora annunci visitati di recente"),
                (true, true, true) => myListaOrariVisitabili(filteredData, context),
            }
    );
  }

  ListView myListaOrariVisitabili(List<Map<String, dynamic>?> filteredData, BuildContext context) {
    return ListView.builder(
      itemCount: filteredData.length,
      itemBuilder: (context, index) {
        final entry = filteredData[index];
        final time = entry!["time"].substring(11, 16);
        final temp = entry["temperature"];
        final weatherCode = entry["weatherCode"];

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
                      controllaStatusCode(statusCode, context);
                    } on TimeoutException {
                      Navigator.pop(context);
                      showDialog(
                        context: context, 
                        builder: (BuildContext context) => MyInfoDialog(
                          title: "Connessione non riuscita", 
                          bodyText: "Visita non creata, la connessione con i nostri server non è stata stabilita correttamente. Riprova più tardi.", 
                          buttonText: "Ok", 
                          onPressed: () {Navigator.pop(context);}
                        )
                      );
                    } catch (e) {
                      print(e);
                      Navigator.pop(context);
                      showDialog(
                        context: context, 
                        builder: (BuildContext context) => MyInfoDialog(
                          title: "Errore",
                          bodyText: "Visista non creata. Hai già inoltrato una richiesta di visita per questo annuncio. Prima di poterne creare un'altra devi aspettare che un agente la esamini e la rifiuti.", 
                          buttonText: "Ok", 
                          onPressed: () {Navigator.pop(context);}
                        )
                      );
                    }
                  }
                )
              );
            },
          child: Card(
            color: _getWeatherColor(weatherCode, context),
            child: ListTile(
              title: Text("Orario: $time - ${int.parse(FormatStrings.formattaOrario(time)) + 1}:00", style: TextStyle(color: context.outline),),
              subtitle: Text("Temp: $temp°C", style: TextStyle(color: context.outline),),
              leading: Icon(_getWeatherIcon(weatherCode), color: context.outline,),
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

  void controllaStatusCode(int statusCode, BuildContext context) {
    if (statusCode == 201) {
      showDialog(
        context: context, 
        builder: (BuildContext context) => MyInfoDialog(
          title: "Conferma", 
          bodyText: "Visita creata", 
          buttonText: "Ok", 
          onPressed: () {Navigator.pop(context);}
        )
      );
    } else {
      showDialog(
        context: context, 
        builder: (BuildContext context) => MyInfoDialog(
          title: "Errore", 
          bodyText: "Visita non creata, controllare i campi e riprovare.", 
          buttonText: "Ok", 
          onPressed: () {Navigator.pop(context);}
        )
      );
    }
  }
}