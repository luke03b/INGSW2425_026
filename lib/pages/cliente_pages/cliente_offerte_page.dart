import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:domus_app/back_end_communication/class_services/immagini_service.dart';
import 'package:domus_app/back_end_communication/class_services/offerta_service.dart';
import 'package:domus_app/back_end_communication/communication_utils/status_code_controller.dart';
import 'package:domus_app/back_end_communication/dto/immagini_dto.dart';
import 'package:domus_app/back_end_communication/dto/offerta_dto.dart';
import 'package:domus_app/costants/enumerations.dart';
import 'package:domus_app/pages/shared_pages/annuncio_page.dart';
import 'package:domus_app/ui_elements/utils/formatStrings.dart';
import 'package:domus_app/ui_elements/theme/ui_constants.dart';
import 'package:domus_app/ui_elements/utils/my_buttons_widgets.dart';
import 'package:domus_app/ui_elements/utils/my_loading.dart';
import 'package:domus_app/ui_elements/utils/my_pop_up_widgets.dart';
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
    getAnnunciConOfferte();
  }

  Future<void> getAnnunciConOfferte() async {
    try {

      List<OffertaDto> data = await OffertaService.recuperaAnnunciConOfferteByClienteLoggato();

      for(OffertaDto offerta in data){
        List<ImmaginiDto> immaginiPerAnnuncio = await ImmaginiService.recuperaTutteImmaginiByAnnuncio(offerta.annuncio);
        ImmaginiDto.ordinaImmaginiPerNumero(immaginiPerAnnuncio);
        offerta.annuncio.listaImmagini = immaginiPerAnnuncio;
      }

      for(OffertaDto offerta in data){
        if(offerta.annuncio.listaImmagini != null && offerta.annuncio.listaImmagini!.isNotEmpty){
          for(ImmaginiDto immagine in offerta.annuncio.listaImmagini!){
            immagine.urlS3 = await ImmaginiService.recuperaFileImmagine(immagine.url); 
          }
        }
      }

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
            Navigator.push(context, MaterialPageRoute(builder: (context) => AnnuncioPage(idAnnuncioSelezionato: offertaSelezionata.annuncio.idAnnuncio!)));
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
                                child: (offertaSelezionata.annuncio.listaImmagini != null && offertaSelezionata.annuncio.listaImmagini!.isNotEmpty && offertaSelezionata.annuncio.listaImmagini!.length>=1  &&
                                        offertaSelezionata.annuncio.listaImmagini!.first.urlS3 != null && offertaSelezionata.annuncio.listaImmagini!.first.urlS3!.isNotEmpty) ?
                                        Image.network(offertaSelezionata.annuncio.listaImmagini!.first.urlS3!, 
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
                                child: (offertaSelezionata.annuncio.listaImmagini != null && offertaSelezionata.annuncio.listaImmagini!.isNotEmpty && offertaSelezionata.annuncio.listaImmagini!.length>=2  &&
                                        offertaSelezionata.annuncio.listaImmagini!.elementAt(1).urlS3 != null && offertaSelezionata.annuncio.listaImmagini!.elementAt(1).urlS3!.isNotEmpty) ?
                                        Image.network(offertaSelezionata.annuncio.listaImmagini!.elementAt(1).urlS3!, 
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
                                child: (offertaSelezionata.annuncio.listaImmagini != null && offertaSelezionata.annuncio.listaImmagini!.isNotEmpty && offertaSelezionata.annuncio.listaImmagini!.length>=3  &&
                                        offertaSelezionata.annuncio.listaImmagini!.elementAt(2).urlS3 != null && offertaSelezionata.annuncio.listaImmagini!.elementAt(2).urlS3!.isNotEmpty) ?
                                        Image.network(offertaSelezionata.annuncio.listaImmagini!.elementAt(2).urlS3!, 
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
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        Text("La tua offerta: ", style: TextStyle(fontSize: scaleFactor * 22, fontWeight: FontWeight.bold, color: context.outline)),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child:Text((FormatStrings.mappaStatoOfferta(offertaSelezionata.stato!) == "Accettata" || FormatStrings.mappaStatoOfferta(offertaSelezionata.stato!) == "Rifiutata") && offertaSelezionata.controproposta != null ? FormatStrings.formatNumber(offertaSelezionata.controproposta!) : FormatStrings.formatNumber(offertaSelezionata.prezzo), style: TextStyle(fontSize: scaleFactor * 22, fontWeight: FontWeight.normal, color: context.outline))))),
                        Text(" EUR", style: TextStyle(fontSize: scaleFactor * 20, fontWeight: FontWeight.normal, color: context.outline)),
                        Visibility(
                          visible: offertaSelezionata.annuncio.tipoAnnuncio == "AFFITTO", 
                          child: Row(
                            children: [
                              SizedBox(width: 3,),
                              Text("/Mese", style: TextStyle(color: context.outline, fontWeight: FontWeight.normal, fontSize: scaleFactor * 22),),
                            ],
                          )
                        )
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
                              Visibility(
                                visible: offertaSelezionata.annuncio.tipoAnnuncio == "AFFITTO", 
                                child: Row(
                                  children: [
                                    SizedBox(width: 3,),
                                    Text("/Mese", style: TextStyle(color: selettoreColoreStatoOfferta(FormatStrings.mappaStatoOfferta(offertaSelezionata.stato!)), fontWeight: FontWeight.normal, fontSize: scaleFactor * 22),),
                                  ],
                                )
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: FormatStrings.mappaStatoOfferta(offertaSelezionata.stato!) == "Controproposta",
                      child: Row(
                        children: [
                          SizedBox(width: 17,),
                          SizedBox(
                            width: 150,
                            child: MyElevatedButtonRectWidget(
                              text: "Accetta", 
                              onPressed: () async {
                                showDialog(
                                  context: 
                                  context, builder: (BuildContext context) => MyOptionsDialog(
                                    title: "Accettare controproposta", 
                                    bodyText: "Si vuole accettare la controproposta di ${FormatStrings.formatNumber(offertaSelezionata.controproposta!)}?", 
                                    leftButtonText: "No", 
                                    leftButtonColor: context.secondary, 
                                    rightButtonText: "Si", 
                                    rightButtonColor: context.tertiary, 
                                    onPressLeftButton: () async {
                                      Navigator.pop(context);
                                    },
                                    onPressRightButton: () async {
                                      LoadingHelper.showLoadingDialog(context);
                                      try {
                                        int statusCode = await OffertaService.aggiornaStatoOfferta(offertaSelezionata, Enumerations.statoOfferte[1]);
                                        await StatusCodeController.controllaStatusCodeAndShowPopUp(context, statusCode, 200, "Conferma", "Controproposta accettata", "Errore", "Controproposta non accettata");
                                        setState(() {
                                          hasUserOfferte = false;
                                          areDataRetrieved = false;
                                          areServersAvailable = false;
                                        });
                                        getAnnunciConOfferte();
                                      }on TimeoutException {
                                        showDialog(
                                          context: context, 
                                          builder: (BuildContext context) => MyInfoDialog(
                                            title: "Connessione non riuscita", 
                                            bodyText: "Controproposta non accettata, la connessione con i nostri server non è stata stabilita correttamente. Riprova più tardi.", 
                                            buttonText: "Ok", 
                                            onPressed: () {Navigator.pop(context);}
                                          )
                                        );
                                      } catch (e) {
                                        print(e);
                                        showDialog(
                                          context: context, 
                                          builder: (BuildContext context) => MyInfoDialog(
                                            title: "Errore",
                                            bodyText: "Controproposta non accettata.", 
                                            buttonText: "Ok", 
                                            onPressed: () {Navigator.pop(context);}
                                          )
                                        );
                                      }
                                    }
                                  )
                                );
                              }, 
                              color: context.tertiary
                            ),
                          ),
                          SizedBox(width: 8,),
                          SizedBox(
                            width: 150,
                            child: MyElevatedButtonRectWidget(
                              text: "Rifiuta", 
                              onPressed: () async {
                                showDialog(
                                  context: 
                                  context, builder: (BuildContext context) => MyOptionsDialog(
                                    title: "Rifiutare controproposta", 
                                    bodyText: "Si vuole rifiutare la controproposta di ${FormatStrings.formatNumber(offertaSelezionata.controproposta!)}?", 
                                    leftButtonText: "No", 
                                    leftButtonColor: context.secondary, 
                                    rightButtonText: "Si", 
                                    rightButtonColor: context.tertiary, 
                                    onPressLeftButton: () async {
                                      Navigator.pop(context);
                                    }, 
                                    onPressRightButton: () async {
                                      LoadingHelper.showLoadingDialog(context);
                                      try {
                                        int statusCode = await OffertaService.aggiornaStatoOfferta(offertaSelezionata, Enumerations.statoOfferte[2]);
                                        await StatusCodeController.controllaStatusCodeAndShowPopUp(context, statusCode, 200, "Conferma", "Controproposta rifiutata", "Errore", "Controproposta non rifiutata");
                                        setState(() {
                                          hasUserOfferte = false;
                                          areDataRetrieved = false;
                                          areServersAvailable = false;
                                        });
                                        getAnnunciConOfferte();
                                      }on TimeoutException {
                                        showDialog(
                                          context: context, 
                                          builder: (BuildContext context) => MyInfoDialog(
                                            title: "Connessione non riuscita", 
                                            bodyText: "Controproposta non rifiutata, la connessione con i nostri server non è stata stabilita correttamente. Riprova più tardi.", 
                                            buttonText: "Ok", 
                                            onPressed: () {Navigator.pop(context);}
                                          )
                                        );
                                      } catch (e) {
                                        print(e);
                                        showDialog(
                                          context: context, 
                                          builder: (BuildContext context) => MyInfoDialog(
                                            title: "Errore",
                                            bodyText: "Controproposta non rifiutata.", 
                                            buttonText: "Ok", 
                                            onPressed: () {Navigator.pop(context);}
                                          )
                                        );
                                      }
                                    }
                                  )
                                );
                              }, 
                              color: context.secondary
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: scaleFactor * MediaQuery.of(context).size.height/75,
                    ),
                    Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        Text("Data offerta: ", style: TextStyle(fontSize: scaleFactor * 17, fontWeight: FontWeight.bold, color: context.outline)),
                        Text(FormatStrings.formattaDataGGMMAAAAeHHMM(offertaSelezionata.data!), style: TextStyle(fontSize: scaleFactor * 17, fontWeight: FontWeight.normal, color: context.outline)),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        Text(FormatStrings.formatNumber(offertaSelezionata.annuncio.prezzo), style: TextStyle(fontSize: scaleFactor * 20, fontWeight: FontWeight.bold, color: context.outline)),
                        Text(" EUR", style: TextStyle(fontSize: scaleFactor * 20, fontWeight: FontWeight.bold, color: context.outline)),
                        Visibility(
                          visible: offertaSelezionata.annuncio.tipoAnnuncio == "AFFITTO", 
                          child: Row(
                            children: [
                              SizedBox(width: 3,),
                              Text("/Mese", style: TextStyle(color: context.outline, fontWeight: FontWeight.normal, fontSize: scaleFactor * 20),),
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
                            offertaSelezionata.annuncio.indirizzo,
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
              if (offertaSelezionata.annuncio.stato == "CONCLUSO")
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
                    offertaSelezionata.annuncio.tipoAnnuncio == "VENDITA" ? "Venduto" : "Affittato",
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
        viewportFraction: 0.752,
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