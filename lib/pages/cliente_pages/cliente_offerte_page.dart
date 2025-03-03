import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:domus_app/back_end_communication/class_services/offerta_service.dart';
import 'package:domus_app/back_end_communication/dto/offerta_dto.dart';
import 'package:domus_app/pages/cliente_pages/cliente_annuncio_page.dart';
import 'package:domus_app/services/formatStrings.dart';
import 'package:domus_app/ui_elements/theme/ui_constants.dart';
import 'package:domus_app/ui_elements/utils/my_ui_messages_widgets.dart';
import 'package:flutter/material.dart';

class OffertePage extends StatefulWidget {
  const OffertePage({super.key});

  @override
  State<OffertePage> createState() => _OffertePageState();
}

class _OffertePageState extends State<OffertePage> {

  int _currentSliderIndex = 0;
  List<OffertaDto> annunciList = [];
  bool hasUserOfferte = false;
  bool areServersAvailable = false;
  bool areDataRetrieved = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Esegui getAnnunci dopo la fase di build
    Future.delayed(Duration.zero, () {
      getAnnunciConOfferte();
    });
  }

  Future<void> getAnnunciConOfferte() async {
    try {

      List<OffertaDto> data = await OffertaService.recuperaAnnunciConOfferteByClienteLoggato();

      if (mounted) {
        setState(() {
          annunciList = data;
          hasUserOfferte = annunciList.isNotEmpty;
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
      body: switch ((areDataRetrieved, areServersAvailable, hasUserOfferte)) {
                (false, _, _) => MyUiMessagesWidgets.myTextWithLoading(context, "Sto recuperando le tue offerte"),
                (true, false, _) => MyUiMessagesWidgets.myErrorWithButton(
                  context, 
                  "Server non raggiungibili. Controlla la tua connessione a internet e riprova", 
                  "Riprova", 
                  (){
                    setState(() {
                      areServersAvailable = false;
                      areDataRetrieved = false;
                      hasUserOfferte = false;
                    });
                    getAnnunciConOfferte();
                  }
                ),
                (true, true, false) => MyUiMessagesWidgets.myText(context, "Non hai fatto offerte"),
                (true, true, true) => myCarouselSlider(context),
            }
    );
  }

  CarouselSlider myCarouselSlider(BuildContext context) {

    Color selettoreColoreStatoOfferta(String statoOfferta) {
      if(statoOfferta == "Accettata") {
        return Colors.green;
      } else if(statoOfferta == "Rifiutata") {
        return context.error;
      } else if(statoOfferta == "In Attesa") {
        return Colors.grey;
      } else if(statoOfferta == "Controproposta") {
        return context.tertiary;
      }
      return context.outline;
    }

    return CarouselSlider(
      items: annunciList.asMap().entries.map((entry) {
        int indice = entry.key;
        OffertaDto offertaSelezionata = entry.value;
        double scaleFactor = indice == _currentSliderIndex ? 1.0 : 0.7;
        return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ClienteAnnuncioPage(annuncioSelezionato: offertaSelezionata.annuncio!,)));
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: context.primaryContainer,
              borderRadius: BorderRadius.circular(10),
              shape: BoxShape.rectangle,
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
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Text("La tua offerta: ", style: TextStyle(fontSize: scaleFactor * 22, fontWeight: FontWeight.bold, color: context.outline)),
                    Text(FormatStrings.formatNumber(offertaSelezionata.prezzo), style: TextStyle(fontSize: scaleFactor * 22, fontWeight: FontWeight.normal, color: context.outline)),
                    Text(" EUR", style: TextStyle(fontSize: scaleFactor * 22, fontWeight: FontWeight.normal, color: context.outline)),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Text(FormatStrings.mappaStatoOfferta(offertaSelezionata.stato!), style: TextStyle(fontSize: scaleFactor * 22, fontWeight: FontWeight.bold, color: selettoreColoreStatoOfferta(FormatStrings.mappaStatoOfferta(offertaSelezionata.stato!)))),
                    Visibility(
                      visible: FormatStrings.mappaStatoOfferta(offertaSelezionata.stato!) == "Controproposta",
                      child: Row(
                        children: [
                          Text(": ", style: TextStyle(fontSize: scaleFactor * 22, fontWeight: FontWeight.bold, color: selettoreColoreStatoOfferta(FormatStrings.mappaStatoOfferta(offertaSelezionata.stato!)))),
                          Text(FormatStrings.formatNumber(offertaSelezionata.controproposta ?? 0), style: TextStyle(fontSize: scaleFactor * 22, fontWeight: FontWeight.normal, color: selettoreColoreStatoOfferta(FormatStrings.mappaStatoOfferta(offertaSelezionata.stato!)))),
                          Text(" EUR", style: TextStyle(fontSize: scaleFactor * 22, fontWeight: FontWeight.normal, color: selettoreColoreStatoOfferta(FormatStrings.mappaStatoOfferta(offertaSelezionata.stato!)))),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Text("Data offerta: ", style: TextStyle(fontSize: scaleFactor * 17, fontWeight: FontWeight.bold, color: context.outline)),
                    Text(FormatStrings.formattaDataGGMMAAAAeHHMM(offertaSelezionata.data!), style: TextStyle(fontSize: scaleFactor * 17, fontWeight: FontWeight.normal, color: context.outline)),
                  ],
                ),
                SizedBox(
                  height: scaleFactor * MediaQuery.of(context).size.height/75,
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Text(FormatStrings.formatNumber(offertaSelezionata.annuncio!.prezzo), style: TextStyle(fontSize: scaleFactor * 20, fontWeight: FontWeight.bold, color: context.outline)),
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
                        offertaSelezionata.annuncio!.indirizzo,
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