import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:domus_app/back_end_communication/class_services/annuncio_service.dart';
import 'package:domus_app/back_end_communication/dto/annuncio_dto.dart';
import 'package:domus_app/pages/agente_pages/agente_annuncio_page.dart';
import 'package:domus_app/pages/agente_pages/agente_crea_annuncio_page.dart';
import 'package:domus_app/services/formatStrings.dart';
import 'package:domus_app/ui_elements/theme/ui_constants.dart';
import 'package:domus_app/ui_elements/utils/my_buttons_widgets.dart';
import 'package:domus_app/ui_elements/utils/my_ui_messages_widgets.dart';
import 'package:flutter/material.dart';

class AgenteHomePage extends StatefulWidget {
  const AgenteHomePage({super.key});

  @override
  State<AgenteHomePage> createState() => _AgenteHomePageState();
}

class _AgenteHomePageState extends State<AgenteHomePage> {
  List<AnnuncioDto> annunciList = [];
  static const double GRANDEZZA_SCRITTE = 23;
  static const double GRANDEZZA_ICONE = 25;
  static const double GRANDEZZA_SCRITTE_PICCOLE = 18;
  static const double GRANDEZZA_ICONE_PICCOLE = 20;
  int _currentSliderIndex = 0;
  List<bool> selectedOffertePrenotazioni = <bool>[false, false];
  bool selectedDisponibili = false;
  bool hasUserAnnunci = false;
  bool areDataRetrieved = false;
  bool areServersAvailable = false;

