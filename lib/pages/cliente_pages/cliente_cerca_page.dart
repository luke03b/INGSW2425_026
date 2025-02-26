import 'package:carousel_slider/carousel_slider.dart';
import 'package:domus_app/dto/filtri_ricerca.dart';
import 'package:domus_app/pages/cliente_pages/cliente_annuncio_page.dart';
import 'package:domus_app/theme/ui_constants.dart';
import 'package:domus_app/utils/my_buttons_widgets.dart';
import 'package:domus_app/utils/my_pop_up_widgets.dart';
import 'package:domus_app/utils/my_slider_widgets.dart';
import 'package:domus_app/utils/my_text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';

const List<String> listaClassiEnergetiche = <String>['Tutte', 'A4', 'A3', 'A2', 'A1', 'B', 'C', 'D', 'E', 'F', 'G'];
const List<String> listaPiani = <String>['Tutti', 'Terra', 'Intermedio', 'Ultimo'];

class CercaPage extends StatefulWidget {
  const CercaPage({super.key});

  @override
  State<CercaPage> createState() => _CercaPageState();
}

class _CercaPageState extends State<CercaPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

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

  bool isIndirizzoValido = false;

  String sceltaClasseEnergetica = listaClassiEnergetiche.first;
  String sceltaPiano = listaPiani.first;

  int _currentSliderIndex = 0;

  final List<Map<String, dynamic>> listaCase = [
    {
      'image1': 'lib/assets/casa1_1_placeholder.png',
      'image2' : 'lib/assets/casa1_2_placeholder.png',
      'image3' : 'lib/assets/casa1_3_placeholder.png',
      'prezzo': '275.000',
      'indirizzo': 'Via Dalmazia 13,\nCavalleggeri 80124 (NA)',
      'superficie': '100 mq',
      'numero_stanze': '6',
      'arredato' : "si",
      'piano' : 'Terra',
      'descrizione' : 'Nel cuore della rinomata collina di Posillipo, in una posizione dominante che regala una vista senza pari sul golfo di Napoli, Christie\'s International Real Estate propone in vendita un appartamento di 174 mq, un\'esclusiva residenza che fonde eleganza, comfort e luminosità. Questo immobile, caratterizzato da ampi spazi interni, è arricchito da una spettacolare superficie esterna di 286 mq, che include ampi balconi, un terrazzo panoramico di copertura e una veranda, tutti luoghi ideali per godere di momenti di convivialità e relax, circondati da un panorama unico. Posto all\'ultimo piano di un elegante edificio, questo appartamento si distingue per la luminosità che inonda ogni ambiente grazie all\'esposizione ideale e alle ampie vetrate che permettono di godere della vista sul mare in ogni angolo della casa. Il soggiorno doppio, spazioso e raffinato, offre un affaccio diretto sul mare, creando un ambiente perfetto per rilassarsi o intrattenere ospiti. La zona notte comprende tre camere da letto, tutte silenziose e confortevoli, mentre i due bagni e la cucina abitabile con accesso indipendente completano l\'immobile con praticità e funzionalità. Gli spazi esterni, ampi e ben progettati, offrono la possibilità di vivere all\'aperto durante tutto l\'anno, con aree ideali per cene all\'aperto, eventi sociali o semplicemente per godere di momenti di tranquillità, immersi nella bellezza naturale di Posillipo. A completare questa straordinaria proprieta\', una cantina e due posti auto coperti, per garantire il massimo della comodità e della sicurezza. Un\'opportunità imperdibile per chi cerca una residenza di lusso in uno dei quartieri più esclusivi di Napoli, dove la bellezza senza tempo del mare si fonde con il comfort moderno.',
      'vicino_scuole' : 'si',
      'vicino_parchi' : 'no',
      'vicino_mezzi' : 'si',
      'agenzia' : 'ideaCasa',
      'agente' : 'Carlo Conti'
    },
    {
      'image1': 'lib/assets/casa2_1_placeholder.png',
      'image2' : 'lib/assets/casa2_2_placeholder.png',
      'image3' : 'lib/assets/casa2_3_placeholder.png',
      'prezzo': '300.000',
      'indirizzo': 'Via Dalmazia 14,\nCavalleggeri 80124 (NA)',
      'superficie': '120 mq',
      'numero_stanze': '7',
      'arredato' : "no",
      'piano' : 'Ultimo',
      'descrizione' : '',
      'vicino_scuole' : 'no',
      'vicino_parchi' : 'no',
      'vicino_mezzi' : 'si',
      'agenzia' : 'casaBella',
      'agente' : 'Lucio Corsi'
    },
    {
      'image1': 'lib/assets/casa3_1_placeholder.png',
      'image2' : 'lib/assets/casa3_2_placeholder.png',
      'image3' : 'lib/assets/casa3_3_placeholder.png',
      'prezzo': '250.000',
      'indirizzo': 'Via Dalmazia 10,\nCavalleggeri 80124 (NA)',
      'superficie': '80 mq',
      'numero_stanze': '5',
      'arredato' : "si",
      'piano' : '3',
      'descrizione' : '',
      'vicino_scuole' : 'si',
      'vicino_parchi' : 'si',
      'vicino_mezzi' : 'si',
      'agenzia' : 'trovaCasa',
      'agente' : 'Marcella Bella',
    },

  ];

  void _toggleRicercaAvanzata(){
    setState(() {
      _ricercaAvanzataVisibile = !_ricercaAvanzataVisibile;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    Color coloreScritte = context.onSecondary;
    Color coloreScritte2 = context.onPrimary;
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
                width: MediaQuery.sizeOf(context).width * 0.92,
                child: GooglePlacesAutoCompleteTextFormField(
                  onChanged: (value){
                    setState(() {
                      latitudine = null;
                      longitudine = null;
                    });
                  },
                  textEditingController: _indirizzoController,
                  googleAPIKey: "AIzaSyBUkzr-VCtKVyTTfssndaWR5Iy5TyfM0as",
                  decoration: InputDecoration(
                    hintText: 'Inserire una zona di ricerca',
                    hintStyle: TextStyle(color: coloreScritte),
                    labelText: 'Cerca',
                    labelStyle: TextStyle(color: coloreScritte),
                  ),
                  style: TextStyle(color: coloreScritte2),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  // proxyURL: _yourProxyURL,
                  maxLines: 1,
                  overlayContainerBuilder: (child) => Material(
                    elevation: 1.0,
                    color: context.primary,
                    borderRadius: BorderRadius.circular(12),
                    child: child
                  ),
                  fetchCoordinates: true,
                  onPlaceDetailsWithCoordinatesReceived: (prediction) {
                    print('placeDetails ${prediction.lat} , ${prediction.lng}');
                    latitudine = double.tryParse(prediction.lat ?? '');
                    longitudine = double.tryParse(prediction.lng ?? '');
                    print('new coordinates $latitudine , $longitudine');
                    isIndirizzoValido = true;
                  },
                  onSuggestionClicked: (Prediction prediction) =>
                      _indirizzoController.text = prediction.description!,
                  minInputLength: 3,
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
              onPressed: (){
                if(_indirizzoController.text.isEmpty || !isIndirizzoValido){
                  showDialog(
                    context: context, 
                    builder: (BuildContext context) => MyInfoDialog(title: "Errore", bodyText: "Inserire un indirizzo valido e riprovare.", buttonText: "Ok", onPressed: (){Navigator.pop(context);})
                  );
                } else {
                  FiltriRicerca filtriRicerca = setCriteriRicerca();
                  Navigator.pushNamed(
                    context, 
                    '/ControllorePagine2', 
                    arguments: filtriRicerca
                  );
                }
              },
              color: context.tertiary
            ),

            myCronologia(context, context.outline)

          ],
        )
      ),
    );
  }

  FiltriRicerca setCriteriRicerca() {
    FiltriRicerca filtriRicerca = FiltriRicerca(
      latitudine: latitudine ?? 0.0, 
      longitudine: longitudine ?? 0.0, 
      tipoAnnuncio: selectedCompraAffitta.first ? "VENDITA" : "AFFITTO",
      raggioRicerca: raggioRicerca,
      prezzoMin : _prezzoMinController.text.isNotEmpty ? _prezzoMinController.text : null,
      prezzoMax : _prezzoMaxController.text.isNotEmpty ? _prezzoMaxController.text : null,
      superficieMin : _superficieMinController.text.isNotEmpty ? _superficieMinController.text : null,
      superficieMax : _superficieMaxController.text.isNotEmpty ? _superficieMaxController.text : null,
      nStanzeMin : _numeroStanzeMinController.text.isNotEmpty ?  _numeroStanzeMinController.text : null,
      nStanzeMax : _numeroStanzeMaxController.text.isNotEmpty ? _numeroStanzeMaxController.text : null,
      garage : _isGarageSelected ? _isGarageSelected : null,
      ascensore : _isAscensoreSelected ? _isAscensoreSelected : null,
      arredato : _isArredatoSelected ? _isArredatoSelected : null,
      giardino : _isGiardinoSelected ? _isGiardinoSelected : null,
      piscina : _isPiscinaSelected ? _isPiscinaSelected : null,
      balcone : _isBalconeSelected ? _isBalconeSelected : null,
      vicinoScuole : _isVicinoScuoleSelected ? _isVicinoScuoleSelected : null,
      vicinoParchi : _isVicinoParchiSelected ? _isVicinoParchiSelected : null,
      vicinoMezzi : _isVicinoMezziPubbliciSelected ? _isVicinoMezziPubbliciSelected : null,
      piano : sceltaPiano == "Tutti" ? null : sceltaPiano,
      classeEnergetica : sceltaClasseEnergetica == "Tutte" ? null :  sceltaClasseEnergetica,
    );
    return filtriRicerca;
  }

  Visibility myCronologia(BuildContext context, Color colorePulsanti) {
    return Visibility(
      visible: !_ricercaAvanzataVisibile, 
      child: Column(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height/15,
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: MediaQuery.of(context).size.width/9,),
              Icon(Icons.history, color: colorePulsanti,),
              Text('Ultime visite', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorePulsanti),),
            ],
          ),
          // myCarouselSlider(context),
        ],
      )
    );
  }

  // CarouselSlider myCarouselSlider(BuildContext context) {
  //   return CarouselSlider(
  //     items: listaCase.asMap().entries.map((entry) {
  //       int indice = entry.key;
  //       Map<String, dynamic> indiceCasaCorrente = entry.value;
  //       double scaleFactor = indice == _currentSliderIndex ? 1.0 : 0.7;
  //       return GestureDetector(
  //         onTap: (){
  //           Navigator.push(context, MaterialPageRoute(builder: (context) => ClienteAnnuncioPage(casaSelezionata: indiceCasaCorrente)));
  //         },
  //         child: Container(
  //           width: MediaQuery.of(context).size.width,
  //           margin: EdgeInsets.symmetric(horizontal: 5),
  //           decoration: BoxDecoration(
  //             color: context.primaryContainer, 
  //             borderRadius: BorderRadius.circular(10),
  //             shape: BoxShape.rectangle,
  //           ),
  //           child: Column(
  //             children: [
  //               ClipRRect(
  //                 borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
  //                 child: SizedBox(
  //                   child: Image.asset(indiceCasaCorrente['image1']))),
  //               Row(
  //                 children: [
  //                   Expanded(child: Image.asset(indiceCasaCorrente['image2'])),
  //                   Expanded(child: Image.asset(indiceCasaCorrente['image3'])),
  //                 ],
  //               ),
  //               SizedBox(
  //                 height: scaleFactor * MediaQuery.of(context).size.height/50,
  //               ),
  //               Row(
  //                 children: [
  //                   SizedBox(width: MediaQuery.of(context).size.width/45,),
  //                   SizedBox(width: MediaQuery.of(context).size.width/45,),
  //                   Text(indiceCasaCorrente['prezzo'], style: TextStyle(fontSize: scaleFactor * 20, fontWeight: FontWeight.bold, color: context.outline),),
  //                   Text(" EUR", style: TextStyle(fontSize: scaleFactor * 20, fontWeight: FontWeight.bold, color: context.outline),),
  //                 ],
  //               ),
  //               Row(
  //                 children: [
  //                   SizedBox(width: MediaQuery.of(context).size.width/45,),
  //                   Icon(Icons.location_on, size: scaleFactor * 22, color: context.outline,),
  //                   SizedBox(width: MediaQuery.of(context).size.width/45,),
  //                   Text(indiceCasaCorrente['indirizzo'], style: TextStyle(fontSize: scaleFactor * 20, fontWeight: FontWeight.normal, color: context.outline)),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     }).toList(),
  //     options: CarouselOptions(
  //       viewportFraction: 0.8,
  //       height: 360,
  //       enlargeCenterPage: true,
  //       onPageChanged: (indiceCasaCorrente, reason) {
  //         setState(() {
  //           _currentSliderIndex = indiceCasaCorrente;
  //         });
  //       }
  //     ));
  // }

  Visibility myParametriRicercaAvanzata(Color colorePulsanti, BuildContext context) {
    return Visibility(
            visible: _ricercaAvanzataVisibile,
            child: Container(
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
                        onChanged: (value) {
                          setState(() {
                            raggioRicerca = value; // Aggiorna lo stato con il nuovo valore
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