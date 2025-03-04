import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:domus_app/back_end_communication/class_services/visita_service.dart';
import 'package:domus_app/back_end_communication/communication_utils/status_code_controller.dart';
import 'package:domus_app/back_end_communication/dto/annuncio_dto.dart';
import 'package:domus_app/back_end_communication/dto/visita_dto.dart';
import 'package:domus_app/costants/enumerations.dart';
import 'package:domus_app/services/formatStrings.dart';
import 'package:domus_app/ui_elements/theme/ui_constants.dart';
import 'package:domus_app/ui_elements/utils/my_buttons_widgets.dart';
import 'package:domus_app/ui_elements/utils/my_loading.dart';
import 'package:domus_app/ui_elements/utils/my_pop_up_widgets.dart';
import 'package:domus_app/ui_elements/utils/my_ui_messages_widgets.dart';
import 'package:flutter/material.dart';

class AgentePrenotazioniPage extends StatefulWidget {

  final AnnuncioDto annuncioSelezionato;

  const AgentePrenotazioniPage({super.key, required this.annuncioSelezionato});

  @override
  State<AgentePrenotazioniPage> createState() => _AgentePrenotazioniPageState();
}

class _AgentePrenotazioniPageState extends State<AgentePrenotazioniPage> {
  final double GRANDEZZA_SCRITTE_GRANDI = 22;
  final double GRANDEZZA_SCRITTE_PICCOLE = 18;
  bool areServersAvailable = false;
  bool areDataRetrieved = false;
  bool hasAnnuncioVisite = false;
  List<VisitaDto> listaVisite = [];
  int _currentSliderIndex = 0;