  Future<void> getAnnunciAgente() async {
    try {
      List<AnnuncioDto> data = await AnnuncioService.recuperaAnnunciByAgenteLoggato();
      
      if (mounted) {
        setState(() {
          annunciList = data;
          hasUserAnnunci = annunciList.isNotEmpty;
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

  Future<void> getAnnunciConOffertePrenotazioniEDisponibilitaAgente() async {
    try {

      List<AnnuncioDto> data = await AnnuncioService.recuperaAnnunciByAgenteLoggatoConOffertePrenotazioniInAttesa(selectedOffertePrenotazioni[0], selectedOffertePrenotazioni[1], selectedDisponibili);

      if (mounted) {
        setState(() {
          annunciList = data;
          hasUserAnnunci = annunciList.isNotEmpty;
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
  void initState(){
    super.initState();
    getAnnunciAgente();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: context.onSecondary,
        ),
        title: Text("Le mie inserzioni", style: TextStyle(color: context.onSecondary),),
        centerTitle: true,
        backgroundColor: context.primary,
        elevation: 5,
        shadowColor: context.shadow,
      ),
      body: Stack(
        children: [
          switch ((areDataRetrieved, areServersAvailable, hasUserAnnunci, selectedOffertePrenotazioni[0], selectedOffertePrenotazioni[1], selectedDisponibili)) {
            (false, _, _, _, _, _) => MyUiMessagesWidgets.myTextWithLoading(
              context, 
              "Sto recuperando i tuoi annunci, un po' di pazienza"
            ),

            (true, false, _, _, _, _) => MyUiMessagesWidgets.myErrorWithButton(
              context, 
              "Server non raggiungibili. Controlla la tua connessione a internet e riprova", 
              "Riprova", 
              () {
                setState(() {
                  hasUserAnnunci = false;
                  areDataRetrieved = false;
                  areServersAvailable = false;
                });
                getAnnunciAgente();
              }
            ),

            // Caso: selectedOffertePrenotazioni[0] è true e non ci sono annunci
            (true, true, false, true, false, false) => MyUiMessagesWidgets.myText(
              context,
              "Non ci sono annunci con offerte.",
            ),

            // Caso: selectedOffertePrenotazioni[1] è true e non ci sono annunci
            (true, true, false, false, true, false) => MyUiMessagesWidgets.myText(
              context,
              "Non ci sono annunci con prenotazioni.",
            ),

            // Caso: entrambi selectedOffertePrenotazioni[0] e [1] sono true e non ci sono annunci
            (true, true, false, true, true, false) => MyUiMessagesWidgets.myText(
              context,
              "Non ci sono annunci con offerte e prenotazioni."
            ),

            // Caso: nessun filtro attivo e non ci sono annunci
            (true, true, false, false, false, false) => MyUiMessagesWidgets.myTextWithButton(
              context,
              "Benvenuto! Non hai ancora annunci. Aggiungine subito uno",
              "Aggiungi annuncio",
              () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AgenteCreaAnnuncioPage()));
              }
            ),

            (true, true, false, true, true, true) => MyUiMessagesWidgets.myText(context, "Non ci sono annunci non venduti o non affittati con offerte e prenotazioni"),

            (true, true, false, false, true, true) => MyUiMessagesWidgets.myText(context, "Non ci sono annunci non venduti o non affittati con prenotazioni"),

            (true, true, false, false, false, true) => MyUiMessagesWidgets.myText(context, "Non ci sono annunci non venduti o non affittati"),

            (true, true, false, true, false, true) => MyUiMessagesWidgets.myText(context, "Non ci sono annunci non venduti o non affittati con offerte"),

            // Caso: ci sono annunci, quindi mostra il carousel
            (true, true, true, _, _, _) => myCarouselSlider(context),
          },
          Align(
            alignment: Alignment.topCenter,
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
              color: context.primaryContainer,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.filter_alt_outlined, color: context.onPrimary,),
                  Text("Filtri", style: TextStyle(color: context.onPrimary, fontWeight: FontWeight.bold),),
                  SizedBox(width: 10,),
                  ToggleButtons(
                    borderRadius: BorderRadius.circular(100),
                    isSelected: selectedOffertePrenotazioni,
                    onPressed: (int index) async {
                      setState(() {
                        selectedOffertePrenotazioni[index] = !selectedOffertePrenotazioni[index];
                        hasUserAnnunci = false;
                        areDataRetrieved = false;
                        areServersAvailable = false;
                      });
                      await getAnnunciConOffertePrenotazioniEDisponibilitaAgente();
                    },
                    children: [
                      Row(
                        children: [
                          Icon(selectedOffertePrenotazioni[0] ? Icons.radio_button_on : Icons.radio_button_off, color: selectedOffertePrenotazioni[0] ? context.onSecondary : context.onPrimary, size: 18,),
                          SizedBox(width: 6,),
                          Text("Offerte", style: TextStyle(color: selectedOffertePrenotazioni[0] ? context.onSecondary : context.onPrimary),),
                          SizedBox(width: 10,)
                        ],
                      ),
                      Row(
                        children: [
                          Icon(selectedOffertePrenotazioni[1] ? Icons.radio_button_on : Icons.radio_button_off, color: selectedOffertePrenotazioni[1] ? context.onSecondary : context.onPrimary, size: 18,),
                          SizedBox(width: 6,),
                          Text("Prenotazioni", style: TextStyle(color: selectedOffertePrenotazioni[1] ? context.onSecondary : context.onPrimary),),
                          SizedBox(width: 15,)
                        ],
                      ),
                    ]
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        selectedDisponibili = !selectedDisponibili;
                        hasUserAnnunci = false;
                        areDataRetrieved = false;
                        areServersAvailable = false;
                      });
                      await getAnnunciConOffertePrenotazioniEDisponibilitaAgente();
                    },
                    child: Row(
                      children: [
                        Icon(selectedDisponibili ? Icons.check_box : Icons.square_outlined, color: selectedDisponibili ? context.onSecondary : context.onPrimary, size: 18,),
                        SizedBox(width: 6,),
                        Text("Disponibili", style: TextStyle(color: selectedDisponibili ? context.onSecondary : context.onPrimary),),
                        SizedBox(width: 15,)
                      ],
                    ),
                  ),
                ],
              ),
            )
          ),
          Positioned(
          bottom: 0,
          left: 250,
          right: -60,
          child: Column(
            children: [
              SizedBox(height: 10,),
              Row(children: [
              SizedBox(width: 5,),
              Expanded(child: MyAddButtonWidget(onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => AgenteCreaAnnuncioPage()));
                setState(() {
                  hasUserAnnunci = false;
                  areDataRetrieved = false;
                  areServersAvailable = false;
                });
                getAnnunciAgente();
              },
              color: context.onSecondary)),
              SizedBox(width: 5,),
              ],),
              SizedBox(height: 10,)
            ],
          )
        )]
      ),
    );
  }

  CarouselSlider myCarouselSlider(BuildContext context) {
    return CarouselSlider(
      items: annunciList.asMap().entries.map((entry) {
        int indice = entry.key;
        AnnuncioDto annuncioCorrente = entry.value;
        double scaleFactor = indice == _currentSliderIndex ? 1.0 : 0.8;
        return GestureDetector(
          onTap: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (context) => AgenteAnnuncioPage(idAnnuncioSelezionato: annuncioCorrente.idAnnuncio!)));
            setState(() {
              hasUserAnnunci = false;
              areDataRetrieved = false;
              areServersAvailable = false;
            });
            getAnnunciAgente();
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
                        // child: Image.asset(casaCorrente['image1']))),
                        child: Image.asset('lib/assets/casa3_1_placeholder.png'))),
                    Row(
                      children: [
                        Expanded(child: Image.asset('lib/assets/casa3_1_placeholder.png')),
                        Expanded(child: Image.asset('lib/assets/casa3_1_placeholder.png')),
                        // Expanded(child: Image.asset(casaCorrente['image2'])),
                        // Expanded(child: Image.asset(casaCorrente['image3'])),
                      ],
                    ),
                    SizedBox(
                      height: scaleFactor * MediaQuery.of(context).size.height/50,
                    ),
                    Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        Text(FormatStrings.formatNumber(annuncioCorrente.prezzo), style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE, fontWeight: FontWeight.bold, color: context.outline)),
                        Text(" EUR", style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE, fontWeight: FontWeight.bold, color: context.outline)),
                        Visibility(
                          visible: annuncioCorrente.tipoAnnuncio == "AFFITTO", 
                          child: Row(
                            children: [
                              SizedBox(width: 3,),
                              Text("/Mese", style: TextStyle(color: context.outline, fontWeight: FontWeight.bold, fontSize: scaleFactor * GRANDEZZA_SCRITTE),),
                            ],
                          )
                        )
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        Icon(Icons.location_on, size: scaleFactor * GRANDEZZA_ICONE, color: context.outline,),
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(annuncioCorrente.indirizzo, style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: context.outline), softWrap: true,)),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                      ],
                    ),
                  ],
                ),  
            ),
            if (annuncioCorrente.stato == "CONCLUSO")
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
                    annuncioCorrente.tipoAnnuncio == "VENDITA" ? "Venduto" : "Affittato",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: context.onError,
                    ),
                  ),
                ),
              ),
            ]
          ),
        );
      }).toList(),
      options: CarouselOptions(
        enableInfiniteScroll: false,
        viewportFraction: 0.56,
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