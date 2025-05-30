import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:domus_app/api_utils/api_key_provider.dart';
import 'package:domus_app/back_end_communication/class_services/annuncio_service.dart';
import 'package:domus_app/back_end_communication/class_services/immagini_service.dart';
import 'package:domus_app/back_end_communication/dto/annuncio/annuncio_dto.dart';
import 'package:domus_app/back_end_communication/dto/annuncio/caratteristiche.dart';
import 'package:domus_app/back_end_communication/dto/annuncio/coordinate.dart';
import 'package:domus_app/back_end_communication/dto/annuncio/filtri_ricerca_dto.dart';
import 'package:domus_app/back_end_communication/dto/annuncio/intervallo_prezzo.dart';
import 'package:domus_app/back_end_communication/dto/annuncio/intervallo_stanze.dart';
import 'package:domus_app/back_end_communication/dto/annuncio/intervallo_superficie.dart';
import 'package:domus_app/back_end_communication/dto/annuncio/vicinanze.dart';
import 'package:domus_app/back_end_communication/dto/immagini_dto.dart';
import 'package:domus_app/pages/shared_pages/annuncio_page.dart';
import 'package:domus_app/ui_elements/utils/formatStrings.dart';
import 'package:domus_app/ui_elements/theme/ui_constants.dart';
import 'package:domus_app/ui_elements/utils/my_buttons_widgets.dart';
import 'package:domus_app/ui_elements/utils/my_pop_up_widgets.dart';
import 'package:domus_app/ui_elements/utils/my_slider_widgets.dart';
import 'package:domus_app/ui_elements/utils/my_text_widgets.dart';
import 'package:domus_app/ui_elements/utils/my_ui_messages_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:auto_size_text/auto_size_text.dart';

const List<String> listaClassiEnergetiche = <String>['Tutte', 'A4', 'A3', 'A2', 'A1', 'B', 'C', 'D', 'E', 'F', 'G'];
const List<String> listaPiani = <String>['Tutti', 'Terra', 'Intermedio', 'Ultimo'];

class CercaPage extends StatefulWidget {
  const CercaPage({super.key});

  @override
  State<CercaPage> createState() => _CercaPageState();
}

class _CercaPageState extends State<CercaPage> {
  List<AnnuncioDto> annunciRecentiList = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final TextEditingController _indirizzoController = TextEditingController();

  final TextEditingController _prezzoMaxController = TextEditingController();

  final TextEditingController _prezzoMinController = TextEditingController();


  final TextEditingController _superficieMinController = TextEditingController();

  final TextEditingController _superficieMaxController = TextEditingController();


  final TextEditingController _numeroStanzeMinController = TextEditingController();

  final TextEditingController _numeroStanzeMaxController = TextEditingController();


  final ScrollController _ricercaAvanzataScrollableController = ScrollController();


  bool _ricercaAvanzataVisibile = false;

  bool _isGarageSelected = false;

  bool _isGiardinoSelected = false;

  bool _isAscensoreSelected = false;

  bool _isPiscinaSelected = false;

  bool _isArredatoSelected = false;

  bool _isBalconeSelected = false;


  bool _isVicinoScuoleSelected = false;

  bool _isVicinoParchiSelected = false;

  bool _isVicinoMezziPubbliciSelected = false;

  double raggioRicerca = 2;
  
  final List<bool> selectedCompraAffitta = <bool>[true, false];

  double? latitudine;
  double? longitudine;

  bool isIndirizzoOk = false;

  String sceltaClasseEnergetica = listaClassiEnergetiche.first;
  String sceltaPiano = listaPiani.first;

  bool areFiltriValidi = true;

  bool hasUserAnnunciRecenti = false;

  bool areServersAvailable = true;

  bool areDataRetrieved = false;

  int _currentSliderIndex = 0;

