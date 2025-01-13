import 'package:carousel_slider/carousel_slider.dart';
import 'package:domus_app/pages/annuncio_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RisultatiCercaPage extends StatefulWidget {
  const RisultatiCercaPage({super.key});

  @override
  State<RisultatiCercaPage> createState() => _RisultatiCercaPageState();
}

class _RisultatiCercaPageState extends State<RisultatiCercaPage> {
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
    },

  ];

  @override
  Widget build(BuildContext context) {
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
      body: myCarouselSlider(context));
  }

  GestureDetector myCarouselSlider(BuildContext context) {

    Color coloreScritte = Theme.of(context).colorScheme.outline;

    Color selettoreColoreStatoOfferta(String statoOfferta) {
      if(statoOfferta == "Accettata") {
        return Colors.green;
      } else if(statoOfferta == "Rifiutata") {
        return Theme.of(context).colorScheme.error;
      } else if(statoOfferta == "In Attesa") {
        return Colors.grey;
      } else if(statoOfferta == "Controproposta") {
        return Theme.of(context).colorScheme.tertiary;
      }
      return Theme.of(context).colorScheme.outline;
    }

    return GestureDetector(
      onTap: (){},
      child: CarouselSlider(
        items: listaCase.asMap().entries.map((entry) {
          int indice = entry.key;
          Map<String, dynamic> casaCorrente = entry.value;
          double scaleFactor = indice == _currentSliderIndex ? 1.0 : 0.7;
          return GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => AnnuncioPage(casaSelezionata: casaCorrente)));
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
                      Icon(Icons.euro, size: scaleFactor * 32, color: coloreScritte,),
                      SizedBox(width: MediaQuery.of(context).size.width/45,),
                      Text(casaCorrente['prezzo'], style: TextStyle(fontSize: scaleFactor * 30, fontWeight: FontWeight.bold, color: coloreScritte)),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width/45,),
                      Icon(Icons.location_on, size: scaleFactor * 25, color: coloreScritte,),
                      SizedBox(width: MediaQuery.of(context).size.width/45,),
                      Text(casaCorrente['indirizzo'], style: TextStyle(fontSize: scaleFactor * 23, fontWeight: FontWeight.bold, color: coloreScritte)),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width/45,),
                      Icon(FontAwesomeIcons.arrowsUpDownLeftRight, size: scaleFactor * 22, color: coloreScritte,),
                      SizedBox(width: MediaQuery.of(context).size.width/45,),
                      Text(casaCorrente['superficie'], style: TextStyle(fontSize: scaleFactor * 20, fontWeight: FontWeight.bold, color: coloreScritte)),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width/45,),
                      Icon(FontAwesomeIcons.stairs, size: scaleFactor * 22, color: coloreScritte,),
                      SizedBox(width: MediaQuery.of(context).size.width/45,),
                      Text(casaCorrente['piano'], style: TextStyle(fontSize: scaleFactor * 20, fontWeight: FontWeight.bold, color: coloreScritte)), 
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width/45,),
                      Icon(Icons.weekend, size: scaleFactor * 22, color: coloreScritte,),
                      SizedBox(width: MediaQuery.of(context).size.width/45,),
                      Text(casaCorrente['numero_stanze'], style: TextStyle(fontSize: scaleFactor * 20, fontWeight: FontWeight.bold, color: coloreScritte)),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width/45,),
                      Icon(FontAwesomeIcons.chair, size: scaleFactor * 22, color: coloreScritte,),
                      SizedBox(width: MediaQuery.of(context).size.width/45,),
                      Text(casaCorrente['arredato'], style: TextStyle(fontSize: scaleFactor * 20, fontWeight: FontWeight.bold, color: coloreScritte)),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
        options: CarouselOptions(
          enableInfiniteScroll: false,
          viewportFraction: 0.75,
          height: 750,
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