import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:domus_app/back_end_communication/dto/annuncio_dto.dart';
import 'package:domus_app/pages/agente_pages/agente_offerte_page.dart';
import 'package:domus_app/pages/agente_pages/agente_visite_page.dart';
import 'package:domus_app/services/formatStrings.dart';
import 'package:domus_app/ui_elements/theme/ui_constants.dart';
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
  final AnnuncioDto annuncioSelezionato;
  

  const AgenteAnnuncioPage({super.key, required this.annuncioSelezionato});

  @override
  State<AgenteAnnuncioPage> createState() => _AgenteAnnuncioPageState();
}

class _AgenteAnnuncioPageState extends State<AgenteAnnuncioPage> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  // static const CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(40.8189507, 14.1896127),
  //   zoom: 14.4746,
  // );
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Color coloriPulsanti = context.outline;
    CameraPosition posizioneIniziale = CameraPosition(target: LatLng(widget.annuncioSelezionato.latitudine, widget.annuncioSelezionato.longitudine), zoom: 14.4746);

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
      body: Stack(
        children:[ SingleChildScrollView(
          child: Column(
            children: [
              Card(
                color: context.primaryContainer,
                // color: const Color.fromARGB(255, 228, 246, 255),
                child: Column(
                  children: [
                    myCarouselSlider(context, listaImmagini),
                    AnimatedSmoothIndicator(
                      activeIndex: _currentIndex,
                      count: listaImmagini.length,
                      effect: ScrollingDotsEffect(
                        dotHeight: 8.0,
                        dotWidth: 8.0,
                        activeDotColor: context.onSecondary
                      )
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
                        Text(FormatStrings.trasformareInizialeMaiuscola(widget.annuncioSelezionato.tipoAnnuncio), style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: coloriPulsanti),),
                      ],
                    ),

                    Row(
                      children: [
                        SizedBox(width: 10.0),
                        Text(FormatStrings.formatNumber(widget.annuncioSelezionato.prezzo), style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: coloriPulsanti),),
                        Text(" EUR", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: coloriPulsanti),),
                      ],
                    ),
                    
                    Row(
                      children: [
                        SizedBox(width: 10.0),
                        Expanded(
                          child: AutoSizeText(
                            widget.annuncioSelezionato.indirizzo,
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
                        widget.annuncioSelezionato.descrizione,
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
                                  widget.annuncioSelezionato.piano == 'INTERMEDIO' ? widget.annuncioSelezionato.numeroPiano.toString() : FormatStrings.trasformareInizialeMaiuscola(widget.annuncioSelezionato.piano), 
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
                                Text(widget.annuncioSelezionato.giardino ? 'Si' : 'No', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti),)
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
                                Text(widget.annuncioSelezionato.numStanze.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti),)
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
                                Text(widget.annuncioSelezionato.garage ? 'Si' : 'No', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti),)
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
                                Text(widget.annuncioSelezionato.piscina ? 'Si' : 'No', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti),)
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
                                Text('${widget.annuncioSelezionato.superficie} m²', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti),)
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
                                Text(widget.annuncioSelezionato.ascensore ? 'Si' : 'No', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti),)
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
                                Text(widget.annuncioSelezionato.arredo ? 'Si' : 'No', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti),)
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
                                Text(widget.annuncioSelezionato.balcone ? 'Si' : 'No', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti),)
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
                                Text(widget.annuncioSelezionato.classeEnergetica, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti),)
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
                      initialCameraPosition: posizioneIniziale,
                      onMapCreated: (GoogleMapController controller) {_controller.complete(controller);},
                      markers: {Marker(markerId: MarkerId('Posizione'), position:  LatLng(widget.annuncioSelezionato.latitudine, widget.annuncioSelezionato.longitudine),)},),
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
                                      Container(
                                        width: 270,
                                        child: Text("Scuole", style: TextStyle(fontSize: 18.0, color: coloriPulsanti),)
                                      ),
                                      SizedBox(height: 18,),
                                      Container(
                                        width: 270,
                                        child: Text("Parchi pubblici", style: TextStyle(fontSize: 18.0, color: coloriPulsanti))
                                      ),
                                      SizedBox(height: 18,),
                                      Container(
                                        width: 270,
                                        child: Text("Fermate mezzi pubblici", style: TextStyle(fontSize: 18.0, color: coloriPulsanti))
                                      ),
                                    ],
                                  ),
                                  
                                  SizedBox(width: 10,),
                  
                                  //colonna contenente valori
                                  Column(
                                    children: [
                                      Icon(widget.annuncioSelezionato.vicinoScuole! ? Icons.check :  Icons.close, size: 30, color: coloriPulsanti,),
                                      SizedBox(height: 22,),
                                      Icon(widget.annuncioSelezionato.vicinoParchi! ? Icons.check :  Icons.close, size: 30, color: coloriPulsanti),
                                      SizedBox(height: 22,),
                                      Icon(widget.annuncioSelezionato.vicinoTrasporti! ? Icons.check :  Icons.close, size: 30, color: coloriPulsanti),                       
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
                          Text(widget.annuncioSelezionato.agente.agenziaImmobiliare!.nome, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti))
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 10.0),
                          Text("Agente immobiliare: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: coloriPulsanti),),
                          Text("${widget.annuncioSelezionato.agente.nome} ${widget.annuncioSelezionato.agente.cognome}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti))
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
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AgenteOffertePage(annuncioSelezionato: widget.annuncioSelezionato,)));
                      },
                  color: context.onSecondary)),
                  SizedBox(width: 5,),
                  Expanded(
                    child: MyElevatedButtonRectWidget(
                      text: "Prenotazioni",
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AgentePrenotazioniPage()));
                      }, 
                  color: context.onSecondary)),
                  SizedBox(width: 5,),
                  ],),
                  SizedBox(height: 10,),
                ],
              ),
            ),
        )
      ])
    );
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