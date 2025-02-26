import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:domus_app/dto/annuncio_dto.dart';
import 'package:domus_app/pages/cliente_pages/cliente_crea_offerta_page.dart';
import 'package:domus_app/pages/cliente_pages/cliente_crea_prenotazione.dart';
import 'package:domus_app/services/formatStrings.dart';
import 'package:domus_app/theme/ui_constants.dart';
import 'package:domus_app/utils/my_buttons_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClienteAnnuncioPage extends StatefulWidget {
  final AnnuncioDto casaSelezionata;

  const ClienteAnnuncioPage({super.key, required this.casaSelezionata});

  @override
  State<ClienteAnnuncioPage> createState() => _ClienteAnnuncioPageState();
}

class _ClienteAnnuncioPageState extends State<ClienteAnnuncioPage> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    CameraPosition posizioneIniziale = CameraPosition(target: LatLng(widget.casaSelezionata.latitudine, widget.casaSelezionata.longitudine), zoom: 14.4746);

    final List<Widget> listaImmagini = [
      // Image.asset(widget.casaSelezionata['image1']),
      // Image.asset(widget.casaSelezionata['image2']),
      // Image.asset(widget.casaSelezionata['image3']),
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
                        Text(FormatStrings.trasformareInizialeMaiuscola(widget.casaSelezionata.tipoAnnuncio), style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: context.outline),),
                      ],
                    ),

                    Row(
                      children: [
                        SizedBox(width: 10.0),
                        Text(FormatStrings.formatNumber(widget.casaSelezionata.prezzo), style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: context.outline),),
                        Text(" EUR", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: context.outline),),
                      ],
                    ),
        
                    Row(
                      children: [
                        SizedBox(width: 10.0),
                        Text(widget.casaSelezionata.indirizzo, style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: context.outline),),
                      ],
                    ),
        
        
                    // Expanded(child: Divider(height: 50, thickness: 2, indent: 20, endIndent: 10, color: Colors.black)),
                    Divider(height: 15, thickness: 1, indent: 0, endIndent: 0, color: Colors.grey),
        
                    Row(
                      children: [
                        SizedBox(width: 10.0),
                        Text("Descrizione", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: context.outline),),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ReadMoreText(
                        widget.casaSelezionata.descrizione,
                        textAlign: TextAlign.justify,
                        trimCollapsedText: "    mostra altro",
                        trimExpandedText: "    mostra meno",
                        colorClickableText: context.onSecondary,
                        style: TextStyle(color: context.outline),
                      ),
                    ),
        
                    Divider(height: 15, thickness: 1, indent: 0, endIndent: 0, color: Colors.grey),
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    Row(
                      children: [
                        SizedBox(width: 10.0),
                        Text("Caratteristiche", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: context.outline),),
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
                                Text("Piano", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: context.outline),),
                                Text(widget.casaSelezionata.piano == 'INTERMEDIO' ? widget.casaSelezionata.numeroPiano.toString() : FormatStrings.trasformareInizialeMaiuscola(widget.casaSelezionata.piano),
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: context.outline),)
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
                                Text("Giardino", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: context.outline),),
                                Text(widget.casaSelezionata.giardino ? 'Si' : 'No', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: context.outline),)
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
                                Text("N. Stanze", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: context.outline),),
                                Text(widget.casaSelezionata.numStanze.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: context.outline),)
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
                                Text("Garage", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: context.outline),),
                                Text(widget.casaSelezionata.garage ? 'Si' : 'No', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: context.outline),)
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
                                Text("Piscina", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: context.outline),),
                                Text(widget.casaSelezionata.piscina ? 'Si' : 'No', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: context.outline),)
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
                                Text("Superficie", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: context.outline),),
                                Text('${widget.casaSelezionata.superficie} m²', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: context.outline),)
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
                                Text("Ascensore", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: context.outline),),
                                Text(widget.casaSelezionata.ascensore ? 'Si' : 'No', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: context.outline),)
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
                                Text("Arredato", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: context.outline),),
                                Text(widget.casaSelezionata.arredo ? 'Si' : 'No', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: context.outline),)
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
                                Text("Balcone", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: context.outline),),
                                Text(widget.casaSelezionata.balcone ? 'Si' : 'No', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: context.outline),)
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
                                Text("C. Energetica", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: context.outline),),
                                Text(widget.casaSelezionata.classeEnergetica, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: context.outline),)
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
                        Text("Posizione", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: context.outline),),
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
                      markers: {Marker(markerId: MarkerId('Posizione'), position:  LatLng(widget.casaSelezionata.latitudine, widget.casaSelezionata.longitudine),)},),
                  ),

                  Divider(height: 15, thickness: 1, indent: 0, endIndent: 0, color: Colors.grey),

                  Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 10.0),
                          Text("Vicino A", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: context.outline),),
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
                                        child: Text("Scuole", style: TextStyle(fontSize: 18.0, color: context.outline),)
                                      ),
                                      SizedBox(height: 18,),
                                      Container(
                                        width: 270,
                                        child: Text("Parchi pubblici", style: TextStyle(fontSize: 18.0, color: context.outline))
                                      ),
                                      SizedBox(height: 18,),
                                      Container(
                                        width: 270,
                                        child: Text("Fermate mezzi pubblici", style: TextStyle(fontSize: 18.0, color: context.outline))
                                      ),
                                    ],
                                  ),
                                  
                                  SizedBox(width: 10,),
                  
                                  //colonna contenente valori
                                  Column(
                                    children: [
                                      Icon(widget.casaSelezionata.vicinoScuole! ? Icons.check :  Icons.close, size: 30, color: context.outline),
                                      SizedBox(height: 16,),
                                      Icon(widget.casaSelezionata.vicinoParchi! ? Icons.check :  Icons.close, size: 30, color: context.outline),
                                      SizedBox(height: 16,),
                                      Icon(widget.casaSelezionata.vicinoTrasporti! ? Icons.check :  Icons.close, size: 30, color: context.outline),                    
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
                        Text("Inserzionista", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: context.outline),),
                      ],
                    ),

                  // Column(
                  //   children: [
                  //     Row(
                  //       children: [
                  //         SizedBox(width: 10.0),
                  //         Text("Agenzia immobiliare: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: context.outline),),
                  //         Text(widget.casaSelezionata['agenzia'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: context.outline))
                  //       ],
                  //     ),
                  //     Row(
                  //       children: [
                  //         SizedBox(width: 10.0),
                  //         Text("Agente immobiliare: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: context.outline),),
                  //         Text(widget.casaSelezionata['agente'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: context.outline))
                  //       ],
                  //     ),
                  //   ],
                  // ),

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
          child: Stack(
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                color: context.primaryContainer,
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Row(children: [
                    SizedBox(width: 5,),
                    Expanded(child: MyElevatedButtonRectWidget(text: "Offerta", onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ClienteCreaOffertaPage(casaSelezionata: widget.casaSelezionata)));
                    }, color: context.onSecondary)),
                    SizedBox(width: 5,),
                    Expanded(child: MyElevatedButtonRectWidget(text: "Visita", onPressed: (){
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => ClienteCreaPrenotazionePage(casaSelezionata: widget.casaSelezionata)));
                      Navigator.push(context, MaterialPageRoute(builder: (context) => WeatherScreen(latitude: widget.casaSelezionata.latitudine, longitude: widget.casaSelezionata.longitudine,)));
                    }, color: context.onSecondary)),
                    SizedBox(width: 5,),
                    ],),
                    SizedBox(height: 10,)
                  ],
                ),
              ),
            ],
          )
        )]
      )
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