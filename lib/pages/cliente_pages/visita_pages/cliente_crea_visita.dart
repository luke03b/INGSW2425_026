import 'package:domus_app/ui_elements/utils/weather_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:domus_app/back_end_communication/dto/annuncio/annuncio_dto.dart';
import 'package:domus_app/ui_elements/utils/my_ui_messages_widgets.dart';
import 'package:domus_app/providers/visita_provider.dart';

class ClienteCreaVisitaPage extends StatefulWidget {
  final AnnuncioDto annuncioSelezionato;

  const ClienteCreaVisitaPage({super.key, required this.annuncioSelezionato});

  @override
  _ClienteCreaVisitaPageState createState() => _ClienteCreaVisitaPageState();
}

class _ClienteCreaVisitaPageState extends State<ClienteCreaVisitaPage> {
  
   @override
  void initState() {
    super.initState();
    final visitaProvider = Provider.of<VisitaProvider>(context, listen: false);
    visitaProvider.recuperaPrevisioniMeteo(widget.annuncioSelezionato.latitudine, widget.annuncioSelezionato.longitudine);
    visitaProvider.getVisiteAnnuncio(widget.annuncioSelezionato);
  }

  @override
  Widget build(BuildContext context) {
    final visitaProvider = Provider.of<VisitaProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        title: Text("Previsioni Meteo", style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 5,
        shadowColor: Theme.of(context).colorScheme.shadow,
      ),
      body: _buildBody(visitaProvider),
    );
  }

  Widget _buildBody(VisitaProvider visitaProvider) {
    if (!visitaProvider.areVisiteRetrieved) {
      return MyUiMessagesWidgets.myTextWithLoading(
        context,
        "Sto recuperando le previsioni meteo, un po' di pazienza",
      );
    } else if (!visitaProvider.areOursServersAvailable) {
      return MyUiMessagesWidgets.myErrorWithButton(
        context,
        "Server non raggiungibili. Controlla la tua connessione a internet e riprova",
        "Riprova",
        () {
          visitaProvider.recuperaPrevisioniMeteo(widget.annuncioSelezionato.latitudine, widget.annuncioSelezionato.longitudine);
          visitaProvider.getVisiteAnnuncio(widget.annuncioSelezionato);
        },
      );
    } else if (!visitaProvider.arePrevisioniMeteoRetrieved) {
      return MyUiMessagesWidgets.myTextWithLoading(
        context,
        "Sto recuperando le previsioni meteo, un po' di pazienza",
      );
    } else if (!visitaProvider.areOpenMeteoServersAvailable) {
      return MyUiMessagesWidgets.myErrorWithButton(
        context,
        "Open Meteo non risponde. Controlla la tua connessione a internet e riprova",
        "Riprova",
        () {
          visitaProvider.recuperaPrevisioniMeteo(widget.annuncioSelezionato.latitudine, widget.annuncioSelezionato.longitudine);
          visitaProvider.getVisiteAnnuncio(widget.annuncioSelezionato);
        },
      );
    } else {
      return WeatherListWidget(
        annuncioSelezionato: widget.annuncioSelezionato,
        listaVisite: visitaProvider.listaVisite,
        previsioniMeteo: visitaProvider.previsioniMeteo!,
      );
    }
  }
}