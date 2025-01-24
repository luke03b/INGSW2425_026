import 'package:carousel_slider/carousel_slider.dart';
import 'package:domus_app/pages/agente_annuncio_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AgentePrenotazioniPage extends StatefulWidget {
  const AgentePrenotazioniPage({super.key});

  @override
  State<AgentePrenotazioniPage> createState() => _AgentePrenotazioniPageState();
}

class _AgentePrenotazioniPageState extends State<AgentePrenotazioniPage> {

  int _currentSliderIndex = 0;

  final List<Map<String, dynamic>> listaPrenotazioni = [
    {
      'fascia_oraria': '8:30',
      'data_prenotazione' : '13-01-2025',
      'data_richiesta_prenotazione' : '31-01-2025',
      'stato_prenotazione' : 'Accettata',
      'nome_prenotante' : 'Giuseppe',
      'cognome_prenotante' : 'De Santis',
      'email_prenotante' : 'giuseppe.desantis@icloud.com',
    },
    {
      'fascia_oraria': '8:30',
      'data_prenotazione' : '5-01-2025',
      'data_richiesta_prenotazione' : '7-02-2025',
      'stato_prenotazione' : 'Rifiutata',
      'nome_prenotante' : 'Massimiliano',
      'cognome_prenotante' : 'Centonze',
      'email_prenotante' : 'massimiliano.centonze@icloud.com',
    },
    {
      'fascia_oraria': '8:30',
      'data_prenotazione' : '5-12-2024',
      'data_richiesta_prenotazione' : '1-04-2025',
      'stato_prenotazione' : 'In Attesa',
      'nome_prenotante' : 'Paolo',
      'cognome_prenotante' : 'Buonomo',
      'email_prenotante' : 'paolo.buonomo@icloud.com',
    },

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Prenotazioni ricevute", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 5,
        shadowColor: Colors.black,
      ),
      body: myCarouselSlider(context));
  }

  CarouselSlider myCarouselSlider(BuildContext context) {

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

    return CarouselSlider(
      items: listaPrenotazioni.asMap().entries.map((entry) {
        int indice = entry.key;
        Map<String, dynamic> indiceCasaCorrente = entry.value;
        double scaleFactor = indice == _currentSliderIndex ? 1.0 : 1.0;
        return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AgenteAnnuncioPage(casaSelezionata: indiceCasaCorrente)));
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
                SizedBox(height: scaleFactor * MediaQuery.of(context).size.height/50,),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Text("Data prenotazione: ", style: TextStyle(fontSize: scaleFactor * 22, fontWeight: FontWeight.bold, color: coloreScritte)),
                    Text(indiceCasaCorrente['data_richiesta_prenotazione'], style: TextStyle(fontSize: scaleFactor * 22, fontWeight: FontWeight.bold, color: coloreScritte)),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Text("Richiesta effettuata in data: ", style: TextStyle(fontSize: scaleFactor * 17, fontWeight: FontWeight.bold, color: coloreScritte)),
                    Text(indiceCasaCorrente['data_prenotazione'], style: TextStyle(fontSize: scaleFactor * 17, fontWeight: FontWeight.bold, color: coloreScritte)),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Text("Nome: ", style: TextStyle(fontSize: scaleFactor * 18, fontWeight: FontWeight.bold, color: coloreScritte)),
                    Text(indiceCasaCorrente['nome_prenotante'], style: TextStyle(fontSize: scaleFactor * 18, fontWeight: FontWeight.normal, color: coloreScritte)),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Text("Cognome: ", style: TextStyle(fontSize: scaleFactor * 18, fontWeight: FontWeight.bold, color: coloreScritte)),
                    Text(indiceCasaCorrente['cognome_prenotante'], style: TextStyle(fontSize: scaleFactor * 18, fontWeight: FontWeight.normal, color: coloreScritte)),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Text("Email: ", style: TextStyle(fontSize: scaleFactor * 18, fontWeight: FontWeight.bold, color: coloreScritte)),
                    Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(indiceCasaCorrente['email_prenotante'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Theme.of(context).colorScheme.outline),))),
                      ),
                  ],
                ),
                SizedBox(height: scaleFactor * MediaQuery.of(context).size.height/75,),
              ],
            ),
          ),
        );
      }).toList(),
      options: CarouselOptions(
        enableInfiniteScroll: false,
        viewportFraction: 0.25,
        height: 755,
        enlargeCenterPage: false,
        scrollDirection: Axis.vertical,
        onPageChanged: (indiceCasaCorrente, reason) {
          setState(() {
            _currentSliderIndex = indiceCasaCorrente;
          });
        }
      ));
  }
}