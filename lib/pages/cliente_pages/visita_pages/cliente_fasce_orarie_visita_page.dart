import 'dart:async';

import 'package:domus_app/ui_elements/utils/my_loading.dart';
import 'package:flutter/material.dart';
import 'package:domus_app/back_end_communication/dto/annuncio/annuncio_dto.dart';
import 'package:domus_app/back_end_communication/dto/previsioni_meteo_dto.dart';
import 'package:domus_app/back_end_communication/dto/visita_dto.dart';
import 'package:domus_app/ui_elements/utils/my_previsioni_meteo_ui_provider.dart';
import 'package:domus_app/ui_elements/utils/my_pop_up_widgets.dart';
import 'package:domus_app/ui_elements/utils/formatStrings.dart';
import 'package:domus_app/back_end_communication/class_services/visita_service.dart';
import 'package:domus_app/back_end_communication/communication_utils/status_code_controller.dart';
import 'package:intl/intl.dart';

class ClienteFasceOrarieVisita extends StatefulWidget {
  final PrevisioniMeteoOrarieDto hourlyData;
  final String selectedDate;
  final AnnuncioDto annuncioSelezionato;
  final List<VisitaDto> listaVisite;

  const ClienteFasceOrarieVisita({
    super.key,
    required this.annuncioSelezionato,
    required this.listaVisite,
    required this.hourlyData,
    required this.selectedDate,
  });

  @override
  _ClienteFasceOrarieVisitaState createState() => _ClienteFasceOrarieVisitaState();
}

class _ClienteFasceOrarieVisitaState extends State<ClienteFasceOrarieVisita> {
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
      .map((visita) {
        // Estrai solo l'ora dall'orario prenotato e formatta come "HH:00"
        final oraPrenotata = int.parse(visita.orarioInizio.split(":")[0]);
        return "${oraPrenotata.toString().padLeft(2, '0')}:00";
      })
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
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        title: Text("Fasce orarie", style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 5,
        shadowColor: Theme.of(context).colorScheme.shadow,
      ),
      body: _myListaOrariVisitabili(filteredData, context),
    );
  }

  ListView _myListaOrariVisitabili(List<Map<String, dynamic>?> filteredData, BuildContext context) {
    return ListView.builder(
      itemCount: filteredData.length,
      itemBuilder: (context, index) {
        final entry = filteredData[index];
        final time = entry!["time"].substring(11, 16);
        final temp = entry["temperature"];
        final weatherCode = entry["weatherCode"];

        return GestureDetector(
          onTap: () {
            showDialog(
              context: context, 
              builder: (BuildContext context) => 
                MyOptionsDialog(
                  title: "Conferma", 
                  bodyText: "Vuoi prenotare una visita per il giorno ${widget.selectedDate} alle ore $time?", 
                  leftButtonText: "No", 
                  leftButtonColor: Theme.of(context).colorScheme.scrim, 
                  rightButtonText: "Si", 
                  rightButtonColor: Theme.of(context).colorScheme.tertiary, 
                  onPressLeftButton: (){Navigator.pop(context);}, 
                  onPressRightButton: () async {
                    try {
                      LoadingHelper.showLoadingDialogNotDissmissible(context);
                      int statusCode = await VisitaService.creaVisita(widget.annuncioSelezionato, widget.selectedDate, time);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      await StatusCodeController.controllaStatusCodeAndShowPopUp(context, statusCode, 201, "Conferma", "Visita creata", "Errore", "Visita non creata");
                    } on TimeoutException {
                      Navigator.pop(context);
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
                      Navigator.pop(context);
                      showDialog(
                        context: context, 
                        builder: (BuildContext context) => MyInfoDialog(
                          title: "Errore",
                          bodyText: "Visita non creata. ${e.toString()}.", 
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
              title: Text("Orario: $time - ${int.parse(FormatStrings.formattaOrario(time)) + 1}:00", style: TextStyle(color: Theme.of(context).colorScheme.outline),),
              subtitle: Text("Temp: $temp°C", style: TextStyle(color: Theme.of(context).colorScheme.outline),),
              leading: Icon(MyPrevisioniMeteoUiProvider.getWeatherIcon(weatherCode), color: Theme.of(context).colorScheme.outline,),
              trailing: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                children: <Widget>[
                  Icon(Icons.arrow_circle_right_outlined, color: Theme.of(context).colorScheme.outline),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}