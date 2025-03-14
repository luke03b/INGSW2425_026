import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:domus_app/back_end_communication/dto/annuncio/annuncio_dto.dart';
import 'package:domus_app/back_end_communication/dto/previsioni_meteo_dto.dart';
import 'package:domus_app/back_end_communication/dto/visita_dto.dart';
import 'package:domus_app/ui_elements/utils/my_previsioni_meteo_ui_provider.dart';
import 'package:domus_app/pages/cliente_pages/visita_pages/cliente_fasce_orarie_visita_page.dart';

class WeatherListWidget extends StatelessWidget {
  final AnnuncioDto annuncioSelezionato;
  final List<VisitaDto> listaVisite;
  final PrevisioniMeteoDto previsioniMeteo;

  const WeatherListWidget({
    super.key,
    required this.annuncioSelezionato,
    required this.listaVisite,
    required this.previsioniMeteo,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final filteredDates = previsioniMeteo.daily.time
      .where((date) => date != today && DateTime.parse(date).weekday != DateTime.sunday)
      .toList();


    final filteredMaxTemps = <double>[];
    final filteredMinTemps = <double>[];
    final filteredWeatherCodes = <int>[];

    for (int i = 0; i < previsioniMeteo.daily.time.length; i++) {
      if (previsioniMeteo.daily.time[i] != today) {
        filteredMaxTemps.add(previsioniMeteo.daily.temperaturaMax[i]);
        filteredMinTemps.add(previsioniMeteo.daily.temperaturaMin[i]);
        filteredWeatherCodes.add(previsioniMeteo.daily.weatherCode[i]);
      }
    }

    return ListView.builder(
      itemCount: filteredDates.length,
      itemBuilder: (context, index) {
        final date = filteredDates[index];
        DateTime dataBuona = DateTime.parse(date);
        String dataFormattataBene = DateFormat('dd-MM').format(dataBuona);
        final maxTemp = filteredMaxTemps[index];
        final minTemp = filteredMinTemps[index];
        final weatherCode = filteredWeatherCodes[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClienteFasceOrarieVisita(
                  annuncioSelezionato: annuncioSelezionato,
                  listaVisite: listaVisite,
                  hourlyData: previsioniMeteo.hourly,
                  selectedDate: date,
                ),
              ),
            );
          },
          child: Card(
            color: MyPrevisioniMeteoUiProvider.getWeatherColor(weatherCode, context),
            child: ListTile(
              title: Text(
                "Data: $dataFormattataBene",
                style: TextStyle(color: Theme.of(context).colorScheme.outline),
              ),
              subtitle: Text(
                "Max: $maxTemp°C, Min: $minTemp°C",
                style: TextStyle(color: Theme.of(context).colorScheme.outline),
              ),
              leading: Icon(
                MyPrevisioniMeteoUiProvider.getWeatherIcon(weatherCode),
                color: Theme.of(context).colorScheme.outline,
              ),
              trailing: Icon(
                Icons.arrow_circle_right_outlined,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
        );
      },
    );
  }
}