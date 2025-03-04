import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:domus_app/back_end_communication/class_services/offerta_service.dart';
import 'package:domus_app/back_end_communication/dto/annuncio_dto.dart';
import 'package:domus_app/back_end_communication/dto/offerta_dto.dart';
import 'package:domus_app/costants/enumerations.dart';
import 'package:domus_app/pages/agente_pages/agente_analisi_offerta_page.dart';
import 'package:domus_app/pages/shared_pages/crea_offerta_page.dart';
import 'package:domus_app/services/formatStrings.dart';
import 'package:domus_app/ui_elements/theme/ui_constants.dart';
import 'package:domus_app/ui_elements/utils/my_buttons_widgets.dart';
import 'package:domus_app/ui_elements/utils/my_loading.dart';
import 'package:domus_app/ui_elements/utils/my_pop_up_widgets.dart';
import 'package:flutter/material.dart';

import '../../ui_elements/utils/my_ui_messages_widgets.dart';

class AgenteOffertePage extends StatefulWidget {

  final AnnuncioDto annuncioSelezionato;

  const AgenteOffertePage({super.key, required this.annuncioSelezionato});

  @override
  State<AgenteOffertePage> createState() => _AgenteOffertePageState();
}

class _AgenteOffertePageState extends State<AgenteOffertePage> {
  final double GRANDEZZA_SCRITTE_GRANDI = 22;
  final double GRANDEZZA_SCRITTE_PICCOLE = 18;
  int _currentSliderIndex = 0;
  bool areServersAvailable = false;
  bool areDataRetrieved = false;
  bool hasAnnuncioOfferte = false;
  List<OffertaDto> listaOfferte = [];

