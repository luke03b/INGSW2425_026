import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:domus_app/back_end_communication/class_services/annuncio_service.dart';
import 'package:domus_app/back_end_communication/dto/annuncio_dto.dart';
import 'package:domus_app/pages/agente_pages/agente_offerte_page.dart';
import 'package:domus_app/pages/agente_pages/agente_visite_page.dart';
import 'package:domus_app/services/formatStrings.dart';
import 'package:domus_app/ui_elements/theme/ui_constants.dart';
import 'package:domus_app/ui_elements/utils/my_ui_messages_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:domus_app/ui_elements/utils/my_buttons_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AgenteAnnuncioPage extends StatefulWidget {
  final String idAnnuncioSelezionato;
  

  const AgenteAnnuncioPage({super.key, required this.idAnnuncioSelezionato});

  @override
  State<AgenteAnnuncioPage> createState() => _AgenteAnnuncioPageState();
}

class _AgenteAnnuncioPageState extends State<AgenteAnnuncioPage> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  AnnuncioDto? annuncioSelezionato;
  bool existsAnnuncio = false;
  bool areDataRetrieved = false;
  bool areServersAvailable = false;

  int _currentIndex = 0;

  Future<void> getAnnuncioById() async {
    try {
      AnnuncioDto data = await AnnuncioService.recuperaAnnuncioById(widget.idAnnuncioSelezionato);
      
      if (mounted) {
        setState(() {
          annuncioSelezionato = data;
          existsAnnuncio = annuncioSelezionato != null;
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
    getAnnuncioById();
  }

  @override
  Widget build(BuildContext context) {
    Color coloriPulsanti = context.outline;

    final List<Widget> listaImmagini = [
      Image.asset('lib/assets/casa3_1_placeholder.png'),
      Image.asset('lib/assets/casa3_1_placeholder.png'),
      Image.asset('lib/assets/casa3_1_placeholder.png'),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: context.onSecondary,
        ),
        title: Text("House Hunters", style: TextStyle(color: context.onSecondary),),
        centerTitle: true,
        backgroundColor: context.primary,
        elevation: 5,
        shadowColor: context.shadow,
      ),
      body: switch ((areDataRetrieved, areServersAvailable, existsAnnuncio)) {
              (false, _, _) => MyUiMessagesWidgets.myTextWithLoading(context, "Sto recuperando l'annuncio, un po' di pazienza"),
              (true, false, _) => MyUiMessagesWidgets.myErrorWithButton(
                context, 
                "Server non raggiungibili. Controlla la tua connessione a internet e riprova", 
                "Riprova", 
                (){
                  setState(() {
                    existsAnnuncio = false;
                    areDataRetrieved = false;
                    areServersAvailable = false;
                  });
                  getAnnuncioById();
                }
              ),
              (true, true, false) => MyUiMessagesWidgets.myText(context, "L'annuncio non esiste..."),
              (true, true, true) => myAnnuncioPage(context, listaImmagini, coloriPulsanti),
            },
    );
  }

  Stack myAnnuncioPage(BuildContext context, List<Widget> listaImmagini, Color coloriPulsanti) {
    return Stack(
      children:[ SingleChildScrollView(
        child: Column(
          children: [
            Card(
              color: context.primaryContainer,
              child: Column(
                children: [
                  Stack(
                    children: [
                      myCarouselSlider(context, listaImmagini),
                      Visibility(
                        visible: annuncioSelezionato!.stato == "CONCLUSO", 
                        child: Positioned(
                          top: 20,
                          left: 20,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              color: context.error,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              annuncioSelezionato!.tipoAnnuncio == "VENDITA" ? "Venduto" : "Affittato",
                              style: TextStyle(
                                color: context.onError,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  AnimatedSmoothIndicator(
                    activeIndex: _currentIndex,
                    count: listaImmagini.length,
                    effect: ScrollingDotsEffect(
                      dotHeight: 8.0,
                      dotWidth: 8.0,
                      activeDotColor: context.onSecondary,
                    ),
                  ),
                  SizedBox(height: 10,)
                ],
              ),
            ),
            Card(
              color: context.primaryContainer,
              child: Column(
                children: [
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      SizedBox(width: 10.0),
                      Text(FormatStrings.trasformareInizialeMaiuscola(annuncioSelezionato!.tipoAnnuncio), style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: coloriPulsanti),),
                    ],
                  ),

                  Row(
                    children: [
                      SizedBox(width: 10.0),
                      Text(FormatStrings.formatNumber(annuncioSelezionato!.prezzo), style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: coloriPulsanti),),
                      Text(" EUR", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: coloriPulsanti),),
                      Visibility(
                          visible: annuncioSelezionato!.tipoAnnuncio == "AFFITTO", 
                          child: Row(
                            children: [
                              SizedBox(width: 3,),
                              Text("/Mese", style: TextStyle(color: context.outline, fontWeight: FontWeight.bold, fontSize: 30),),
                            ],
                          )
                        )
                    ],
                  ),
                  
                  Row(
                    children: [
                      SizedBox(width: 10.0),
                      Expanded(
                        child: AutoSizeText(
                          annuncioSelezionato!.indirizzo,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: context.outline,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          minFontSize: 12,
                        ),
                      ),
                      SizedBox(width: 10.0),
                    ],
                  ),

                  Divider(height: 15, thickness: 1, indent: 0, endIndent: 0, color: Colors.grey),
      
                  Row(
                    children: [
                      SizedBox(width: 10.0),
                      Text("Descrizione", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: coloriPulsanti),),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: ReadMoreText(
                      colorClickableText: context.onSecondary,
                      annuncioSelezionato!.descrizione,
                      textAlign: TextAlign.justify,
                      trimCollapsedText: "    mostra altro",
                      trimExpandedText: "    mostra meno",
                      style: TextStyle(color: coloriPulsanti),
                    ),
                  ),
      
                  Divider(height: 15, thickness: 1, indent: 0, endIndent: 0, color: Colors.grey),
      /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                  Row(
                    children: [
                      SizedBox(width: 10.0),
                      Text("Caratteristiche", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: coloriPulsanti),),
                    ],
                  ),
      
      
                  //colonna di sinistra
                  Row(
                    children: [
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        SizedBox(width: 10.0),
                        Row(
                          children: [
                          Icon(FontAwesomeIcons.stairs, size: 22, color: context.onSecondary,),
                          SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Piano", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: coloriPulsanti),),
                              Text(
                                annuncioSelezionato!.piano == 'INTERMEDIO' ? annuncioSelezionato!.numeroPiano.toString() : FormatStrings.trasformareInizialeMaiuscola(annuncioSelezionato!.piano), 
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti),)
                            ],
                          ),
                          ],
                        ),
                        SizedBox(width: 10.0),
                        Row(
                          children: [
                          Icon(Icons.park, size: 22, color: context.onSecondary,),
                          SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Giardino", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: coloriPulsanti),),
                              Text(annuncioSelezionato!.giardino ? 'Si' : 'No', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti),)
                            ],
                          ),
                          ],
                        ),
                        SizedBox(width: 10.0),
                        Row(
                          children: [
                          Icon(FontAwesomeIcons.doorClosed, size: 22, color: context.onSecondary,),
                          SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("N. Stanze", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: coloriPulsanti),),
                              Text(annuncioSelezionato!.numStanze.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti),)
                            ],
                          ),
                          ],
                        ),
                        SizedBox(width: 10.0),
                        Row(
                          children: [
                          Icon(FontAwesomeIcons.car, size: 22, color: context.onSecondary,),
                          SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Garage", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: coloriPulsanti),),
                              Text(annuncioSelezionato!.garage ? 'Si' : 'No', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti),)
                            ],
                          ),
                          ],
                        ),
                        SizedBox(width: 10.0),
                        Row(
                          children: [
                          Icon(Icons.pool, size: 22, color: context.onSecondary,),
                          SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Piscina", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: coloriPulsanti),),
                              Text(annuncioSelezionato!.piscina ? 'Si' : 'No', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti),)
                            ],
                          ),
                          ],
                        ),
                        ],
                      ),
      
                      SizedBox(width: 90.0,),
      
                      //colonna fascista (destra)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 10.0),
                        Row(
                          children: [
                          Icon(Icons.zoom_out_map, size: 22, color: context.onSecondary,),
                          SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Superficie", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: coloriPulsanti),),
                              Text('${annuncioSelezionato!.superficie} m²', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti),)
                            ],
                          ),
                          ],
                        ),
                        SizedBox(width: 10.0),
                        Row(
                          children: [
                          Icon(FontAwesomeIcons.elevator, size: 22, color: context.onSecondary,),
                          SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Ascensore", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: coloriPulsanti),),
                              Text(annuncioSelezionato!.ascensore ? 'Si' : 'No', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti),)
                            ],
                          ),
                          ],
                        ),
                        SizedBox(width: 10.0),
                        Row(
                          children: [
                          Icon(FontAwesomeIcons.chair, size: 22, color: context.onSecondary,),
                          SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Arredato", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: coloriPulsanti),),
                              Text(annuncioSelezionato!.arredo ? 'Si' : 'No', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti),)
                            ],
                          ),
                          ],
                        ),
                        SizedBox(width: 10.0),
                        Row(
                          children: [
                          Icon(Icons.balcony, size: 22, color: context.onSecondary,),
                          SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Balcone", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: coloriPulsanti),),
                              Text(annuncioSelezionato!.balcone ? 'Si' : 'No', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti),)
                            ],
                          ),
                          ],
                        ),
                        SizedBox(width: 10.0),
                        Row(
                          children: [
                          Icon(FontAwesomeIcons.leaf, size: 22, color: context.onSecondary,),
                          SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("C. Energetica", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: coloriPulsanti),),
                              Text(annuncioSelezionato!.classeEnergetica, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti),)
                            ],
                          ),
                          ],
                        ),
                        ],
                      ),
                    ],
                  ),
                Divider(height: 15, thickness: 1, indent: 0, endIndent: 0, color: Colors.grey),
                Row(
                  children: [
                    SizedBox(width: 10.0),
                    Text("Posizione", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: coloriPulsanti),),
                  ],
                ),
                SizedBox(height: 10,),
                SizedBox(
                  width: MediaQuery.of(context).size.width/1.1,
                  height: 300,
                  child: GoogleMap(
                    gestureRecognizers: Set()..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer())),
                    mapType: MapType.normal,
                    initialCameraPosition:CameraPosition(target: LatLng(annuncioSelezionato!.latitudine, annuncioSelezionato!.longitudine), zoom: 14.4746),
                    onMapCreated: (GoogleMapController controller) {if (!_controller.isCompleted) {_controller.complete(controller);}},
                    markers: {Marker(markerId: MarkerId('Posizione'), position:  LatLng(annuncioSelezionato!.latitudine, annuncioSelezionato!.longitudine),)},),
                ),
                Divider(height: 15, thickness: 1, indent: 0, endIndent: 0, color: Colors.grey),

                Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 10.0),
                        Text("Vicino A", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: coloriPulsanti),),
                      ],
                    ),
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
                                    Icon(FontAwesomeIcons.school, size: 22, color: context.onSecondary,),
                                    SizedBox(height: 22,),
                                    Icon(FontAwesomeIcons.sunPlantWilt, size: 22, color: context.onSecondary,),
                                    SizedBox(height: 22,),
                                    Icon(FontAwesomeIcons.bus, size: 22, color: context.onSecondary,),
                                  ],
                                ),
                
                                SizedBox(width: 30,),
                                
                                //Colonna contenente nomi
                                Column(
                                  children: [
                                    SizedBox(
                                      width: 270,
                                      child: Text("Scuole", style: TextStyle(fontSize: 18.0, color: coloriPulsanti),)
                                    ),
                                    SizedBox(height: 18,),
                                    SizedBox(
                                      width: 270,
                                      child: Text("Parchi pubblici", style: TextStyle(fontSize: 18.0, color: coloriPulsanti))
                                    ),
                                    SizedBox(height: 18,),
                                    SizedBox(
                                      width: 270,
                                      child: Text("Fermate mezzi pubblici", style: TextStyle(fontSize: 18.0, color: coloriPulsanti))
                                    ),
                                  ],
                                ),
                                
                                SizedBox(width: 10,),
                
                                //colonna contenente valori
                                Column(
                                  children: [
                                    Icon(annuncioSelezionato!.vicinoScuole! ? Icons.check :  Icons.close, size: 30, color: annuncioSelezionato!.vicinoScuole! ? Colors.green :  context.error),
                                    SizedBox(height: 22,),
                                    Icon(annuncioSelezionato!.vicinoParchi! ? Icons.check :  Icons.close, size: 30, color: annuncioSelezionato!.vicinoScuole! ? Colors.green :  context.error),
                                    SizedBox(height: 22,),
                                    Icon(annuncioSelezionato!.vicinoTrasporti! ? Icons.check :  Icons.close, size: 30, color: annuncioSelezionato!.vicinoScuole! ? Colors.green :  context.error),                       
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                  ]),
                  ],
                ),

                Divider(height: 15, thickness: 1, indent: 0, endIndent: 0, color: Colors.grey),

                Row(
                    children: [
                      SizedBox(width: 10.0),
                      Text("Inserzionista", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: coloriPulsanti),),
                    ],
                  ),

                Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 10.0),
                        Text("Agenzia immobiliare: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: coloriPulsanti),),
                        Text(annuncioSelezionato!.agente.agenziaImmobiliare!.nome, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti))
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 10.0),
                        Text("Agente immobiliare: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: coloriPulsanti),),
                        Text("${annuncioSelezionato!.agente.nome} ${annuncioSelezionato!.agente.cognome}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti))
                      ],
                    ),
                  ],
                ),

                Divider(height: 15, thickness: 1, indent: 0, endIndent: 0, color: Colors.grey),
                SizedBox(height: 65,)
                ],
              ),
            ),
          ],
        )
      ),
      Positioned(
        bottom: -5,
        left: 0,
        right: 0,
        child:
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            color: context.primaryContainer,
            child: Column(
              children: [
                SizedBox(height: 10,),
                Row(children: [
                SizedBox(width: 5,),
                Expanded(
                  child: MyElevatedButtonRectWidget(
                    text: "Offerte",
                    onPressed: () async {
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => AgenteOffertePage(annuncioSelezionato: annuncioSelezionato!,)));
                      setState(() {
                        existsAnnuncio = false;
                        areDataRetrieved = false;
                        areServersAvailable = false;
                      });
                      getAnnuncioById();
                    },
                color: context.onSecondary)),
                SizedBox(width: 5,),
                Expanded(
                  child: MyElevatedButtonRectWidget(
                    text: "Prenotazioni",
                    onPressed: () async {
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => AgentePrenotazioniPage(annuncioSelezionato: annuncioSelezionato!)));
                      setState(() {
                        existsAnnuncio = false;
                        areDataRetrieved = false;
                        areServersAvailable = false;
                      });
                      getAnnuncioById();
                    }, 
                color: context.onSecondary)),
                SizedBox(width: 5,),
                ],),
                SizedBox(height: 10,),
              ],
            ),
          ),
      )
    ]);
  }

  CarouselSlider myCarouselSlider(BuildContext context, List<Widget> listaImmagini) {
    return CarouselSlider(
      items: listaImmagini,
      options: CarouselOptions(
        viewportFraction: 0.96,
        height: 220,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        onPageChanged: (index, reason) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}