  void getVisiteInAttesa() async {
    try{
      List<VisitaDto> data = await VisitaService.recuperaVisiteConStatoByAnnuncio(widget.annuncioSelezionato, Enumerations.statoVisite[0]);
      if (mounted) {
        setState(() {
          listaVisite = data;
          hasAnnuncioVisite = listaVisite.isNotEmpty;
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
      print('Errore con il recupero delle visite (il server potrebbe non essere raggiungibile) $error');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Esegui getAnnunci dopo la fase di build
    Future.delayed(Duration.zero, () {
      getVisiteInAttesa();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: context.onSecondary,
        ),
        automaticallyImplyLeading: true,
        title: Text("Prenotazioni ricevute", style: TextStyle(color: context.onSecondary),),
        centerTitle: true,
        backgroundColor: context.primary,
        elevation: 5,
        shadowColor: context.shadow,
      ),
      body: switch ((areDataRetrieved, areServersAvailable, hasAnnuncioVisite)) {
              (false, _, _) => MyUiMessagesWidgets.myTextWithLoading(context, "Sto recuperando le visite prenotate sull'annuncio, un po' di pazienza"),
              (true, false, _) => MyUiMessagesWidgets.myErrorWithButton(context, 
                                    "Server non raggiungibili. Controlla la tua connessione a internet e riprova", 
                                    "Riprova", 
                                    (){
                                      setState(() {
                                        hasAnnuncioVisite = false;
                                        areDataRetrieved = false;
                                        areServersAvailable = false;
                                      });
                                      getVisiteInAttesa();
                                    }
                                  ),
              (true, true, false) => Column(
                children: [
                  MyUiMessagesWidgets.myText(context, "Non hai visite prenotate per questo annuncio")
                ],
              ),
              (true, true, true) => myCarouselSlider(context),
            }
          );
  }

  CarouselSlider myCarouselSlider(BuildContext context) {

    Color coloreScritte = context.outline;

    return CarouselSlider(
      items: listaVisite.asMap().entries.map((entry) {
        int indice = entry.key;
        VisitaDto visitaCorrente = entry.value;
        double scaleFactor = indice == _currentSliderIndex ? 1.0 : 1.0;
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: context.primaryContainer,
            borderRadius: BorderRadius.circular(10),
            shape: BoxShape.rectangle,
          ),
          child: Column(
            children: [
              SizedBox(height: scaleFactor * MediaQuery.of(context).size.height/50,),
              Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  Text("Data prenotazione: ", style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_GRANDI, fontWeight: FontWeight.bold, color: coloreScritte)),
                  Text(FormatStrings.formattaDataGGMMAAAA(visitaCorrente.data), style: TextStyle(fontSize: scaleFactor * 22, fontWeight: FontWeight.bold, color: coloreScritte)),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  Text("Fascia oraria: ", style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.bold, color: coloreScritte)),
                  Text("${FormatStrings.formattaOrario(visitaCorrente.orarioInizio)} - ${FormatStrings.formattaOrario(visitaCorrente.orarioFine!)}", style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: coloreScritte)),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  Text("Nome: ", style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.bold, color: coloreScritte)),
                  Text(FormatStrings.trasformareInizialeMaiuscola(visitaCorrente.cliente.nome), style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: coloreScritte)),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  Text("Cognome: ", style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.bold, color: coloreScritte)),
                  Text(FormatStrings.trasformareInizialeMaiuscola(visitaCorrente.cliente.cognome), style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: coloreScritte)),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  Text("Email: ", style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.bold, color: coloreScritte)),
                  Expanded(
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(visitaCorrente.cliente.email, style: TextStyle(fontSize: GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: context.outline),))),
                  ),
                ],
              ),
              SizedBox(height: scaleFactor * MediaQuery.of(context).size.height/130,),
              Row(
                children: [
                  SizedBox(width: scaleFactor * MediaQuery.of(context).size.height/50,),
                  Expanded(
                    child: MyElevatedButtonRectWidget(
                            text: "Accetta",
                            onPressed: (){
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) => MyOptionsDialog(
                                                                    title: "Conferma prenotazione",
                                                                    bodyText: "Sei sicuro di voler accettare la prenotazione?",
                                                                    leftButtonText: "No",
                                                                    leftButtonColor: context.secondary,
                                                                    rightButtonText: "Si",
                                                                    rightButtonColor: context.tertiary,
                                                                    onPressLeftButton: (){Navigator.pop(context);},
                                                                    onPressRightButton: () async {
                                                                      LoadingHelper.showLoadingDialogNotDissmissible(context, color: context.secondary);
                                                                      try {
                                                                        int statusCode = await VisitaService.aggiornaStatoVisita(visitaCorrente, Enumerations.statoOfferte[1]);
                                                                        Navigator.pop(context);
                                                                        Navigator.pop(context);
                                                                        StatusCodeController.controllaStatusCodeAndShowPopUp(context, statusCode, 200, "Conferma", "Visita accettata", "Errore", "Visita non accettata");
                                                                        setState(() {
                                                                          hasAnnuncioVisite = false;
                                                                          areDataRetrieved = false;
                                                                          areServersAvailable = false;
                                                                        });
                                                                        getVisiteInAttesa();
                                                                      }on TimeoutException {
                                                                        Navigator.pop(context);
                                                                        Navigator.pop(context);
                                                                        showDialog(
                                                                          context: context, 
                                                                          builder: (BuildContext context) => MyInfoDialog(
                                                                            title: "Connessione non riuscita", 
                                                                            bodyText: "Offerta non rifiutata, la connessione con i nostri server non è stata stabilita correttamente. Riprova più tardi.", 
                                                                            buttonText: "Ok", 
                                                                            onPressed: () {Navigator.pop(context);}
                                                                          )
                                                                        );
                                                                      } catch (e) {
                                                                        print(e);
                                                                        Navigator.pop(context);
                                                                        Navigator.pop(context);
                                                                        showDialog(
                                                                          context: context, 
                                                                          builder: (BuildContext context) => MyInfoDialog(
                                                                            title: "Errore",
                                                                            bodyText: "Offerta non rifiutata.", 
                                                                            buttonText: "Ok", 
                                                                            onPressed: () {Navigator.pop(context);}
                                                                          )
                                                                        );
                                                                      }
                                                                    },
                                                                  )
                                );
                            },
                            color: context.onSecondary
                          )
                  ),
                  SizedBox(width: scaleFactor * MediaQuery.of(context).size.height/50,),
                  Expanded(
                    child: MyElevatedButtonRectWidget(
                            text: "Rifiuta",
                            onPressed: (){
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) => MyOptionsDialog(
                                                                    title: "Rifiuta prenotazione",
                                                                    bodyText: "Sei sicuro di voler rifiutare la prenotazione?",
                                                                    leftButtonText: "No",
                                                                    leftButtonColor: context.secondary,
                                                                    rightButtonText: "Si",
                                                                    rightButtonColor: context.tertiary,
                                                                    onPressLeftButton: (){Navigator.pop(context);},
                                                                    onPressRightButton: () async {
                                                                      LoadingHelper.showLoadingDialogNotDissmissible(context, color: context.secondary);
                                                                      try {
                                                                        int statusCode = await VisitaService.aggiornaStatoVisita(visitaCorrente, Enumerations.statoOfferte[2]);
                                                                        Navigator.pop(context);
                                                                        Navigator.pop(context);
                                                                        StatusCodeController.controllaStatusCodeAndShowPopUp(context, statusCode, 200, "Conferma", "Visita rifiutata", "Errore", "Visita non rifiutata");
                                                                        setState(() {
                                                                          hasAnnuncioVisite = false;
                                                                          areDataRetrieved = false;
                                                                          areServersAvailable = false;
                                                                        });
                                                                        getVisiteInAttesa();
                                                                      }on TimeoutException {
                                                                        Navigator.pop(context);
                                                                        Navigator.pop(context);
                                                                        showDialog(
                                                                          context: context, 
                                                                          builder: (BuildContext context) => MyInfoDialog(
                                                                            title: "Connessione non riuscita", 
                                                                            bodyText: "Offerta non rifiutata, la connessione con i nostri server non è stata stabilita correttamente. Riprova più tardi.", 
                                                                            buttonText: "Ok", 
                                                                            onPressed: () {Navigator.pop(context);}
                                                                          )
                                                                        );
                                                                      } catch (e) {
                                                                        print(e);
                                                                        Navigator.pop(context);
                                                                        Navigator.pop(context);
                                                                        showDialog(
                                                                          context: context, 
                                                                          builder: (BuildContext context) => MyInfoDialog(
                                                                            title: "Errore",
                                                                            bodyText: "Offerta non rifiutata.", 
                                                                            buttonText: "Ok", 
                                                                            onPressed: () {Navigator.pop(context);}
                                                                          )
                                                                        );
                                                                      }
                                                                    },
                                                                  )
                                );
                            },
                            color: context.secondary)),
                  SizedBox(width: scaleFactor * MediaQuery.of(context).size.height/50,),
              ],),
              SizedBox(height: scaleFactor * MediaQuery.of(context).size.height/75,),
            ],
          ),
        );
      }).toList(),
      options: CarouselOptions(
        initialPage: 1,
        enableInfiniteScroll: false,
        viewportFraction: 0.32,
        height: 850,
        enlargeCenterPage: false,
        scrollDirection: Axis.vertical,
        onPageChanged: (indicePrenotazioneCorrente, reason) {
          setState(() {
            _currentSliderIndex = indicePrenotazioneCorrente;
          });
        }
      )
    );
  }
}