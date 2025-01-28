import 'package:domus_app/utils/my_buttons_widgets.dart';
import 'package:domus_app/utils/my_pop_up_widgets.dart';
import 'package:domus_app/utils/my_text_widgets.dart';
import 'package:flutter/material.dart';

class AgenteAnalizzaOffertaPage extends StatefulWidget {
  final Map<String, dynamic> offertaSelezionata;
  const AgenteAnalizzaOffertaPage({super.key, required this.offertaSelezionata});

  @override
  State<AgenteAnalizzaOffertaPage> createState() => _AgenteAnalizzaOffertaPageState();
}

class _AgenteAnalizzaOffertaPageState extends State<AgenteAnalizzaOffertaPage> {
  static const double GRANDEZZA_SCRITTE = 23;
  static const double GRANDEZZA_ICONE = 25;
  static const double GRANDEZZA_SCRITTE_PICCOLE = 18;
  static const double GRANDEZZA_ICONE_PICCOLE = 20;
  Color coloreScritte = Colors.black;
  TextEditingController contropropostaController = TextEditingController();
  late ScrollController scrollController;

  @override
  void initState(){
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose(){
    scrollController.dispose();
    super.dispose();
  }

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
          color: Theme.of(context).colorScheme.surface,
        ),
        title: Text("Analisi offerte immobile", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 5,
        shadowColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        Text("Prezzo iniziale: ", style: TextStyle(fontSize: GRANDEZZA_SCRITTE, fontWeight: FontWeight.bold, color: coloreScritte)),
                        Text(widget.offertaSelezionata['prezzo'], style: TextStyle(fontSize: GRANDEZZA_SCRITTE, fontWeight: FontWeight.bold, color: coloreScritte)),
                        Text(" EUR", style: TextStyle(fontSize: GRANDEZZA_SCRITTE, fontWeight: FontWeight.bold, color: coloreScritte)),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        Text("Offerta cliente: ", style: TextStyle(fontSize: GRANDEZZA_SCRITTE, fontWeight: FontWeight.bold, color: coloreScritte)),
                        Text(widget.offertaSelezionata['valore_offerta'], style: TextStyle(fontSize: GRANDEZZA_SCRITTE, fontWeight: FontWeight.bold, color: coloreScritte)),
                        Text(" EUR", style: TextStyle(fontSize: GRANDEZZA_SCRITTE, fontWeight: FontWeight.bold, color: coloreScritte)),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        Text("Data offerta: ", style: TextStyle(fontSize: GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.bold, color: coloreScritte)),
                        Text(widget.offertaSelezionata['data_offerta'], style: TextStyle(fontSize: GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: coloreScritte)),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        Text("Nome: ", style: TextStyle(fontSize: GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.bold, color: coloreScritte)),
                        Text(widget.offertaSelezionata['nome_offerente'], style: TextStyle(fontSize: GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: coloreScritte)),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        Text("Cognome: ", style: TextStyle(fontSize: GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.bold, color: coloreScritte)),
                        Text(widget.offertaSelezionata['cognome_offerente'], style: TextStyle(fontSize: GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: coloreScritte)),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        Text("Email: ", style: TextStyle(fontSize: GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.bold, color: coloreScritte)),
                        Expanded(
                            child: FittedBox(
                              alignment: Alignment.centerLeft,
                              fit: BoxFit.scaleDown,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(widget.offertaSelezionata['email_offerente'], style: TextStyle(fontSize: GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: Theme.of(context).colorScheme.outline),))),
                          ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.height/50,),
                        Expanded(
                            child: MyElevatedButtonRectWidget(
                                    text: "Accetta",
                                    onPressed: (){
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) => MyOptionsDialog(
                                                                            title: "Accetta offerta",
                                                                            bodyText: "Sei sicuro di voler accettare l'offerta?",
                                                                            rightButtonText: "Si",
                                                                            leftButtonText: "No",
                                                                            leftButtonColor: Theme.of(context).colorScheme.secondary,
                                                                            rightButtonColor: Theme.of(context).colorScheme.tertiary,
                                                                            onPressLeftButton: (){Navigator.pop(context);},
                                                                            onPressRightButton: (){debugPrint("offerta accettata");},
                                                                          )
                                        );
                                    },
                                    color: Theme.of(context).colorScheme.primary
                                  )
                          ),
                        SizedBox(width: MediaQuery.of(context).size.height/50,),
                        Expanded(
                          child: MyElevatedButtonRectWidget(
                                  text: "Rifiuta",
                                  onPressed: (){
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) => MyOptionsDialog(
                                                                          title: "Rifiuta offerta",
                                                                          bodyText: "Sei sicuro di voler rifiutare l'offerta?",
                                                                          leftButtonText: "No",
                                                                          leftButtonColor: Theme.of(context).colorScheme.secondary,
                                                                          rightButtonText: "Si",
                                                                          rightButtonColor: Theme.of(context).colorScheme.tertiary,
                                                                          onPressLeftButton: (){Navigator.pop(context);},
                                                                          onPressRightButton: (){debugPrint("Prenotazione rifiutata");},
                                                                        )
                                      );
                                  },
                                  color: Theme.of(context).colorScheme.primary
                                )
                        ),
                        SizedBox(width: MediaQuery.of(context).size.height/50,),
                      ],
                    ),
                    SizedBox(height: 10,),
                    
                    Row(
                    children: [
                      Expanded(child: Divider(height: 50, thickness: 2, indent: 20, endIndent: 10, color: coloreScritte,)),
                      Text("oppure", style: TextStyle(color: coloreScritte),),
                      Expanded(child: Divider(height: 50, thickness: 2, indent: 10, endIndent: 20, color: coloreScritte,)),
                    ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.height/50,),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text("Inserisci Controproposta: ", style: TextStyle(fontSize: GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.bold, color: coloreScritte),),
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width * 0.40,
                                  child: MyTextFieldOnlyPositiveNumbers(controller: contropropostaController, text: "EUR", colore: coloreScritte,)
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    // MyTextFieldOnlyPositiveNumbers(controller: contropropostaController, text: "Controproposta", colore: coloreScritte),
                    SizedBox(height: MediaQuery.of(context).size.height/50,),
                    MyElevatedButtonRectWidget(text: "Invia", onPressed: (){
                                      inviaControproposta(context);
                                      }, color: Theme.of(context).colorScheme.primary),
                    SizedBox(height: MediaQuery.of(context).size.height/50,),

                    Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        height: 300,
                        width: 375,
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Storico offerte',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: coloreScritte
                              ),
                            ),
                            SizedBox(height: 8),
                            Divider(color: coloreScritte,),
                            Expanded(
                              child: Scrollbar(
                                controller: scrollController,
                                thumbVisibility: true,
                                thickness: 6,
                                radius: Radius.circular(8),
                                child: ListView.builder(
                                  controller: scrollController,
                                  itemCount: listaOfferte.length,
                                  itemBuilder: (context, index) {
                                    final elemento = listaOfferte[index];
                                    return ListTile(
                                      title: Column(
                                        children: [
                                          Text("${elemento['valore_offerta']} EUR", style: TextStyle(color: coloreScritte),),
                                          Text("Data offerta: ${elemento['data_offerta']}", style: TextStyle(color: coloreScritte),),
                                          Divider(color: coloreScritte, thickness: 0.7,),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),

                    
                ],),
        ),
      );
  }

  void inviaControproposta(BuildContext context) {
    if(contropropostaController.text.isEmpty){
      showDialog(
        barrierDismissible: false,
        context: context, 
        builder: (BuildContext context) => MyInfoDialog(title: "Attenzione", bodyText: "Inserire una controproposta", buttonText: "Ok", onPressed: (){Navigator.pop(context);})
      );
    }

    try {
      //conversione delle stringhe in numeri
      String offertaAttualeStringa = widget.offertaSelezionata['valore_offerta'];
      int offertaAttuale = int.parse(offertaAttualeStringa.replaceAll('.', ''));

      int nuovaControproposta = int.parse(contropropostaController.text);

      String prezzoInizialeStringa = widget.offertaSelezionata['prezzo'];
      int prezzoIniziale = int.parse(prezzoInizialeStringa.replaceAll('.', ''));

      if(offertaAttuale >= nuovaControproposta){
        showDialog(
        barrierDismissible: false,
        context: context, 
        builder: (BuildContext context) => MyInfoDialog(title: "Attenzione", bodyText: "La controproposta deve essere maggiore dell'offerta", buttonText: "Ok", onPressed: (){Navigator.pop(context);})
        );
      }else if(nuovaControproposta > prezzoIniziale){
        showDialog(
        barrierDismissible: false,
        context: context, 
        builder: (BuildContext context) => MyInfoDialog(title: "Attenzione", bodyText: "La controproposta deve essere minore del prezzo iniziale", buttonText: "Ok", onPressed: (){Navigator.pop(context);})
        );
      } else {
        showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => MyOptionsDialog(
                                            title: "Conferma",
                                            bodyText: "Sei sicuro di voler inviare una controproposta di ${contropropostaController.text} EUR?",
                                            leftButtonText: "No",
                                            leftButtonColor: Theme.of(context).colorScheme.secondary,
                                            rightButtonText: "Si",
                                            rightButtonColor: Theme.of(context).colorScheme.tertiary,
                                            onPressLeftButton: (){Navigator.pop(context);},
                                            onPressRightButton: (){debugPrint("Controproposta inviata");},
                                          )
        );
      }
    } catch (e) {
       print("Errore durante la conversione: $e");
    }
  }
}