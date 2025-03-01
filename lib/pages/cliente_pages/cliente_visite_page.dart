import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:domus_app/back_end_communication/class_services/visita_service.dart';
import 'package:domus_app/back_end_communication/dto/visita_dto.dart';
import 'package:domus_app/pages/cliente_pages/cliente_annuncio_page.dart';
import 'package:domus_app/services/formatStrings.dart';
import 'package:domus_app/theme/ui_constants.dart';
import 'package:domus_app/utils/my_ui_messages_widgets.dart';
import 'package:flutter/material.dart';

class ClientePrenotazioniPage extends StatefulWidget {
  const ClientePrenotazioniPage({super.key});

  @override
  State<ClientePrenotazioniPage> createState() => _ClientePrenotazioniPageState();
}

class _ClientePrenotazioniPageState extends State<ClientePrenotazioniPage> {
  int _currentSliderIndex = 0;
  bool hasUserVisite = false;
  bool areServersAvailable = false;
  bool areDataRetrieved = false;

  List<VisitaDto> annunciList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Esegui getAnnunci dopo la fase di build
    Future.delayed(Duration.zero, () {
      getAnnunciConVisite();
    });
  }

  Future<void> getAnnunciConVisite() async {
    try {

      List<VisitaDto> data = await VisitaService.recuperaAnnunciConVisiteByClienteLoggato();

      if (mounted) {
        setState(() {
          annunciList = data;
          hasUserVisite = annunciList.isNotEmpty;
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
      print('Errore con il recupero degli annunci (il server potrebbe non essere raggiungibile) $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("House Hunters", style: TextStyle(color: context.onSecondary),),
        centerTitle: true,
        backgroundColor: context.primary,
        elevation: 5,
        shadowColor: context.shadow,
      ),
      body: switch ((areDataRetrieved, areServersAvailable, hasUserVisite)) {
                (false, _, _) => MyUiMessagesWidgets.myTextWithLoading(context, "Sto recuperando le tue visite prenotate"),
                (true, false, _) => MyUiMessagesWidgets.myErrorWithButton(
                  context, 
                  "Server non raggiungibili. Controlla la tua connessione a internet e riprova", 
                  "Riprova", 
                  (){
                    setState(() {
                      areServersAvailable = false;
                      areDataRetrieved = false;
                      hasUserVisite = false;
                    });
                    getAnnunciConVisite();
                  }
                ),
                (true, true, false) => MyUiMessagesWidgets.myText(context, "Non hai prenotato visite"),
                (true, true, true) => myCarouselSlider(context),
            });
  }

  CarouselSlider myCarouselSlider(BuildContext context) {

    Color selettoreColoreStatoPrenotazione(String statoPrenotazione) {
      if(statoPrenotazione == "Accettata") {
        return Colors.green;
      } else if(statoPrenotazione == "Rifiutata") {
        return context.error;
      } else if(statoPrenotazione == "In Attesa") {
        return Colors.grey;
      } else if(statoPrenotazione == "Controproposta") {
        return context.tertiary;
      }
      return context.outline;
    }

    return CarouselSlider(
      items: annunciList.asMap().entries.map((entry) {
        int indice = entry.key;
        VisitaDto visitaCorrente = entry.value;
        double scaleFactor = indice == _currentSliderIndex ? 1.0 : 0.7;
        return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ClienteAnnuncioPage(annuncioSelezionato: visitaCorrente.annuncio)));
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: context.primaryContainer,
              borderRadius: BorderRadius.circular(10),
              shape: BoxShape.rectangle,
              boxShadow: [BoxShadow(color: context.shadow.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 15,
                offset: Offset(0, 10),)],
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                  child: SizedBox(
                    child: Image.asset('lib/assets/casa3_1_placeholder.png'))),
                Row(
                  children: [
                    Expanded(child: Image.asset('lib/assets/casa3_1_placeholder.png')),
                    Expanded(child: Image.asset('lib/assets/casa3_1_placeholder.png')),
                  ],
                ),
                SizedBox(
                  height: scaleFactor * MediaQuery.of(context).size.height/50,
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width / 45),
                    SizedBox(width: MediaQuery.of(context).size.width / 45),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Data prenotazione: ",
                          style: TextStyle(
                            fontSize: scaleFactor * 22,
                            fontWeight: FontWeight.bold,
                            color: context.outline,
                          ),
                        ),
                        AutoSizeText(
                          "${FormatStrings.formattaDataGGMMAAAA(visitaCorrente.data)} dalle ${FormatStrings.formattaOrario(visitaCorrente.orarioInizio)} alle ${FormatStrings.formattaOrario(visitaCorrente.orarioFine!)}",
                          style: TextStyle(
                            fontSize: scaleFactor * 18,
                            fontWeight: FontWeight.normal,
                            color: context.outline,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          minFontSize: 12,
                          maxFontSize: 20,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Text(FormatStrings.mappaStatoOfferta(visitaCorrente.stato!), style: TextStyle(fontSize: scaleFactor * 22, fontWeight: FontWeight.bold, color: selettoreColoreStatoPrenotazione(FormatStrings.mappaStatoOfferta(visitaCorrente.stato!)))),
                  ],
                ),
                // Row(
                //   children: [
                //     SizedBox(width: MediaQuery.of(context).size.width/45,),
                //     SizedBox(width: MediaQuery.of(context).size.width/45,),
                //     Text("Richiesta effettuata in data: ", style: TextStyle(fontSize: scaleFactor * 17, fontWeight: FontWeight.bold, color: context.outline)),
                //     Text(visitaCorrente['data_prenotazione'], style: TextStyle(fontSize: scaleFactor * 17, fontWeight: FontWeight.normal, color: context.outline)),
                //   ],
                // ),
                SizedBox(
                  height: scaleFactor * MediaQuery.of(context).size.height/75,
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Text(FormatStrings.formatNumber(visitaCorrente.annuncio.prezzo), style: TextStyle(fontSize: scaleFactor * 20, fontWeight: FontWeight.bold, color: context.outline)),
                    Text(" EUR", style: TextStyle(fontSize: scaleFactor * 20, fontWeight: FontWeight.bold, color: context.outline)),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Icon(Icons.location_on, size: scaleFactor * 22, color: context.outline,),
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Expanded(
                      child: AutoSizeText(
                        visitaCorrente.annuncio.indirizzo,
                        style: TextStyle(
                          fontSize: scaleFactor * 18,
                          fontWeight: FontWeight.normal,
                          color: context.outline,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        minFontSize: 12,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
      options: CarouselOptions(
        enableInfiniteScroll: false,
        viewportFraction: 0.68,
        height: 753,
        enlargeCenterPage: true,
        scrollDirection: Axis.vertical,
        onPageChanged: (indiceCasaCorrente, reason) {
          setState(() {
            _currentSliderIndex = indiceCasaCorrente;
          });
        }
      ));
  }
}