  void getOfferteInAttesa() async {
    try{
      List<OffertaDto> data = await OffertaService.recuperaOfferteConStatoByAnnuncio(widget.annuncioSelezionato, Enumerations.statoOfferte[0]);
      if (mounted) {
        setState(() {
          listaOfferte = data;
          hasAnnuncioOfferte = listaOfferte.isNotEmpty;
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
    
    // Esegui getAnnunci dopo la fase di build
    Future.delayed(Duration.zero, () {
      getOfferteInAttesa();
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
        title: Text("Offerte ricevute", style: TextStyle(color: context.onSecondary),),
        centerTitle: true,
        backgroundColor: context.primary,
        elevation: 5,
        shadowColor: context.shadow,
      ),
      body: switch ((areDataRetrieved, areServersAvailable, hasAnnuncioOfferte)) {
                (false, _, _) => MyUiMessagesWidgets.myTextWithLoading(context, "Sto recuperando le offerte sull'annuncio, un po' di pazienza"),
                (true, false, _) => MyUiMessagesWidgets.myErrorWithButton(context, 
                                      "Server non raggiungibili. Controlla la tua connessione a internet e riprova", 
                                      "Riprova", 
                                      (){
                                        setState(() {
                                          hasAnnuncioOfferte = false;
                                          areDataRetrieved = false;
                                          areServersAvailable = false;
                                        });
                                        getOfferteInAttesa();
                                      }
                                    ),
                (true, true, false) => MyUiMessagesWidgets.myTextWithButton(
                  context, 
                  "Non hai offerte per questo annuncio", 
                  "Aggiungi offerta", 
                  () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (context) => CreaOffertaPage(annuncioSelezionato: widget.annuncioSelezionato, isOffertaManuale: true,)));
                    setState(() {
                      hasAnnuncioOfferte = false;
                      areDataRetrieved = false;
                      areServersAvailable = false;
                    });
                    getOfferteInAttesa();
                  }
                ),
                (true, true, true) => myOffertePage(context),
              }
    );
  }

  Stack myOffertePage(BuildContext context) {
    return Stack(
      children:[ 
        myCarouselSlider(context),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 63),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
              color: context.primaryContainer,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 10,height: 40,),
                  Text("Prezzo iniziale: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: GRANDEZZA_SCRITTE_PICCOLE, color: context.outline),),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(FormatStrings.formatNumber(widget.annuncioSelezionato.prezzo), style: TextStyle(fontSize: GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: context.outline),))),
                  ),
                  Text("EUR", style: TextStyle(fontWeight: FontWeight.normal, fontSize: GRANDEZZA_SCRITTE_PICCOLE, color: context.outline),),
                  SizedBox(width: 10,),
                ],
              ),
            ),
          )
        ),
        Positioned(
          bottom: 30,
          left: 250,
          right: -60,
          child: Column(
            children: [
              SizedBox(height: 10,),
              Row(children: [
              SizedBox(width: 5,),
              Expanded(child: MyAddButtonWidget(onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => CreaOffertaPage(annuncioSelezionato: widget.annuncioSelezionato, isOffertaManuale: true,)));
                setState(() {
                  hasAnnuncioOfferte = false;
                  areDataRetrieved = false;
                  areServersAvailable = false;
                });
                getOfferteInAttesa();
              },
              color: context.onSecondary)),
              SizedBox(width: 5,),
              ],),
              SizedBox(height: 10,)
            ],
          )
        ),
      ]
    );
  }

 CarouselSlider myCarouselSlider(BuildContext context) {

    Color coloreScritte = context.outline;

    return CarouselSlider(
      items: listaOfferte.asMap().entries.map((entry) {
        int indice = entry.key;
        OffertaDto offertaCorrente = entry.value;
        double scaleFactor = indice == _currentSliderIndex ? 1.0 : 1.0;
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: context.primaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              SizedBox(height: scaleFactor * MediaQuery.of(context).size.height/50,),
              Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  Text("Data offerta: ", style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_GRANDI, fontWeight: FontWeight.bold, color: coloreScritte)),
                  Text(FormatStrings.formattaDataGGMMAAAAeHHMM(offertaCorrente.data!), style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_GRANDI, fontWeight: FontWeight.bold, color: coloreScritte)),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  Text(FormatStrings.formatNumber(offertaCorrente.prezzo), style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.bold, color: coloreScritte)),
                  Text(" EUR", style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.bold, color: coloreScritte)),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  Text("Nome: ", style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.bold, color: coloreScritte)),
                  offertaCorrente.cliente != null ? 
                    Text(offertaCorrente.cliente!.nome, style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: coloreScritte)) 
                    : 
                    Text(offertaCorrente.nomeOfferente!, style: TextStyle(fontSize: GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: context.outline))
                ],
              ),
              Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  Text("Cognome: ", style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.bold, color: coloreScritte)),
                  offertaCorrente.cliente != null ? 
                  Text(offertaCorrente.cliente!.cognome, style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: coloreScritte)) 
                  : 
                  Text(offertaCorrente.cognomeOfferente!, style: TextStyle(fontSize: GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: context.outline))
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
                        child: offertaCorrente.cliente != null ? 
                          Text(offertaCorrente.cliente!.email, style: TextStyle(fontSize: GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: context.outline)) 
                          : 
                          Text(offertaCorrente.emailOfferente!, style: TextStyle(fontSize: GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: context.outline))
                      )
                    ),
                  ),
                ],
              ),
              SizedBox(height: scaleFactor * MediaQuery.of(context).size.height/130,),
              Row(
                children: [
                  SizedBox(width: scaleFactor * MediaQuery.of(context).size.height/50,),
                  Expanded(
                    child: MyElevatedButtonRectWidget(
                            text: "Analizza",
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AgenteAnalizzaOffertaPage(offertaSelezionata: offertaCorrente)));
                            },
                            color: context.onSecondary,
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
                                                                    title: "Rifiuta offerta",
                                                                    bodyText: "Sei sicuro di voler rifiutare l'offerta?",
                                                                    leftButtonText: "No",
                                                                    leftButtonColor: context.secondary,
                                                                    rightButtonText: "Si",
                                                                    rightButtonColor: context.tertiary,
                                                                    onPressLeftButton: (){Navigator.pop(context);},
                                                                    onPressRightButton: () async {
                                                                      LoadingHelper.showLoadingDialogNotDissmissible(context, color: context.secondary);
                                                                      try {
                                                                        int statusCode = await OffertaService.aggiornaStatoOfferta(offertaCorrente, Enumerations.statoOfferte[2]);
                                                                        Navigator.pop(context);
                                                                        Navigator.pop(context);
                                                                        controllaStatusCode(statusCode, context);
                                                                        setState(() {
                                                                          hasAnnuncioOfferte = false;
                                                                          areDataRetrieved = false;
                                                                          areServersAvailable = false;
                                                                        });
                                                                        getOfferteInAttesa();
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
                            color: context.secondary
                          )
                    ),
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
        viewportFraction: 0.29,
        height: 850,
        enlargeCenterPage: false,
        scrollDirection: Axis.vertical,
        onPageChanged: (indiceOffertaCorrente, reason) {
          setState(() {
            _currentSliderIndex = indiceOffertaCorrente;
          });
        }
      )
    );
  }

   void controllaStatusCode(int statusCode, BuildContext context) {
    if (statusCode == 200) {
      showDialog(
        context: context, 
        builder: (BuildContext context) => MyInfoDialog(
          title: "Conferma", 
          bodyText: "Offerta rifiutata", 
          buttonText: "Ok", 
          onPressed: () {Navigator.pop(context);}
        )
      );
    } else {
      showDialog(
        context: context, 
        builder: (BuildContext context) => MyInfoDialog(
          title: "Errore", 
          bodyText: "Offerta non rifiutata, controllare i campi e riprovare.",
          buttonText: "Ok", 
          onPressed: () {Navigator.pop(context);}
        )
      );
    }
  }

}