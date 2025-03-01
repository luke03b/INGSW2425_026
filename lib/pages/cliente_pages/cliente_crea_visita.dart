import 'dart:async';
import 'dart:convert';
import 'package:domus_app/back_end_communication/class_services/visita_service.dart';
import 'package:domus_app/back_end_communication/dto/annuncio_dto.dart';
import 'package:domus_app/back_end_communication/dto/visita_dto.dart';
import 'package:domus_app/theme/ui_constants.dart';
import 'package:domus_app/utils/my_pop_up_widgets.dart';
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

  Color _getWeatherColor(int weatherCode) {
    switch (weatherCode) {
      case 0:
        return Colors.orange[200]!;
      case 1:
      case 2:
      case 3:
      case 45:
      case 48:
        return Colors.grey[300]!;
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
        return Colors.blue[200]!;
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return Colors.lightBlue[100]!;
      default:
        return Colors.white;
    }
  }


class WeatherScreen extends StatefulWidget {
  final AnnuncioDto annuncioSelezionato;

  const WeatherScreen({super.key, required this.annuncioSelezionato});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final String apiUrl = "https://api.open-meteo.com/v1/forecast";
  Map<String, dynamic>? weatherData;
  bool isLoading = true;
  bool areServersAvailable = false;
  bool areDataRetrieved = false;
  bool hasAnnuncioOfferte = false;
  List<VisitaDto> listaVisite = [];

  Future<void> getVisiteAnnuncio() async {
  try {
    List<VisitaDto> data = await VisitaService.recuperaVisiteAnnuncio(widget.annuncioSelezionato);
    if (mounted) {
      setState(() {
        listaVisite = data;
        hasAnnuncioOfferte = listaVisite.isNotEmpty;
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
      fetchWeather(widget.annuncioSelezionato.latitudine, widget.annuncioSelezionato.longitudine);
      getVisiteAnnuncio();
    });
  }

  Future<void> fetchWeather(double latitude, double longitude) async {
    final url = Uri.parse(
        "$apiUrl?latitude=$latitude&longitude=$longitude&daily=temperature_2m_max,temperature_2m_min,weathercode&hourly=temperature_2m,weathercode&timezone=Europe/Rome&forecast_days=14");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          weatherData = jsonDecode(response.body);
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
                builder: (context) => HourlyWeatherScreen(
                  annuncioSelezionato: widget.annuncioSelezionato,
                  hourlyData: weatherData!["hourly"],
                  selectedDate: date,
                ),
              ),
            );
          },
          child: Card(
            color: _getWeatherColor(weatherCode),
            child: ListTile(
              title: Text("Data: $dataFormattataBene"),
              subtitle: Text("Max: $maxTemp°C, Min: $minTemp°C"),
              leading: Icon(_getWeatherIcon(weatherCode)),
              trailing: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12, // space between two icons
                children: <Widget>[
                  Text(availability ? "Orari disponibili" : "Orari non disponibili", style: TextStyle(color: availability ? Colors.green : Colors.red),),
                  Icon(Icons.arrow_circle_right_outlined),
                ],
              ),
              
            ),
          ),
        );
      },
    );
  }
}




class HourlyWeatherScreen extends StatelessWidget {
  final Map<String, dynamic> hourlyData;
  final String selectedDate;
  final AnnuncioDto annuncioSelezionato;

  HourlyWeatherScreen({required this.annuncioSelezionato, required this.hourlyData, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final times = hourlyData["time"];
    final temperatures = hourlyData["temperature_2m"];
    final weatherCodes = hourlyData["weathercode"];
    final availabities = false;
    DateTime dataBuona = DateTime.parse(selectedDate);
    String dataFormattataBene = DateFormat('dd-MM').format(dataBuona); 

    // Filtra i dati orari per la data selezionata
    final filteredData = List.generate(times.length, (index) {
      if (times[index].startsWith(selectedDate)) {
        final hour = DateTime.parse(times[index]).hour;
        if (hour >= 9 && hour < 13 || hour >= 14 && hour < 18) {
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
      body: ListView.builder(
        itemCount: filteredData.length,
        itemBuilder: (context, index) {
          final entry = filteredData[index];
          final time = entry!["time"].substring(11, 16);
          final temp = entry["temperature"];
          final weatherCode = entry["weatherCode"];
          final availability = availabities;

          return GestureDetector(
            onTap: (){
              showDialog(
                context: context, 
                builder: (BuildContext context) => 
                  MyOptionsDialog(
                    title: "Conferma", 
                    bodyText: "Vuoi prenotare una visita per il giorno $selectedDate alle ore $time?", 
                    leftButtonText: "No", 
                    leftButtonColor: context.scrim, 
                    rightButtonText: "Si", 
                    rightButtonColor: context.tertiary, 
                    onPressLeftButton: (){Navigator.pop(context);}, 
                    onPressRightButton: () async {
                      try {
                        int statusCode = await VisitaService.creaVisita(annuncioSelezionato, selectedDate, time);
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
                            bodyText: "Visista non creata. Il server potrebbe non essere raggiungibile. Riprova più tardi.", 
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
              color: _getWeatherColor(weatherCode),
              child: ListTile(
                title: Text("Orario: $time - ${time}"),
                subtitle: Text("Temp: $temp°C"),
                leading: Icon(_getWeatherIcon(weatherCode)),
                trailing: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12, // space between two icons
                children: <Widget>[
                  Text(availability ? "Disponibile" : "Non disponibile", style: TextStyle(color: availability ? Colors.green : Colors.red),),
                  Icon(Icons.arrow_circle_right_outlined),
                ],
              ),
              ),
            ),
          );
        },
      ),
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
          bodyText: "Visita non creato, controllare i campi e riprovare.", 
          buttonText: "Ok", 
          onPressed: () {Navigator.pop(context);}
        )
      );
    }
  }
}