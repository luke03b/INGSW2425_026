import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:domus_app/utils/my_buttons_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AgenteAnnuncioPageGenerale extends StatefulWidget {
  final Map<String, dynamic> casaSelezionata;
  final bool isOffertaManualeButtonVisible;
  final bool areOpzioniOfferteVisible;
  final bool areOpzioniClienteVisible;
  

  const AgenteAnnuncioPageGenerale({super.key, required this.casaSelezionata, required this.isOffertaManualeButtonVisible, required this.areOpzioniOfferteVisible, required this.areOpzioniClienteVisible});

  @override
  State<AgenteAnnuncioPageGenerale> createState() => _AgenteAnnuncioPageGeneraleState();
}

class _AgenteAnnuncioPageGeneraleState extends State<AgenteAnnuncioPageGenerale> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Color coloriPulsanti = Theme.of(context).colorScheme.outline;

    final List<Widget> listaImmagini = [
      Image.asset(widget.casaSelezionata['image1']),
      Image.asset(widget.casaSelezionata['image2']),
      Image.asset(widget.casaSelezionata['image3']),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.surface,
        ),
        title: Text("House Hunters", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 5,
        shadowColor: Colors.black,
      ),
      body: Stack(
        children:[ SingleChildScrollView(
          child: Column(
            children: [
              Card(
                color: Colors.white,
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
                        activeDotColor: Theme.of(context).colorScheme.primary
                      )
                    ),
                    SizedBox(height: 10,)
                  ],
                ),
              ),
              Card(
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 10.0),
                        Icon(Icons.euro, size: 30, color: Theme.of(context).colorScheme.outline,),
                        Text(widget.casaSelezionata['prezzo'], style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: coloriPulsanti),),
                      ],
                    ),
        
        
                    Row(
                      children: [
                        SizedBox(width: 10.0),
                        Text(widget.casaSelezionata['indirizzo'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: coloriPulsanti),),
                      ],
                    ),
        
        
                    // Expanded(child: Divider(height: 50, thickness: 2, indent: 20, endIndent: 10, color: Colors.black)),
                    Divider(height: 15, thickness: 1, indent: 0, endIndent: 0, color: Colors.grey),
                    Row(
                      children: [
                        SizedBox(width: 10.0),
                        Text("Offerta ricevuta in data", style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: coloriPulsanti),),
                        SizedBox(width: 10.0),
                        Text(widget.casaSelezionata['data_offerta'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: coloriPulsanti),),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 10.0),
                        Icon(Icons.euro, size: 20, color: Theme.of(context).colorScheme.outline,),
                        Text(widget.casaSelezionata['valore_offerta'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: coloriPulsanti),),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 10.0),
                        Text("Dati Offerente", style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: coloriPulsanti),),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 10.0),
                        Icon(Icons.remove, size: 20,),
                        SizedBox(width: 10.0),
                        Text(widget.casaSelezionata['cognome_offerente'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: coloriPulsanti),),
                        SizedBox(width: 7.0),
                        Text(widget.casaSelezionata['nome_offerente'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: coloriPulsanti),),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 10.0),
                        Icon(Icons.remove, size: 20,),
                        SizedBox(width: 10.0),
                        Text(widget.casaSelezionata['mail_offerente'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: coloriPulsanti),),
                      ],
                    ),

                    Divider(height: 15, thickness: 1, indent: 0, endIndent: 0, color: Colors.grey),
        
                    Row(
                      children: [
                        SizedBox(width: 10.0),
                        Text("Descrizione", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: coloriPulsanti),),
                      ],
                    ),
                    ReadMoreText(
                      widget.casaSelezionata['descrizione'],
                      textAlign: TextAlign.justify,
                      trimCollapsedText: "mostra altro",
                      trimExpandedText: "mostra meno",
                      style: TextStyle(color: coloriPulsanti),
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
                            Icon(FontAwesomeIcons.fileContract, size: 22, color: coloriPulsanti,),
                            SizedBox(width: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Contratto", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: coloriPulsanti),),
                                Text("Vendita", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti),)
                              ],
                            ),
                            ],
                          ),
                          SizedBox(width: 10.0),
                          Row(
                            children: [
                            Icon(FontAwesomeIcons.stairs, size: 22, color: coloriPulsanti,),
                            SizedBox(width: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Piano", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: coloriPulsanti),),
                                Text("Vendita", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti),)
                              ],
                            ),
                            ],
                          ),
                          SizedBox(width: 10.0),
                          Row(
                            children: [
                            Icon(FontAwesomeIcons.doorClosed, size: 22, color: coloriPulsanti,),
                            SizedBox(width: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("N. Stanze", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: coloriPulsanti),),
                                Text("Vendita", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti),)
                              ],
                            ),
                            ],
                          ),
                          SizedBox(width: 10.0),
                          Row(
                            children: [
                            Icon(FontAwesomeIcons.car, size: 22, color: coloriPulsanti,),
                            SizedBox(width: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Garage", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: coloriPulsanti),),
                                Text("Vendita", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti),)
                              ],
                            ),
                            ],
                          ),
                          SizedBox(width: 10.0),
                          Row(
                            children: [
                            Icon(Icons.pool, size: 22, color: coloriPulsanti,),
                            SizedBox(width: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Piscina", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: coloriPulsanti),),
                                Text("Vendita", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti),)
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
                            Icon(Icons.zoom_out_map, size: 22, color: coloriPulsanti,),
                            SizedBox(width: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Superficie", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: coloriPulsanti),),
                                Text("Vendita", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti),)
                              ],
                            ),
                            ],
                          ),
                          SizedBox(width: 10.0),
                          Row(
                            children: [
                            Icon(FontAwesomeIcons.elevator, size: 22, color: coloriPulsanti,),
                            SizedBox(width: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Ascensore", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: coloriPulsanti),),
                                Text("Vendita", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti),)
                              ],
                            ),
                            ],
                          ),
                          SizedBox(width: 10.0),
                          Row(
                            children: [
                            Icon(FontAwesomeIcons.chair, size: 22, color: coloriPulsanti,),
                            SizedBox(width: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Arredato", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: coloriPulsanti),),
                                Text("Vendita", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti),)
                              ],
                            ),
                            ],
                          ),
                          SizedBox(width: 10.0),
                          Row(
                            children: [
                            Icon(Icons.balcony, size: 22, color: coloriPulsanti,),
                            SizedBox(width: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Balcone", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: coloriPulsanti),),
                                Text("Vendita", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti),)
                              ],
                            ),
                            ],
                          ),
                          SizedBox(width: 10.0),
                          Row(
                            children: [
                            Icon(FontAwesomeIcons.leaf, size: 22, color: coloriPulsanti,),
                            SizedBox(width: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("C. Energetica", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: coloriPulsanti),),
                                Text("Vendita", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: coloriPulsanti),)
                              ],
                            ),
                            ],
                          ),
                          ],
                        ),
                      ],
                    ),
                  Divider(height: 15, thickness: 1, indent: 0, endIndent: 0, color: Colors.grey),

                  SizedBox(height: 200,),
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
              Stack(
                children: [
                  Stack(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                        color: Colors.white,
                        child: Column(
                          children: [
                            SizedBox(height: 10,),
                            Row(children: [
                              SizedBox(width: 5,),
                              Visibility(
                                visible: widget.areOpzioniClienteVisible,
                                child: Expanded(child: MyElevatedButtonRectWidget(text: "Offerta", onPressed: (){}, color: Theme.of(context).colorScheme.primary))),
                              SizedBox(width: 5,),
                              Visibility(
                                visible: widget.areOpzioniClienteVisible,
                                child: Expanded(child: MyElevatedButtonRectWidget(text: "Visita", onPressed: (){}, color: Theme.of(context).colorScheme.primary))),
                              SizedBox(width: 5,),
                            ],),
                            SizedBox(height: 10,)
                          ],
                        ),
                      ),
                    ],
                  ),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            SizedBox(width: 5,),
                            Visibility(
                            visible: widget.isOffertaManualeButtonVisible,
                            child: Expanded(child: MyElevatedButtonRectWidget(text: "Aggiungi Offerta Manuale", onPressed: (){}, color: Theme.of(context).colorScheme.primary))),
                            SizedBox(width: 5,),
                          ],
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),
                  ),
                    SizedBox(width: 5,),
              ],),
              Visibility(
                visible: widget.areOpzioniOfferteVisible,
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      Row(children: [
                      SizedBox(width: 5,),
                      Visibility(
                        visible: widget.areOpzioniOfferteVisible,
                        child: Expanded(child: MyElevatedButtonRectWidget(text: "Accetta", onPressed: (){}, color: Theme.of(context).colorScheme.primary))),
                        SizedBox(width: 5,),
                      Visibility(
                        visible: widget.areOpzioniOfferteVisible,
                        child: Expanded(child: MyElevatedButtonRectWidget(text: "Rifiuta", onPressed: (){}, color: Theme.of(context).colorScheme.primary))),
                        SizedBox(width: 5,),
                      ],),
                      SizedBox(height: 10,),
                      Row(children: [
                        SizedBox(width: 5,),
                        Visibility(
                          visible: widget.areOpzioniOfferteVisible,
                          child: Expanded(child: MyElevatedButtonRectWidget(text: "Contro proposta", onPressed: (){}, color: Theme.of(context).colorScheme.primary))),
                        SizedBox(width: 5,),
                      ],),
                      SizedBox(height: 10,)
                    ],
                  ),
                ),
              ),
            ],
          )
        )]
        // Positioned(
        //   bottom: 16,
        //   left: 16,
        //   right: MediaQuery.sizeOf(context).width/1.95,
        //   child: MyElevatedButtonRectWidget(text: "Offerta", onPressed: (){}, color: Theme.of(context).colorScheme.primary)),
        // Positioned(
        //   bottom: 16,
        //   left: MediaQuery.sizeOf(context).width/1.95,
        //   right: 16,
        //   child: MyElevatedButtonWidget(text: "Visita", onPressed: (){}, color: Theme.of(context).colorScheme.primary))
        // ],
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