  @override
  void initState() {
    super.initState();
    getAnnunciRecenti();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
    
  //   // Esegui getAnnunci dopo la fase di build
  //   Future.delayed(Duration.zero, () {
  //     getAnnunciRecenti();
  //   });
  // }

  Future<void> getAnnunciRecenti() async {
    try {

      List<AnnuncioDto> data = await AnnuncioService.recuperaAnnunciRecentementeVisualizzatiByClienteLoggato();

      for(AnnuncioDto annuncio in data){
        List<ImmaginiDto> immaginiPerAnnuncio = await ImmaginiService.recuperaTutteImmaginiByAnnuncio(annuncio);
        ImmaginiDto.ordinaImmaginiPerNumero(immaginiPerAnnuncio);
        annuncio.listaImmagini = immaginiPerAnnuncio;
      }

      for(AnnuncioDto annuncio in data){
        if(annuncio.listaImmagini != null && annuncio.listaImmagini!.isNotEmpty){
          for(ImmaginiDto immagine in annuncio.listaImmagini!){
            immagine.urlS3 = await ImmaginiService.recuperaFileImmagine(immagine.url); 
          }
        }
      }


      if (mounted) {
        setState(() {
          annunciRecentiList = data;
          hasUserAnnunciRecenti = annunciRecentiList.isNotEmpty;
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

  void _toggleRicercaAvanzata(){
    setState(() {
      _ricercaAvanzataVisibile = !_ricercaAvanzataVisibile;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    Color coloreSfondo = context.primary;
    Color coloreScritte = context.outline;
    Color coloreSottolineatura = context.onPrimaryContainer;
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("House Hunters", style: TextStyle(color: context.onSecondary),),
          centerTitle: true,
          backgroundColor: context.primary,
          elevation: 5,
          shadowColor: context.shadow,
          ),
        body: Column(
          children: [
            //tasto Compra Affitta
            myCompraAffittaButton(context),

            Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: SizedBox(
                width: 390,
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    GooglePlacesAutoCompleteTextFormField(
                      onChanged: (value) {
                        setState(() {
                          latitudine = null;
                          longitudine = null;
                          isIndirizzoOk = false;
                        });
                      },
                      textEditingController: _indirizzoController,
                      googleAPIKey: ApiKeyProvider.googleMapsApiKey,
                      decoration: InputDecoration(
                        hintText: 'Inserire un indirizzo',
                        hintStyle: TextStyle(color: coloreScritte),
                        labelText: 'Cerca',
                        labelStyle: TextStyle(color: context.onSecondary),
                        suffixIcon: _indirizzoController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear, color: Colors.grey),
                                onPressed: () {
                                  setState(() {
                                    _indirizzoController.clear();
                                    latitudine = null;
                                    longitudine = null;
                                    isIndirizzoOk = false;
                                  });
                                },
                              )
                            : Icon(Icons.search, color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: coloreSottolineatura),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: coloreSottolineatura),
                        ),
                      ),
                      style: TextStyle(color: context.onPrimary),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      maxLines: 1,
                      overlayContainerBuilder: (child) => Material(
                        elevation: 1.0,
                        color: coloreSfondo,
                        borderRadius: BorderRadius.circular(12),
                        child: child,
                      ),
                      fetchCoordinates: true,
                      onPlaceDetailsWithCoordinatesReceived: (prediction) {
                        print('placeDetails ${prediction.lat} , ${prediction.lng}');
                        latitudine = double.tryParse(prediction.lat ?? '');
                        longitudine = double.tryParse(prediction.lng ?? '');
                        print('new coordinates $latitudine , $longitudine');
                        isIndirizzoOk = true;
                      },
                      onSuggestionClicked: (Prediction prediction) =>
                          _indirizzoController.text = prediction.description!,
                      minInputLength: 3,
                    ),
                  ],
                ),
              ),
            ),

            //Tasto ricerca avanzata
            Align(
              alignment: Alignment.centerRight,
              child: MyTextButtonWidget(
                text: _ricercaAvanzataVisibile ? "Chiudi Ricerca Avanzata" : "Apri Ricerca Avanzata", 
                onPressed: _toggleRicercaAvanzata,
                colore: context.outline
              )
            ),

            //parametri ricerca avanzata
            myParametriRicercaAvanzata(context.outline, context),

            SizedBox(height: MediaQuery.of(context).size.height/35,),

            Visibility(
              visible: _ricercaAvanzataVisibile,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      _ricercaAvanzataScrollableController.animateTo(_ricercaAvanzataScrollableController.position.maxScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
                    },
                    child: Card(
                      color: context.primary,
                      child: 
                        Icon(Icons.arrow_downward, color: context.onSecondary,),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height/200,),
                ],
              )),

            //tasto cerca
            MyElevatedButtonWidget(
              text: "Cerca",
              onPressed: () async {
                controllaFiltri();
                if(_indirizzoController.text.isEmpty || !isIndirizzoOk || !areFiltriValidi){
                  showDialog(
                    context: context, 
                    builder: (BuildContext context) => MyInfoDialog(title: "Errore", bodyText: "Compilare i campi correttamente e riprovare", buttonText: "Ok", onPressed: (){Navigator.pop(context); areFiltriValidi = true;})
                  );
                } else {
                  FiltriRicercaDto filtriRicerca = setCriteriRicerca();
                  await Navigator.pushNamed(
                    context, 
                    '/ControllorePagine2', 
                    arguments: filtriRicerca
                  );

                  setState(() {
                                            hasUserAnnunciRecenti = false;
                                            areDataRetrieved = false;
                                            areServersAvailable = false;
                                          });
                  // setState(() {
                  //   getAnnunciRecenti();
                  // });
                  getAnnunciRecenti();
                }
              },
              color: context.tertiary
            ),
            if (!_ricercaAvanzataVisibile)
              SizedBox(height: MediaQuery.of(context).size.height/15),
              switch ((areDataRetrieved, areServersAvailable, hasUserAnnunciRecenti)) {
                (false, _, _) => Visibility(visible: !_ricercaAvanzataVisibile, child: MyUiMessagesWidgets.myTextWithLoading(context, "Sto recuperando le tue attività recenti, un po' di pazienza"),),
                (true, false, _) => Visibility(
                                      visible: !_ricercaAvanzataVisibile, 
                                      child: MyUiMessagesWidgets.myErrorWithButton(
                                        context, 
                                        "Server non raggiungibili. Controlla la tua connessione a internet e riprova", 
                                        "Riprova", 
                                        (){
                                          setState(() {
                                            hasUserAnnunciRecenti = false;
                                            areDataRetrieved = false;
                                            areServersAvailable = false;
                                          });
                                          getAnnunciRecenti();
                                        }
                                      ),
                                    ),
                (true, true, false) => Visibility(visible: !_ricercaAvanzataVisibile, child: MyUiMessagesWidgets.myText(context, "Benvenuto! Non hai ancora annunci visitati di recente")),
                (true, true, true) => myCronologia(context, context.outline),
              }
          ],
        )
      ),
    );
  }

  void controllaFiltri() {
    if(_prezzoMaxController.text.isNotEmpty && _prezzoMinController.text.isNotEmpty) {
      if(int.parse(_prezzoMaxController.text) < int.parse(_prezzoMinController.text)){
        areFiltriValidi = false;
      }
    }
    if(_superficieMaxController.text.isNotEmpty && _superficieMinController.text.isNotEmpty) {
      if(int.parse(_superficieMaxController.text) < int.parse(_superficieMinController.text)){
        areFiltriValidi = false;
      }
    }
    
    if(_numeroStanzeMaxController.text.isNotEmpty && _numeroStanzeMinController.text.isNotEmpty) {
      if(int.parse(_numeroStanzeMaxController.text) < int.parse(_numeroStanzeMinController.text)){
        areFiltriValidi = false;
      }
    }
  }

  FiltriRicercaDto setCriteriRicerca() {
    FiltriRicercaDto filtriRicerca = FiltriRicercaDto(
      coordinate: Coordinate(latitudine: latitudine ?? 0.0, longitudine: longitudine ?? 0.0), 
      tipoAnnuncio: selectedCompraAffitta.first ? "VENDITA" : "AFFITTO",
      raggioRicerca: raggioRicerca,
      intervalloPrezzo: IntervalloPrezzo(
        prezzoMinimo: _prezzoMinController.text.isNotEmpty ? double.tryParse(_prezzoMinController.text) : null, 
        prezzoMassimo: _prezzoMaxController.text.isNotEmpty ? double.tryParse(_prezzoMaxController.text) : null,
      ),
      intervalloSuperficie: IntervalloSuperficie(
        superficieMinima: _superficieMinController.text.isNotEmpty ? int.parse(_superficieMinController.text) : null,
        superficieMassima: _superficieMaxController.text.isNotEmpty ? int.parse(_superficieMaxController.text) : null,
      ),
      intervalloStanze: IntervalloStanze(
        numStanzeMinime: _numeroStanzeMinController.text.isNotEmpty ? int.parse(_numeroStanzeMinController.text) : null,
        numStanzeMassime: _numeroStanzeMaxController.text.isNotEmpty ? int.parse(_numeroStanzeMaxController.text) : null,
      ),
      caratteristiche: Caratteristiche(
        garage: _isGarageSelected ? true : null,
        ascensore: _isAscensoreSelected ? true : null,
        piscina: _isPiscinaSelected ? true : null,
        arredo: _isArredatoSelected ? true : null,
        balcone: _isBalconeSelected ? true : null,
        giardino: _isGiardinoSelected ? true : null,
      ),
      vicinanze: Vicinanze(
        vicinoScuole : _isVicinoScuoleSelected ? _isVicinoScuoleSelected : null,
        vicinoParchi : _isVicinoParchiSelected ? _isVicinoParchiSelected : null,
        vicinoTrasporti : _isVicinoMezziPubbliciSelected ? _isVicinoMezziPubbliciSelected : null,
      ),
      piano : sceltaPiano == "Tutti" ? null : sceltaPiano,
      classeEnergetica : sceltaClasseEnergetica == "Tutte" ? null : sceltaClasseEnergetica,
    );
    return filtriRicerca;
  }

  Visibility myCronologia(BuildContext context, Color colorePulsanti) {
    return Visibility(
      visible: !_ricercaAvanzataVisibile, 
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: MediaQuery.of(context).size.width/9,),
              Icon(Icons.history, color: colorePulsanti,),
              Text('Ultime visite', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorePulsanti),),
            ],
          ),
          myCarouselSlider(context),
        ],
      )
    );
  }

  CarouselSlider myCarouselSlider(BuildContext context) {
    return CarouselSlider(
      items: annunciRecentiList.asMap().entries.map((entry) {
        int indice = entry.key;
        AnnuncioDto annuncioCorrente = entry.value;
        double scaleFactor = indice == _currentSliderIndex ? 0.9 : 0.5;
        return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AnnuncioPage(idAnnuncioSelezionato: annuncioCorrente.idAnnuncio!)));
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
                        height: 154,
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
                                child: (annuncioCorrente.listaImmagini != null && annuncioCorrente.listaImmagini!.isNotEmpty && annuncioCorrente.listaImmagini!.length>=1  &&
                                        annuncioCorrente.listaImmagini!.first.urlS3 != null && annuncioCorrente.listaImmagini!.first.urlS3!.isNotEmpty) ?
                                        Image.network(annuncioCorrente.listaImmagini!.first.urlS3!, 
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
                          height: 95,
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
                                child: (annuncioCorrente.listaImmagini != null && annuncioCorrente.listaImmagini!.isNotEmpty && annuncioCorrente.listaImmagini!.length>=2  &&
                                        annuncioCorrente.listaImmagini!.elementAt(1).urlS3 != null && annuncioCorrente.listaImmagini!.elementAt(1).urlS3!.isNotEmpty) ?
                                        Image.network(annuncioCorrente.listaImmagini!.elementAt(1).urlS3!, 
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
                          height: 95,
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
                                child: (annuncioCorrente.listaImmagini != null && annuncioCorrente.listaImmagini!.isNotEmpty && annuncioCorrente.listaImmagini!.length>=3  &&
                                        annuncioCorrente.listaImmagini!.elementAt(2).urlS3 != null && annuncioCorrente.listaImmagini!.elementAt(2).urlS3!.isNotEmpty) ?
                                        Image.network(annuncioCorrente.listaImmagini!.elementAt(2).urlS3!, 
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
                        Text(FormatStrings.formatNumber(annuncioCorrente.prezzo), style: TextStyle(fontSize: scaleFactor * 23, fontWeight: FontWeight.bold, color: context.outline)),
                        Text(" EUR", style: TextStyle(fontSize: scaleFactor * 20, fontWeight: FontWeight.bold, color: context.outline),),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        Icon(Icons.location_on, size: scaleFactor * 22, color: context.outline,),
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        Expanded(
                          child: AutoSizeText(
                            annuncioCorrente.indirizzo,
                            style: TextStyle(
                              fontSize: scaleFactor * 18,
                              fontWeight: FontWeight.normal,
                              color: context.outline,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 12,
                          ),
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
            ],
          ),
        );
      }).toList(),
      options: CarouselOptions(
        enableInfiniteScroll: false,
        viewportFraction: 0.8,
        height: 360,
        enlargeCenterPage: true,
        onPageChanged: (indiceCasaCorrente, reason) {
          setState(() {
            _currentSliderIndex = indiceCasaCorrente;
          });
        }
      ));
  }

  Visibility myParametriRicercaAvanzata(Color colorePulsanti, BuildContext context) {
    return Visibility(
            visible: _ricercaAvanzataVisibile,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Scrollbar(
                controller: _ricercaAvanzataScrollableController,
                thickness: 5,
                thumbVisibility: true,
                radius: Radius.circular(10),
                child: SingleChildScrollView(
                  controller: _ricercaAvanzataScrollableController,
                  child: Column(
                    children: [
                      
                      RadiusSlider(
                        initialRadius: raggioRicerca,
                        onChanged: (value) {
                          setState(() {
                            raggioRicerca = value;
                          });
                        }
                      ),
                  
                      //prezzo
                      myFiltroRicerca(colorePulsanti, context, Icons.euro, _prezzoMinController, _prezzoMaxController, "Prezzo Min", "Prezzo Max"),
                  
                      //superficie
                      myFiltroRicerca(colorePulsanti, context, Icons.zoom_out_map, _superficieMinController, _superficieMaxController, "Superficie Min", "Superficie Max"),
                  
                      //Stanze
                      myFiltroRicerca(colorePulsanti, context, FontAwesomeIcons.doorClosed, _numeroStanzeMinController, _numeroStanzeMaxController, "N. Stanze Min", "N. Stanze Max"),
                      
                      Divider(height: 50, thickness: 2, indent: 10, endIndent: 10, color: context.onSecondary,),
                  
                      Row(
                        children: [
                  
                          SizedBox(width: 10.0),
                  
                          //Colonna comunista
                          Column(
                            children: [
                  
                              //Riga contenente tre colonne
                              Row(
                                children: [
                  
                                  //Colonna contenente icone
                                  Column(
                                    children: [
                                      Icon(FontAwesomeIcons.car, size: 22, color: colorePulsanti,),
                                      SizedBox(height: 22,),
                                      Icon(FontAwesomeIcons.elevator, size: 22, color: colorePulsanti,),
                                      SizedBox(height: 22,),
                                      Icon(FontAwesomeIcons.chair, size: 22, color: colorePulsanti,),
                                    ],
                                  ),
                  
                                  SizedBox(width: 10,),
                                  
                                  //Colonna contenente nomi
                                  Column(
                                    children: [
                                      Text("Garage", style: TextStyle(fontSize: 18.0, color: colorePulsanti),),
                                      SizedBox(height: 22,),
                                      Text("Ascensore", style: TextStyle(fontSize: 18.0, color: colorePulsanti)),
                                      SizedBox(height: 22,),
                                      Text("Arredato", style: TextStyle(fontSize: 18.0, color: colorePulsanti)),
                                    ],
                                  ),
                                  
                                  SizedBox(width: 10,),
                  
                                  //colonna contenente switch
                                  Column(
                                    children: [
                                      Switch(
                                        activeTrackColor: context.onSecondary,
                                        activeColor: context.primary,
                                        value: _isGarageSelected, 
                                        onChanged: (value){
                                          setState(() {
                                            _isGarageSelected = value;
                                          });
                                        }
                                      ),
                                      Switch(
                                        activeTrackColor: context.onSecondary,
                                        activeColor: context.primary,
                                        value: _isAscensoreSelected, 
                                        onChanged: (value){
                                          setState(() {
                                            _isAscensoreSelected = value;
                                          });
                                        }
                                      ),
                                      Switch(
                                        activeTrackColor: context.onSecondary,
                                        activeColor: context.primary,
                                        value: _isArredatoSelected, 
                                        onChanged: (value){
                                          setState(() {
                                            _isArredatoSelected = value;
                                          });
                                        }
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                  
                          SizedBox(width: 30.0),
                  
                          //Colonna fascista
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                  
                             Row(
                                children: [
                  
                                  //Colonna contenente icone
                                  Column(
                                    children: [
                                      Icon(Icons.park, size: 22, color: colorePulsanti,),
                                      SizedBox(height: 22,),
                                      Icon(Icons.pool, size: 22, color: colorePulsanti,),
                                      SizedBox(height: 22,),
                                      Icon(Icons.balcony, size: 22, color: colorePulsanti,),
                                    ],
                                  ),
                  
                                  SizedBox(width: 10,),
                                  
                                  //Colonna contenente nomi
                                  Column(
                                    children: [
                                      Text("Giardino", style: TextStyle(fontSize: 18.0, color: colorePulsanti),),
                                      SizedBox(height: 22,),
                                      Text("Piscina", style: TextStyle(fontSize: 18.0, color: colorePulsanti)),
                                      SizedBox(height: 22,),
                                      Text("Balcone", style: TextStyle(fontSize: 18.0, color: colorePulsanti)),
                                    ],
                                  ),
                                  
                                  SizedBox(width: 10,),
                  
                                  //colonna contenente switch
                                  Column(
                                    children: [
                                      Switch(
                                        activeTrackColor: context.onSecondary,
                                        activeColor: context.primary,
                                        value: _isGiardinoSelected, 
                                        onChanged: (value){
                                          setState(() {
                                            _isGiardinoSelected = value;
                                          });
                                        }
                                      ),
                                      Switch(
                                        activeTrackColor: context.onSecondary,
                                        activeColor: context.primary,
                                        value: _isPiscinaSelected, 
                                        onChanged: (value){
                                          setState(() {
                                            _isPiscinaSelected = value;
                                          });
                                        }
                                      ),
                                      Switch(
                                        activeTrackColor: context.onSecondary,
                                        activeColor: context.primary,
                                        value: _isBalconeSelected, 
                                        onChanged: (value){
                                          setState(() {
                                            _isBalconeSelected = value;
                                          });
                                        }
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                  
                      Divider(height: 50, thickness: 2, indent: 10, endIndent: 10, color: context.onSecondary,),
                  
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                  
                          SizedBox(width: 10.0),
                  
                          //Colonna comunista
                          Column(
                            children: [
                  
                              //Riga contenente tre colonne
                              Row(
                                children: [
                  
                                  //Colonna contenente icone
                                  Column(
                                    children: [
                                      Icon(FontAwesomeIcons.school, size: 22, color: colorePulsanti,),
                                      SizedBox(height: 22,),
                                      Icon(FontAwesomeIcons.sunPlantWilt, size: 22, color: colorePulsanti,),
                                      SizedBox(height: 22,),
                                      Icon(FontAwesomeIcons.bus, size: 22, color: colorePulsanti,),
                                    ],
                                  ),
                  
                                  SizedBox(width: 10,),
                                  
                                  //Colonna contenente nomi
                                  Column(
                                    children: [
                                      Text("Vicino scuole", style: TextStyle(fontSize: 18.0, color: colorePulsanti, ),),
                                      SizedBox(height: 22,),
                                      Text("Vicino parchi pubblici", style: TextStyle(fontSize: 18.0, color: colorePulsanti)),
                                      SizedBox(height: 22,),
                                      Text("Vicino fermate mezzi pubblici", style: TextStyle(fontSize: 18.0, color: colorePulsanti)),
                                    ],
                                  ),
                                  
                                  SizedBox(width: 10,),
                  
                                  //colonna contenente switch
                                  Column(
                                    children: [
                                      Switch(
                                        activeTrackColor: context.onSecondary,
                                        activeColor: context.primary,
                                        value: _isVicinoScuoleSelected, 
                                        onChanged: (value){
                                          setState(() {
                                            _isVicinoScuoleSelected = value;
                                          });
                                        }
                                      ),
                                      Switch(
                                        activeTrackColor: context.onSecondary,
                                        activeColor: context.primary,
                                        value: _isVicinoParchiSelected, 
                                        onChanged: (value){
                                          setState(() {
                                            _isVicinoParchiSelected = value;
                                          });
                                        }
                                      ),
                                      Switch(
                                        activeTrackColor: context.onSecondary,
                                        activeColor: context.primary,
                                        value: _isVicinoMezziPubbliciSelected, 
                                        onChanged: (value){
                                          setState(() {
                                            _isVicinoMezziPubbliciSelected = value;
                                          });
                                        }
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                    ]),
                      
                      Divider(height: 50, thickness: 2, indent: 10, endIndent: 10, color: context.onSecondary,),
                  
                      //Selettore Piano
                      SizedBox(
                        height: 50,
                        width: MediaQuery.sizeOf(context).width/1,
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(width: 30.0),
                            Text("Piano", style: TextStyle(fontSize: 18.0, color: colorePulsanti),),
                            SizedBox(width: 150.0),
                            DropdownMenu(
                              width: 175,
                              textStyle: TextStyle(color: colorePulsanti),
                              inputDecorationTheme: InputDecorationTheme(labelStyle: TextStyle(color: context.onSecondary), suffixIconColor: colorePulsanti),
                              initialSelection: listaPiani.first,
                              onSelected: (String? value) {
                                setState(() {
                                  sceltaPiano = value!;
                                });
                              },
                              dropdownMenuEntries: 
                                listaPiani.map<DropdownMenuEntry<String>>((String value) {
                                return DropdownMenuEntry<String>(
                                  value: value, 
                                  label: value, 
                                  style: ButtonStyle(
                                          foregroundColor: WidgetStateProperty.all(colorePulsanti),
                                          backgroundColor: WidgetStateProperty.all(Colors.transparent)));}).toList(),
                            ),
                          ],
                        ),
                      ),
                  
                      SizedBox(height: 10.0),
                  
                      //Selettore Classe Energetica
                      SizedBox(
                        height: 50,
                        width: MediaQuery.sizeOf(context).width/1,
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(width: 30.0),
                            Text("Classe Energetica", style: TextStyle(fontSize: 18.0, color: colorePulsanti),),
                            SizedBox(width: 50.0),
                            DropdownMenu(
                              width: 175,
                              textStyle: TextStyle(color: colorePulsanti),
                              inputDecorationTheme: InputDecorationTheme(labelStyle: TextStyle(color: colorePulsanti), suffixIconColor: colorePulsanti),
                              initialSelection: listaClassiEnergetiche.first,
                              onSelected: (String? value) {
                                setState(() {
                                  sceltaClasseEnergetica = value!;
                                });
                              },
                              dropdownMenuEntries: 
                                listaClassiEnergetiche.map<DropdownMenuEntry<String>>((String value) {
                                return DropdownMenuEntry<String>(
                                  value: value, 
                                  label: value,
                                  style: ButtonStyle(
                                          foregroundColor: WidgetStateProperty.all(colorePulsanti),
                                          backgroundColor: WidgetStateProperty.all(Colors.transparent)));}).toList(),
                                ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Row myFiltroRicerca(Color colorePulsanti, BuildContext context, IconData icona, TextEditingController controllerMin, TextEditingController controllerMax, String nomeMin, String nomeMax) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Icon(icona, size: 22, color: colorePulsanti,),
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.40,
          child: MyTextFieldOnlyPositiveNumbers(controller: controllerMin, text: nomeMin, colore: colorePulsanti,)
        ),
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.40, 
          child: MyTextFieldOnlyPositiveNumbers(controller: controllerMax, text: nomeMax, colore: colorePulsanti,)
        ),
      ],
    );
  }

  Align myCompraAffittaButton(BuildContext context) {
    final List<IconData> icons = [Icons.monetization_on, Icons.real_estate_agent];
    final List<String> labels = ["Compra", "Affitta"];
    return Align(
      alignment: Alignment.centerLeft,
      widthFactor: 2.37,
      heightFactor: 1.5,
      child: ToggleButtons(
        onPressed: (int index) {
          setState(() {
            for (int i = 0; i < selectedCompraAffitta.length; i++) {
              selectedCompraAffitta[i] = i == index;
            }
          });
        },
        borderRadius: BorderRadius.circular(30),
        borderColor: context.outline,
        selectedBorderColor: context.outline,
        selectedColor: context.onError,
        fillColor: context.onSecondary,
        color: context.outline,
        constraints: const BoxConstraints(
          minHeight: 30.0,
          minWidth: 40.0,
        ),
        isSelected: selectedCompraAffitta,
        children: List.generate(selectedCompraAffitta.length, (index) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: selectedCompraAffitta[index] ? 16 : 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(selectedCompraAffitta[index] ? 30 : 15),
              color: selectedCompraAffitta[index] ? context.onSecondary : Colors.transparent,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icons[index],
                  color: selectedCompraAffitta[index]
                      ? context.onError
                      : context.outline,
                ),
                if (selectedCompraAffitta[index]) ...[
                  SizedBox(width: 8),
                  Text(
                    labels[index],
                    style: TextStyle(color: context.onError),
                  ),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }
}