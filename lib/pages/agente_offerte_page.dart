import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:domus_app/pages/agente_annuncio_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AgenteOffertePage extends StatefulWidget {
  const AgenteOffertePage({super.key});

  @override
  State<AgenteOffertePage> createState() => _AgenteOffertePageState();
}

class _AgenteOffertePageState extends State<AgenteOffertePage> {
  int _currentSliderIndex = 0;
  static const double GRANDEZZA_SCRITTE = 23;
  static const double GRANDEZZA_ICONE = 25;
  static const double GRANDEZZA_SCRITTE_PICCOLE = 18;
  static const double GRANDEZZA_ICONE_PICCOLE = 20;

  final List<Map<String, dynamic>> listaCase = [
    {
      'image1': 'lib/assets/casa1_1_placeholder.png',
      'image2' : 'lib/assets/casa1_2_placeholder.png',
      'image3' : 'lib/assets/casa1_3_placeholder.png',
      'prezzo': '275.000',
      'indirizzo': 'Via Dalmazia 13,\nCavalleggeri 80124 (NA)',
      'superficie': '100 mq',
      'numero_stanze': '6',
      'data_offerta': '13-01-2025',
      'valore_offerta' : '260.000',
      'nome_offerente' : 'Paolo',
      'cognome_offerente' : 'Centonze',
      'mail_offerente' : 'paolo.centonze@icloud.com',
      'stato_offerta' : 'In Attesa',
    },
    {
      'image1': 'lib/assets/casa2_1_placeholder.png',
      'image2' : 'lib/assets/casa2_2_placeholder.png',
      'image3' : 'lib/assets/casa2_3_placeholder.png',
      'prezzo': '300.000',
      'indirizzo': 'Via Dalmazia 14,\nCavalleggeri 80124 (NA)',
      'superficie': '120 mq',
      'numero_stanze': '7',
      'data_offerta': '5-01-2025',
      'valore_offerta' : '280.000',
      'nome_offerente' : 'Marco',
      'cognome_offerente' : 'Lombari',
      'mail_offerente' : 'marcolombari65@gmail.com',
      'stato_offerta' : 'In Attesa',
    },
    {
      'image1': 'lib/assets/casa3_1_placeholder.png',
      'image2' : 'lib/assets/casa3_2_placeholder.png',
      'image3' : 'lib/assets/casa3_3_placeholder.png',
      'prezzo': '250.000',
      'indirizzo': 'Via Dalmazia 10,\nCavalleggeri 80124 (NA)',
      'superficie': '80 mq',
      'numero_stanze': '5',
      'data_offerta': '25-12-2024',
      'valore_offerta' : '225.000',
      'nome_offerente' : 'Massimiliano',
      'cognome_offerente' : 'De Santis',
      'mail_offerente' : 'madmax@gmail.com',
      'stato_offerta' : 'In Attesa',
    },

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Offerte ricevute", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 5,
        shadowColor: Colors.black,
      ),
      body: myCarouselSlider(context));
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
        'data_offerta': '13-01-2025',
        'valore_offerta' : '260.000',
        'nome_offerente' : 'Paolo',
        'cognome_offerente' : 'Centonze',
        'mail_offerente' : 'paolo.centonze@icloud.com',
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
        'data_offerta': '13-01-2025',
        'valore_offerta' : '260.000',
        'nome_offerente' : 'Paolo',
        'cognome_offerente' : 'Centonze',
        'mail_offerente' : 'paolo.centonze@icloud.com',
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
                    Icon(Icons.euro, size: scaleFactor * GRANDEZZA_ICONE, color: coloreScritte,),
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Text(casaCorrente['prezzo'], style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE, fontWeight: FontWeight.bold, color: coloreScritte)),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Icon(Icons.location_on, size: scaleFactor * GRANDEZZA_ICONE, color: coloreScritte,),
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Text(casaCorrente['indirizzo'], style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE, fontWeight: FontWeight.bold, color: coloreScritte)),
                  ],
                ),

                Divider(height: 15, thickness: 1, indent: 0, endIndent: 0, color: Colors.grey),

                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        Icon(FontAwesomeIcons.arrowsUpDownLeftRight, size: scaleFactor * GRANDEZZA_ICONE_PICCOLE, color: coloreScritte,),
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        Text(casaCorrente['superficie'], style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.bold, color: coloreScritte)),
                      ],
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        Icon(FontAwesomeIcons.stairs, size: scaleFactor * GRANDEZZA_ICONE_PICCOLE, color: coloreScritte,),
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        Text(casaCorrente['piano'], style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.bold, color: coloreScritte)), 
                      ],
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        Icon(FontAwesomeIcons.doorClosed, size: scaleFactor * GRANDEZZA_ICONE_PICCOLE, color: coloreScritte,),
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        Text(casaCorrente['numero_stanze'], style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.bold, color: coloreScritte)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
      options: CarouselOptions(
        enableInfiniteScroll: false,
        viewportFraction: 0.71,
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