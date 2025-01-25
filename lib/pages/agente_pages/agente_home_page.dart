import 'package:carousel_slider/carousel_slider.dart';
import 'package:domus_app/pages/agente_pages/agente_offerte_page.dart';
import 'package:domus_app/pages/agente_pages/agente_prenotazioni_page.dart';

import 'package:domus_app/pages/cliente_pages/cliente_annuncio_page.dart';
import 'package:domus_app/pages/agente_pages/agente_annuncio_page.dart';
import 'package:domus_app/utils/my_buttons_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AgenteHomePage extends StatefulWidget {
  const AgenteHomePage({super.key});

  @override
  State<AgenteHomePage> createState() => _AgenteHomePageState();
}

class _AgenteHomePageState extends State<AgenteHomePage> {
  static const double GRANDEZZA_SCRITTE = 23;
  static const double GRANDEZZA_ICONE = 25;
  static const double GRANDEZZA_SCRITTE_PICCOLE = 18;
  static const double GRANDEZZA_ICONE_PICCOLE = 20;
  int _currentSliderIndex = 0;
  List<bool> selectedOffertePrenotazioni = <bool>[false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.surface,
        ),
        title: Text("Le mie inserzioni", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 5,
        shadowColor: Colors.black,
      ),
      body: Stack(
        children: [
          myCarouselSlider(context),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 63),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 10,),
                    Icon(Icons.filter_alt_outlined, color: Theme.of(context).colorScheme.primary,),
                    Text("Filtri", style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(width: 10,),
                    ToggleButtons(
                      borderRadius: BorderRadius.circular(100),
                      isSelected: selectedOffertePrenotazioni,
                      onPressed: (int index){
                        setState(() {
                          selectedOffertePrenotazioni[index] = !selectedOffertePrenotazioni[index];
                        });
                      },
                      children: [
                        Row(
                          children: [
                            Icon(selectedOffertePrenotazioni[0] ? Icons.radio_button_on : Icons.radio_button_off, color: Theme.of(context).colorScheme.primary, size: 18,),
                            SizedBox(width: 6,),
                            Text("Offerte"),
                            SizedBox(width: 10,)
                          ],
                        ),
                        Row(
                          children: [
                            Icon(selectedOffertePrenotazioni[1] ? Icons.radio_button_on : Icons.radio_button_off, color: Theme.of(context).colorScheme.primary, size: 18,),
                            SizedBox(width: 6,),
                            Text("Prenotazioni"),
                            SizedBox(width: 15,)
                          ],
                        ),
                      ]),
                  ],
                ),
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
              Expanded(child: MyAddButtonWidget(onPressed: (){}, color: Theme.of(context).colorScheme.primary)),
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
    Color coloreScritte = Theme.of(context).colorScheme.outline;

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
        'data_offerta': '13-01-2025',
        'valore_offerta' : '260.000',
        'nome_offerente' : 'Paolo',
        'cognome_offerente' : 'Centonze',
        'mail_offerente' : 'paolo.centonze@icloud.com',
        'stato_offerta' : 'In Attesa',
        'valore_contropoposta' : '',
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
        'data_offerta': '5-01-2025',
        'valore_offerta' : '280.000',
        'nome_offerente' : 'Marco',
        'cognome_offerente' : 'Lombari',
        'mail_offerente' : 'marcolombari65@gmail.com',
        'stato_offerta' : 'In Attesa',
        'valore_contropoposta' : '',
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
        'data_offerta': '25-12-2024',
        'valore_offerta' : '225.000',
        'nome_offerente' : 'Massimiliano',
        'cognome_offerente' : 'De Santis',
        'mail_offerente' : 'madmax@gmail.com',
        'stato_offerta' : 'In Attesa',
        'valore_contropoposta' : '',
      },
    ];
    
    return CarouselSlider(
      items: listaCase.asMap().entries.map((entry) {
        int indice = entry.key;
        Map<String, dynamic> casaCorrente = entry.value;
        double scaleFactor = indice == _currentSliderIndex ? 1.0 : 1.0;
        return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AgenteAnnuncioPage(casaSelezionata: casaCorrente)));
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: Colors.white, 
              borderRadius: BorderRadius.circular(10),
              shape: BoxShape.rectangle,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 15,
                offset: Offset(0, 10),)],
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                  child: SizedBox(
                    child: Image.asset(casaCorrente['image1']))),
                Row(
                  children: [
                    Expanded(child: Image.asset(casaCorrente['image2'])),
                    Expanded(child: Image.asset(casaCorrente['image3'])),
                  ],
                ),
                SizedBox(
                  height: scaleFactor * MediaQuery.of(context).size.height/50,
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Text(casaCorrente['prezzo'], style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE, fontWeight: FontWeight.bold, color: coloreScritte)),
                    Text(" EUR", style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE, fontWeight: FontWeight.bold, color: coloreScritte)),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Icon(Icons.location_on, size: scaleFactor * GRANDEZZA_ICONE, color: coloreScritte,),
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Text(casaCorrente['indirizzo'], style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: coloreScritte)),
                  ],
                ),
              ],
            ),
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