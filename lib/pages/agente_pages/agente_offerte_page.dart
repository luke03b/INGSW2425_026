import 'package:carousel_slider/carousel_slider.dart';
import 'package:domus_app/pages/agente_pages/agente_analisi_offerta_page.dart';
import 'package:domus_app/ui_elements/theme/ui_constants.dart';
import 'package:domus_app/ui_elements/utils/my_buttons_widgets.dart';
import 'package:domus_app/ui_elements/utils/my_pop_up_widgets.dart';
import 'package:flutter/material.dart';

class AgenteOffertePage extends StatefulWidget {
  const AgenteOffertePage({super.key});

  @override
  State<AgenteOffertePage> createState() => _AgenteOffertePageState();
}

class _AgenteOffertePageState extends State<AgenteOffertePage> {
  final double GRANDEZZA_SCRITTE_GRANDI = 22;
  final double GRANDEZZA_SCRITTE_PICCOLE = 18;
  int _currentSliderIndex = 0;

  final List<Map<String, String>> listaOfferte = [
    {
      'prezzo': '275.000',
      'data_offerta': '13-01-2025',
      'valore_offerta' : '260.000',
      'nome_offerente' : 'Paolo',
      'cognome_offerente' : 'Centonze',
      'email_offerente' : 'paolo.centonze@icloud.com',
      'stato_offerta' : 'In Attesa',
    },
    {
      'prezzo': '275.000',
      'data_offerta': '5-01-2025',
      'valore_offerta' : '280.000',
      'nome_offerente' : 'Marco',
      'cognome_offerente' : 'Lombari',
      'email_offerente' : 'marcolombari65@gmail.com',
      'stato_offerta' : 'In Attesa',
    },
    {
      'prezzo': '275.000',
      'data_offerta': '25-12-2024',
      'valore_offerta' : '225.000',
      'nome_offerente' : 'Massimiliano',
      'cognome_offerente' : 'De Santis',
      'email_offerente' : 'madmax@gmail.com',
      'stato_offerta' : 'In Attesa',
    },
    {
      'prezzo': '275.000',
      'data_offerta': '13-01-2025',
      'valore_offerta' : '260.000',
      'nome_offerente' : 'Paolo',
      'cognome_offerente' : 'Centonze',
      'email_offerente' : 'paolo.centonze@icloud.com',
      'stato_offerta' : 'In Attesa',
    },
    {
      'prezzo': '275.000',
      'data_offerta': '13-01-2025',
      'valore_offerta' : '260.000',
      'nome_offerente' : 'Paolo',
      'cognome_offerente' : 'Centonze',
      'email_offerente' : 'paolo.centonze@icloud.com',
      'stato_offerta' : 'In Attesa',
    },
    {
      'prezzo': '275.000',
      'data_offerta': '13-01-2025',
      'valore_offerta' : '260.000',
      'nome_offerente' : 'Paolo',
      'cognome_offerente' : 'Centonze',
      'email_offerente' : 'paolo.centonze@icloud.com',
      'stato_offerta' : 'In Attesa',
    },
    {
      'prezzo': '275.000',
      'data_offerta': '13-01-2025',
      'valore_offerta' : '260.000',
      'nome_offerente' : 'Paolo',
      'cognome_offerente' : 'Centonze',
      'email_offerente' : 'paolo.centonze@icloud.com',
      'stato_offerta' : 'In Attesa',
    },
    {
      'prezzo': '275.000',
      'data_offerta': '13-01-2025',
      'valore_offerta' : '260.000',
      'nome_offerente' : 'Paolo',
      'cognome_offerente' : 'Centonze',
      'email_offerente' : 'paolo.centonze@icloud.com',
      'stato_offerta' : 'In Attesa',
    },

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: context.onSecondary,
        ),
        automaticallyImplyLeading: true,
        title: Text("Offerte ricevute", style: TextStyle(color: context.onSecondary),),
        centerTitle: true,
        backgroundColor: context.primary,
        elevation: 5,
        shadowColor: context.shadow,
      ),
      body: Stack(
        children:[ 
          myCarouselSlider(context),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 63),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                color: context.primaryContainer,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 10,height: 40,),
                    Text("Prezzo iniziale: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: GRANDEZZA_SCRITTE_PICCOLE, color: context.outline),),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(listaOfferte[0]['prezzo']!, style: TextStyle(fontSize: GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: context.outline),))),
                    ),
                    Text("EUR", style: TextStyle(fontWeight: FontWeight.normal, fontSize: GRANDEZZA_SCRITTE_PICCOLE, color: context.outline),),
                    SizedBox(width: 10,),
                  ],
                ),
              ),
            )
          ),
          ]));
  }

 CarouselSlider myCarouselSlider(BuildContext context) {

    Color coloreScritte = context.outline;

    return CarouselSlider(
      items: listaOfferte.asMap().entries.map((entry) {
        int indice = entry.key;
        Map<String, dynamic> indiceOffertaCorrente = entry.value;
        double scaleFactor = indice == _currentSliderIndex ? 1.0 : 1.0;
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: context.primaryContainer,
            borderRadius: BorderRadius.circular(10),
            shape: BoxShape.rectangle,
            boxShadow: [BoxShadow(color: context.shadow.withOpacity(0.2),
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
                  Text("Data offerta: ", style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_GRANDI, fontWeight: FontWeight.bold, color: coloreScritte)),
                  Text(indiceOffertaCorrente['data_offerta'], style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_GRANDI, fontWeight: FontWeight.bold, color: coloreScritte)),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  Text(indiceOffertaCorrente['valore_offerta'], style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.bold, color: coloreScritte)),
                  Text(" EUR", style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.bold, color: coloreScritte)),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  Text("Nome: ", style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.bold, color: coloreScritte)),
                  Text(indiceOffertaCorrente['nome_offerente'], style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: coloreScritte)),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  Text("Cognome: ", style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.bold, color: coloreScritte)),
                  Text(indiceOffertaCorrente['cognome_offerente'], style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: coloreScritte)),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                  Text("Email: ", style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.bold, color: coloreScritte)),
                  Expanded(
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(indiceOffertaCorrente['email_offerente'], style: TextStyle(fontSize: GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: context.outline),))),
                    ),
                ],
              ),
              SizedBox(height: scaleFactor * MediaQuery.of(context).size.height/130,),
              Row(
                children: [
                  SizedBox(width: scaleFactor * MediaQuery.of(context).size.height/50,),
                  Expanded(
                    child: MyElevatedButtonRectWidget(
                            text: "Analizza",
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AgenteAnalizzaOffertaPage(offertaSelezionata: indiceOffertaCorrente)));
                            },
                            color: context.onSecondary,
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
                                                                    title: "Rifiuta offerta",
                                                                    bodyText: "Sei sicuro di voler rifiutare la prenotazione?",
                                                                    leftButtonText: "No",
                                                                    leftButtonColor: context.secondary,
                                                                    rightButtonText: "Si",
                                                                    rightButtonColor: context.tertiary,
                                                                    onPressLeftButton: (){Navigator.pop(context);},
                                                                    onPressRightButton: (){debugPrint("Prenotazione accettata");},
                                                                  )
                                );
                            },
                            color: context.secondary
                          )
                    ),
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
        viewportFraction: 0.29,
        height: 850,
        enlargeCenterPage: false,
        scrollDirection: Axis.vertical,
        onPageChanged: (indiceOffertaCorrente, reason) {
          setState(() {
            _currentSliderIndex = indiceOffertaCorrente;
          });
        }
      )
    );
  }

}