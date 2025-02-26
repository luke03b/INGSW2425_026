import 'package:domus_app/dto/annuncio_dto.dart';
import 'package:domus_app/services/formatStrings.dart';
import 'package:domus_app/theme/ui_constants.dart';
import 'package:domus_app/utils/my_buttons_widgets.dart';
import 'package:domus_app/utils/my_pop_up_widgets.dart';
import 'package:domus_app/utils/my_text_widgets.dart';
import 'package:flutter/material.dart';

class ClienteCreaOffertaPage extends StatefulWidget {
  final AnnuncioDto casaSelezionata;
  const ClienteCreaOffertaPage({
    super.key,
    required this.casaSelezionata,
    });

  @override
  State<ClienteCreaOffertaPage> createState() => _ClienteCreaOffertaPageState();
}

class _ClienteCreaOffertaPageState extends State<ClienteCreaOffertaPage> {
  static const double GRANDEZZA_SCRITTE = 23;
  static const double GRANDEZZA_ICONE = 25;
  static const double GRANDEZZA_SCRITTE_PICCOLE = 18;
  static const double GRANDEZZA_ICONE_PICCOLE = 20;
  TextEditingController offertaController = TextEditingController();
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
    Color coloreScritte = context.outline;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: context.onSecondary,
        ),
        title: Text("Crea offerta", style: TextStyle(color: context.onSecondary),),
        centerTitle: true,
        backgroundColor: context.primary,
        elevation: 5,
        shadowColor: context.shadow,
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
                        Text(FormatStrings.formatNumber(widget.casaSelezionata.prezzo), style: TextStyle(fontSize: GRANDEZZA_SCRITTE, fontWeight: FontWeight.bold, color: coloreScritte)),
                        Text(" EUR", style: TextStyle(fontSize: GRANDEZZA_SCRITTE, fontWeight: FontWeight.bold, color: coloreScritte)),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.height/50,),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text("Inserisci offerta: ", style: TextStyle(fontSize: GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.bold, color: coloreScritte),),
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width * 0.40,
                                  child: MyTextFieldOnlyPositiveNumbers(controller: offertaController, text: "EUR", colore: coloreScritte,)
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/50,),
                    MyElevatedButtonRectWidget(
                      text: "Invia", 
                      onPressed: (){
                        inviaOfferta(context);
                      },
                      color: context.tertiary
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/50,),
                    Card(
                      color: context.primaryContainer,
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

  void inviaOfferta(BuildContext context) {
    if(offertaController.text.isEmpty){
      showDialog(
        barrierDismissible: false,
        context: context, 
        builder: (BuildContext context) => MyInfoDialog(title: "Attenzione", bodyText: "Inserire un'offerta", buttonText: "Ok", onPressed: (){Navigator.pop(context);})
      );
    }

    try {
      //conversione delle stringhe in numeri
      String prezzoAnnuncioStringa = FormatStrings.formatNumber(widget.casaSelezionata.prezzo);
      int prezzoAnnuncio = int.parse(prezzoAnnuncioStringa.replaceAll('.', ''));
      int nuovaOfferta = int.parse(offertaController.text);

      if(nuovaOfferta <= prezzoAnnuncio){
        showDialog(
        barrierDismissible: false,
        context: context, 
        builder: (BuildContext context) => MyInfoDialog(title: "Attenzione", bodyText: "L'offerta deve essere maggiore del prezzo iniziale", buttonText: "Ok", onPressed: (){Navigator.pop(context);})
        );
      }else{
        showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => MyOptionsDialog(
                                            title: "Conferma",
                                            bodyText: "Sei sicuro di voler inviare un'offerta di ${offertaController.text} EUR?",
                                            leftButtonText: "Si",
                                            leftButtonColor: context.tertiary,
                                            rightButtonText: "No",
                                            rightButtonColor: context.secondary,
                                            onPressLeftButton: (){debugPrint("offerta inviata");},
                                            onPressRightButton: (){Navigator.pop(context);}
                                          )
        );
      }
    } catch (e) {
       print("Errore durante la conversione: $e");
    }
  }
}