import 'package:carousel_slider/carousel_slider.dart';
import 'package:domus_app/pages/agente_pages/agente_annuncio_page.dart';
import 'package:domus_app/utils/my_buttons_widgets.dart';
import 'package:domus_app/utils/my_pop_up_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AgentePrenotazioniPage extends StatefulWidget {
  const AgentePrenotazioniPage({super.key});

  @override
  State<AgentePrenotazioniPage> createState() => _AgentePrenotazioniPageState();
}

class _AgentePrenotazioniPageState extends State<AgentePrenotazioniPage> {
  final double GRANDEZZA_SCRITTE_GRANDI = 22;
  final double GRANDEZZA_SCRITTE_PICCOLE = 18;
  int _currentSliderIndex = 0;

  final List<Map<String, String>> listaPrenotazioni = [
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
      'fascia_oraria': '18:30',
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
    {
      'fascia_oraria': '12:30',
      'data_prenotazione' : '5-12-2024',
      'data_richiesta_prenotazione' : '1-04-2025',
      'stato_prenotazione' : 'In Attesa',
      'nome_prenotante' : 'Paolo',
      'cognome_prenotante' : 'De Santis',
      'email_prenotante' : 'paolo.desantis@icloud.com',
    },
    {
      'fascia_oraria': '12:30',
      'data_prenotazione' : '5-12-2024',
      'data_richiesta_prenotazione' : '1-04-2025',
      'stato_prenotazione' : 'In Attesa',
      'nome_prenotante' : 'Massimiliano',
      'cognome_prenotante' : 'Buonomo',
      'email_prenotante' : 'massimiliano.buonomo@cloud.com',
    },
    {
      'fascia_oraria': '12:30',
      'data_prenotazione' : '5-12-2024',
      'data_richiesta_prenotazione' : '1-04-2025',
      'stato_prenotazione' : 'In Attesa',
      'nome_prenotante' : 'Alessio',
      'cognome_prenotante' : 'De Santis',
      'email_prenotante' : 'alessio.desantis@icloud.com',
    },
    {
      'fascia_oraria': '12:30',
      'data_prenotazione' : '5-12-2024',
      'data_richiesta_prenotazione' : '1-04-2025',
      'stato_prenotazione' : 'In Attesa',
      'nome_prenotante' : 'Luca',
      'cognome_prenotante' : 'Centonze',
      'email_prenotante' : 'luca.centonze@icloud.com',
    },
    {
      'fascia_oraria': '12:30 - 14',
      'data_prenotazione' : '5-12-2024',
      'data_richiesta_prenotazione' : '1-04-2025',
      'stato_prenotazione' : 'In Attesa',
      'nome_prenotante' : 'Antonio',
      'cognome_prenotante' : 'Buonomo',
      'email_prenotante' : 'antonio.buonomo@icloud.com',
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
        automaticallyImplyLeading: true,
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

    return CarouselSlider(
      items: listaPrenotazioni.asMap().entries.map((entry) {
        int indice = entry.key;
        Map<String, dynamic> indicePrenotazioneCorrente = entry.value;
        double scaleFactor = indice == _currentSliderIndex ? 1.0 : 1.0;
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(5),
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
                  Text("Data prenotazione: ", style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_GRANDI, fontWeight: FontWeight.bold, color: coloreScritte)),
                  Text(indicePrenotazioneCorrente['data_richiesta_prenotazione'], style: TextStyle(fontSize: scaleFactor * 22, fontWeight: FontWeight.bold, color: coloreScritte)),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  Text("Fascia oraria: ", style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.bold, color: coloreScritte)),
                  Text(indicePrenotazioneCorrente['fascia_oraria'], style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: coloreScritte)),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  Text("Richiesta effettuata in data: ", style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.bold, color: coloreScritte)),
                  Text(indicePrenotazioneCorrente['data_prenotazione'], style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.bold, color: coloreScritte)),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  Text("Nome: ", style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.bold, color: coloreScritte)),
                  Text(indicePrenotazioneCorrente['nome_prenotante'], style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: coloreScritte)),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  Text("Cognome: ", style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.bold, color: coloreScritte)),
                  Text(indicePrenotazioneCorrente['cognome_prenotante'], style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: coloreScritte)),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  Text("Email: ", style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.bold, color: coloreScritte)),
                  Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(indicePrenotazioneCorrente['email_prenotante'], style: TextStyle(fontSize: GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: Theme.of(context).colorScheme.outline),))),
                    ),
                ],
              ),
              SizedBox(height: scaleFactor * MediaQuery.of(context).size.height/130,),
              Row(
                children: [
                  SizedBox(width: scaleFactor * MediaQuery.of(context).size.height/50,),
                  Expanded(
                    child: MyElevatedButtonRectWidget(
                            text: "Accetta",
                            onPressed: (){
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) => MyOptionsDialog(
                                                                    title: "Conferma prenotazione",
                                                                    bodyText: "Sei sicuro di voler accettare la prenotazione?",
                                                                    leftButtonText: "Si",
                                                                    leftButtonColor: Theme.of(context).colorScheme.tertiary,
                                                                    rightButtonText: "No",
                                                                    rightButtonColor: Theme.of(context).colorScheme.secondary,
                                                                    onPressLeftButton: (){debugPrint("Prenotazione accettata");},
                                                                    onPressRightButton: (){Navigator.pop(context);}
                                                                  )
                                );
                            },
                            color: Theme.of(context).colorScheme.primary
                          )
                  ),
                  SizedBox(width: scaleFactor * MediaQuery.of(context).size.height/50,),
                  Expanded(
                    child: MyElevatedButtonRectWidget(
                            text: "Rifiuta",
                            onPressed: (){
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) => MyOptionsDialog(
                                                                    title: "Rifiuta prenotazione",
                                                                    bodyText: "Sei sicuro di voler rifiutare la prenotazione?",
                                                                    leftButtonText: "Si",
                                                                    leftButtonColor: Theme.of(context).colorScheme.tertiary,
                                                                    rightButtonText: "No",
                                                                    rightButtonColor: Theme.of(context).colorScheme.secondary,
                                                                    onPressLeftButton: (){debugPrint("Prenotazione accettata");},
                                                                    onPressRightButton: (){Navigator.pop(context);}
                                                                  )
                                );
                            },
                            color: Theme.of(context).colorScheme.primary)),
                  SizedBox(width: scaleFactor * MediaQuery.of(context).size.height/50,),
              ],),
              SizedBox(height: scaleFactor * MediaQuery.of(context).size.height/75,),
            ],
          ),
        );
      }).toList(),
      options: CarouselOptions(
        initialPage: 1,
        enableInfiniteScroll: false,
        viewportFraction: 0.32,
        height: 850,
        enlargeCenterPage: false,
        scrollDirection: Axis.vertical,
        onPageChanged: (indicePrenotazioneCorrente, reason) {
          setState(() {
            _currentSliderIndex = indicePrenotazioneCorrente;
          });
        }
      )
    );
  }
}