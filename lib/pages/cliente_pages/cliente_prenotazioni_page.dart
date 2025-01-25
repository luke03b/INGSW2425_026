import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ClientePrenotazioniPage extends StatefulWidget {
  const ClientePrenotazioniPage({super.key});

  @override
  State<ClientePrenotazioniPage> createState() => _ClientePrenotazioniPageState();
}

class _ClientePrenotazioniPageState extends State<ClientePrenotazioniPage> {
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
      'data_offerta': '13-01-2025',
      'offerta': '270.000',
      'stato_offerta': 'Accettata',
      'valore_controproposta' : '',
      'data_prenotazione' : '13-01-2025',
      'data_richiesta_prenotazione' : '31-01-2025',
      'stato_prenotazione' : 'Accettata',
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
      'offerta': '250.000',
      'stato_offerta': 'Rifiutata',
      'valore_controproposta' : '',
      'data_prenotazione' : '5-01-2025',
      'data_richiesta_prenotazione' : '7-02-2025',
      'stato_prenotazione' : 'Rifiutata',
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
      'offerta': '245.000',
      'stato_offerta': 'Controproposta',
      'valore_controproposta' : '247.000',
      'data_prenotazione' : '5-12-2024',
      'data_richiesta_prenotazione' : '1-04-2025',
      'stato_prenotazione' : 'In Attesa',
    },

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("House Hunters", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 5,
        shadowColor: Colors.black,
      ),
      body: myCarouselSlider(context));
  }

  GestureDetector myCarouselSlider(BuildContext context) {

    Color coloreScritte = Theme.of(context).colorScheme.outline;

    Color selettoreColoreStatoPrenotazione(String statoPrenotazione) {
      if(statoPrenotazione == "Accettata") {
        return Colors.green;
      } else if(statoPrenotazione == "Rifiutata") {
        return Theme.of(context).colorScheme.error;
      } else if(statoPrenotazione == "In Attesa") {
        return Colors.grey;
      } else if(statoPrenotazione == "Controproposta") {
        return Theme.of(context).colorScheme.tertiary;
      }
      return Theme.of(context).colorScheme.outline;
    }

    return GestureDetector(
      onTap: (){},
      child: CarouselSlider(
        items: listaCase.asMap().entries.map((entry) {
          int indice = entry.key;
          Map<String, dynamic> indiceCasaCorrente = entry.value;
          double scaleFactor = indice == _currentSliderIndex ? 1.0 : 0.7;
          return Container(
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
                    child: Image.asset(indiceCasaCorrente['image1']))),
                Row(
                  children: [
                    Expanded(child: Image.asset(indiceCasaCorrente['image2'])),
                    Expanded(child: Image.asset(indiceCasaCorrente['image3'])),
                  ],
                ),
                SizedBox(
                  height: scaleFactor * MediaQuery.of(context).size.height/50,
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Text("Data prenotazione: ", style: TextStyle(fontSize: scaleFactor * 22, fontWeight: FontWeight.bold, color: coloreScritte)),
                    Text(indiceCasaCorrente['data_richiesta_prenotazione'], style: TextStyle(fontSize: scaleFactor * 22, fontWeight: FontWeight.normal, color: coloreScritte)),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Text(indiceCasaCorrente['stato_prenotazione'], style: TextStyle(fontSize: scaleFactor * 22, fontWeight: FontWeight.bold, color: selettoreColoreStatoPrenotazione(indiceCasaCorrente['stato_prenotazione']))),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Text("Richiesta effettuata in data: ", style: TextStyle(fontSize: scaleFactor * 17, fontWeight: FontWeight.bold, color: coloreScritte)),
                    Text(indiceCasaCorrente['data_prenotazione'], style: TextStyle(fontSize: scaleFactor * 17, fontWeight: FontWeight.normal, color: coloreScritte)),
                  ],
                ),
                SizedBox(
                  height: scaleFactor * MediaQuery.of(context).size.height/75,
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Text(indiceCasaCorrente['prezzo'], style: TextStyle(fontSize: scaleFactor * 20, fontWeight: FontWeight.bold, color: coloreScritte)),
                    Text(" EUR", style: TextStyle(fontSize: scaleFactor * 20, fontWeight: FontWeight.bold, color: coloreScritte)),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Icon(Icons.location_on, size: scaleFactor * 22, color: coloreScritte,),
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Text(indiceCasaCorrente['indirizzo'], style: TextStyle(fontSize: scaleFactor * 20, fontWeight: FontWeight.normal, color: coloreScritte)),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
        options: CarouselOptions(
          enableInfiniteScroll: false,
          viewportFraction: 0.68,
          height: 753,
          enlargeCenterPage: true,
          scrollDirection: Axis.vertical,
          onPageChanged: (indiceCasaCorrente, reason) {
            setState(() {
              _currentSliderIndex = indiceCasaCorrente;
            });
          }
        )),
    );
  }
}