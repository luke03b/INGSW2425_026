import 'dart:convert';
import 'package:domus_app/utils/my_pop_up_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_file.dart';
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
  final double latitude;
  final double longitude;

  const WeatherScreen({super.key, required this.latitude, required this.longitude});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final String apiUrl = "https://api.open-meteo.com/v1/forecast";
  Map<String, dynamic>? weatherData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWeather(widget.latitude, widget.longitude);
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
          color: Theme.of(context).colorScheme.surface,
        ),
        title: Text("Previsioni Meteo", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 5,
        shadowColor: Colors.black,
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

  HourlyWeatherScreen({required this.hourlyData, required this.selectedDate});

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
          color: Theme.of(context).colorScheme.surface,
        ),
        title: Text("Fasce orarie", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 5,
        shadowColor: Colors.black,
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
                    leftButtonColor: Colors.grey, 
                    rightButtonText: "Si", 
                    rightButtonColor: Theme.of(context).colorScheme.tertiary, 
                    onPressLeftButton: (){Navigator.pop(context);}, 
                    onPressRightButton: (){}
                  )
                );
              },
            child: Card(
              color: _getWeatherColor(weatherCode),
              child: ListTile(
                title: Text("Ora: $time"),
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
}