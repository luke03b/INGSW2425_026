import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:domus_app/back_end_communication/class_services/immagini_service.dart';
import 'package:domus_app/back_end_communication/class_services/visita_service.dart';
import 'package:domus_app/back_end_communication/dto/annuncio/annuncio_dto.dart';
import 'package:domus_app/back_end_communication/dto/immagini_dto.dart';
import 'package:domus_app/back_end_communication/dto/visita_dto.dart';
import 'package:domus_app/pages/cliente_pages/cliente_annuncio_page.dart';
import 'package:domus_app/ui_elements/utils/formatStrings.dart';
import 'package:domus_app/ui_elements/theme/ui_constants.dart';
import 'package:domus_app/ui_elements/utils/my_ui_messages_widgets.dart';
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

      for(VisitaDto visita in data){
        List<ImmaginiDto> immaginiPerAnnuncio = await ImmaginiService.recuperaTutteImmaginiByAnnuncio(visita.annuncio);
        ImmaginiDto.ordinaImmaginiPerNumero(immaginiPerAnnuncio);
        visita.annuncio.listaImmagini = immaginiPerAnnuncio;
      }

      for(VisitaDto visita in data){
        if(visita.annuncio.listaImmagini != null && visita.annuncio.listaImmagini!.isNotEmpty){
          for(ImmaginiDto immagine in visita.annuncio.listaImmagini!){
            immagine.urlS3 = await ImmaginiService.recuperaFileImmagine(immagine.url); 
          }
        }
      }

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
      if(statoPrenotazione == "Confermata") {
        return Colors.green;
      } else if(statoPrenotazione == "Rifiutata") {
        return context.error;
      } else {
        return Colors.grey;
      }
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
          child: Stack(
            children: [
              Container(
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
                        width: double.infinity,
                        height: 200,
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                // color: Colors.black,
                                image: DecorationImage(image: AssetImage('lib/assets/blank_house.png'),
                                fit: BoxFit.cover)
                              ),
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: (visitaCorrente.annuncio.listaImmagini != null && visitaCorrente.annuncio.listaImmagini!.isNotEmpty && visitaCorrente.annuncio.listaImmagini!.length>=1  &&
                                        visitaCorrente.annuncio.listaImmagini!.first.urlS3 != null && visitaCorrente.annuncio.listaImmagini!.first.urlS3!.isNotEmpty) ?
                                        Image.network(visitaCorrente.annuncio.listaImmagini!.first.urlS3!, 
                                          errorBuilder: (context, error, stackTrace) {
                                          return Image.asset('lib/assets/blank_house.png');}, 
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,) : 
                                        SizedBox.shrink()))
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: SizedBox(
                          height: 110,
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(image: AssetImage('lib/assets/blank_house.png'),
                                  fit: BoxFit.cover)
                                ),
                              ),
                              Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: (visitaCorrente.annuncio.listaImmagini != null && visitaCorrente.annuncio.listaImmagini!.isNotEmpty && visitaCorrente.annuncio.listaImmagini!.length>=2  &&
                                        visitaCorrente.annuncio.listaImmagini!.elementAt(1).urlS3 != null && visitaCorrente.annuncio.listaImmagini!.elementAt(1).urlS3!.isNotEmpty) ?
                                        Image.network(visitaCorrente.annuncio.listaImmagini!.elementAt(1).urlS3!, 
                                          errorBuilder: (context, error, stackTrace) {
                                          return Image.asset('lib/assets/blank_house.png');}, 
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,) : 
                                        SizedBox.shrink()))
                            ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                          height: 110,
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(image: AssetImage('lib/assets/blank_house.png'),
                                  fit: BoxFit.cover)
                                ),
                              ),
                              Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: (visitaCorrente.annuncio.listaImmagini != null && visitaCorrente.annuncio.listaImmagini!.isNotEmpty && visitaCorrente.annuncio.listaImmagini!.length>=3  &&
                                        visitaCorrente.annuncio.listaImmagini!.elementAt(2).urlS3 != null && visitaCorrente.annuncio.listaImmagini!.elementAt(2).urlS3!.isNotEmpty) ?
                                        Image.network(visitaCorrente.annuncio.listaImmagini!.elementAt(2).urlS3!, 
                                          errorBuilder: (context, error, stackTrace) {
                                          return Image.asset('lib/assets/blank_house.png');}, 
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,) : 
                                        SizedBox.shrink()))
                            ],
                          ),
                          ),
                        ),
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
                        Text(FormatStrings.mappaStatoVisita(visitaCorrente.stato!), style: TextStyle(fontSize: scaleFactor * 22, fontWeight: FontWeight.bold, color: selettoreColoreStatoPrenotazione(FormatStrings.mappaStatoVisita(visitaCorrente.stato!)))),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        Text(FormatStrings.formatNumber(visitaCorrente.annuncio.prezzo), style: TextStyle(fontSize: scaleFactor * 20, fontWeight: FontWeight.bold, color: context.outline)),
                        Text(" EUR", style: TextStyle(fontSize: scaleFactor * 20, fontWeight: FontWeight.bold, color: context.outline)),
                        Visibility(
                          visible: visitaCorrente.annuncio.tipoAnnuncio == "AFFITTO", 
                          child: Row(
                            children: [
                              SizedBox(width: 3,),
                              Text("/Mese", style: TextStyle(color: context.outline, fontWeight: FontWeight.bold, fontSize: scaleFactor * 20),),
                            ],
                          )
                        )
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
              if (visitaCorrente.annuncio.stato == "CONCLUSO")
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: context.error,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    visitaCorrente.annuncio.tipoAnnuncio == "VENDITA" ? "Venduto" : "Affittato",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: context.onError,
                    ),
                  ),
                ),
              ),
            ],
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