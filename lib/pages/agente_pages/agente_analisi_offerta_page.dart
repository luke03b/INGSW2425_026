import 'dart:async';

import 'package:domus_app/back_end_communication/class_services/offerta_service.dart';
import 'package:domus_app/back_end_communication/communication_utils/status_code_controller.dart';
import 'package:domus_app/back_end_communication/dto/offerta_dto.dart';
import 'package:domus_app/costants/enumerations.dart';
import 'package:domus_app/ui_elements/utils/formatStrings.dart';
import 'package:domus_app/ui_elements/theme/ui_constants.dart';
import 'package:domus_app/ui_elements/utils/my_buttons_widgets.dart';
import 'package:domus_app/ui_elements/utils/my_loading.dart';
import 'package:domus_app/ui_elements/utils/my_pop_up_widgets.dart';
import 'package:domus_app/ui_elements/utils/my_text_widgets.dart';
import 'package:flutter/material.dart';

class AgenteAnalizzaOffertaPage extends StatefulWidget {
  final OffertaDto offertaSelezionata;
  const AgenteAnalizzaOffertaPage({super.key, required this.offertaSelezionata});

  @override
  State<AgenteAnalizzaOffertaPage> createState() => _AgenteAnalizzaOffertaPageState();
}

class _AgenteAnalizzaOffertaPageState extends State<AgenteAnalizzaOffertaPage> {
  static const double GRANDEZZA_SCRITTE = 23;
  static const double GRANDEZZA_ICONE = 25;
  static const double GRANDEZZA_SCRITTE_PICCOLE = 18;
  static const double GRANDEZZA_ICONE_PICCOLE = 20;
  bool areServersAvailable = false;
  bool areDataRetrieved = false;
  bool hasAnnuncioOfferte = false;
  TextEditingController contropropostaController = TextEditingController();
  late ScrollController scrollController;
  List<OffertaDto> listaStoricoOfferte = [];

  void getStoricoOfferte() async {
    try{
      List<OffertaDto> data = await OffertaService.recuperaTutteOfferteByAnnuncio(widget.offertaSelezionata.annuncio);
      if (mounted) {
        setState(() {
          listaStoricoOfferte = data;
          hasAnnuncioOfferte = listaStoricoOfferte.isNotEmpty;
          areDataRetrieved = true;
          areServersAvailable = true;
        });
      }
    } on TimeoutException {
      if (mounted) {
        setState(() {
          areServersAvailable = false;
          areDataRetrieved = true;
        });
      }
    } catch (error) {
      setState(() {
        areServersAvailable = false;
        areDataRetrieved = true;
      });
      print('Errore con il recupero delle offerte (il server potrebbe non essere raggiungibile) $error');
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Esegui getAnnunci dopo la fase di build
    Future.delayed(Duration.zero, () {
      getStoricoOfferte();
    });
  }

  @override
  void dispose(){
    scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Color coloreScritte = context.outline;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: context.onSecondary,
        ),
        title: Text("Analisi offerte immobile", style: TextStyle(color: context.onSecondary),),
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
                        Text(FormatStrings.formatNumber(widget.offertaSelezionata.annuncio.prezzo), style: TextStyle(fontSize: GRANDEZZA_SCRITTE, fontWeight: FontWeight.bold, color: coloreScritte)),
                        Text(" EUR", style: TextStyle(fontSize: GRANDEZZA_SCRITTE, fontWeight: FontWeight.bold, color: coloreScritte)),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        Text("Offerta cliente: ", style: TextStyle(fontSize: GRANDEZZA_SCRITTE, fontWeight: FontWeight.bold, color: coloreScritte)),
                        Text(FormatStrings.formatNumber(widget.offertaSelezionata.prezzo), style: TextStyle(fontSize: GRANDEZZA_SCRITTE, fontWeight: FontWeight.bold, color: coloreScritte)),
                        Text(" EUR", style: TextStyle(fontSize: GRANDEZZA_SCRITTE, fontWeight: FontWeight.bold, color: coloreScritte)),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        Text("Data offerta: ", style: TextStyle(fontSize: GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.bold, color: coloreScritte)),
                        Text(FormatStrings.formattaDataGGMMAAAAeHHMM(widget.offertaSelezionata.data!), style: TextStyle(fontSize: GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: coloreScritte)),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        Text("Nome: ", style: TextStyle(fontSize: GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.bold, color: coloreScritte)),
                        widget.offertaSelezionata.cliente != null ? 
                          Text(widget.offertaSelezionata.cliente!.nome, style: TextStyle(fontSize: GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: coloreScritte)) 
                          : 
                          Text(widget.offertaSelezionata.nomeOfferente!, style: TextStyle(fontSize: GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: context.outline))
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        SizedBox(width: MediaQuery.of(context).size.width/45,),
                        Text("Nome: ", style: TextStyle(fontSize: GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.bold, color: coloreScritte)),
                        widget.offertaSelezionata.cliente != null ? 
                          Text(widget.offertaSelezionata.cliente!.cognome, style: TextStyle(fontSize: GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: coloreScritte)) 
                          : 
                          Text(widget.offertaSelezionata.cognomeOfferente!, style: TextStyle(fontSize: GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: context.outline))
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
                                child: 
                                  widget.offertaSelezionata.cliente != null ?
                                  Text(widget.offertaSelezionata.cliente!.email, style: TextStyle(fontSize: GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: context.outline),)
                                  :
                                  Text(widget.offertaSelezionata.emailOfferente!, style: TextStyle(fontSize: GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: context.outline),)
                                )
                              ),
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
                                                                            leftButtonColor: context.secondary,
                                                                            rightButtonColor: context.tertiary,
                                                                            onPressLeftButton: (){Navigator.pop(context);},
                                                                            onPressRightButton: () async {
                                                                              LoadingHelper.showLoadingDialogNotDissmissible(context, color: context.secondary);
                                                                              try {
                                                                                int statusCode = await OffertaService.aggiornaStatoOfferta(widget.offertaSelezionata, Enumerations.statoOfferte[1]);
                                                                                Navigator.pop(context);
                                                                                Navigator.pop(context);
                                                                                await StatusCodeController.controllaStatusCodeAndShowPopUp(context, statusCode, 200, "Conferma", "Offerta accettata", "Errore", "Offerta non accettata");
                                                                                setState(() {
                                                                                  hasAnnuncioOfferte = false;
                                                                                  areDataRetrieved = false;
                                                                                  areServersAvailable = false;
                                                                                });
                                                                                getStoricoOfferte();
                                                                              } on TimeoutException {
                                                                                Navigator.pop(context);
                                                                                Navigator.pop(context);
                                                                                showDialog(
                                                                                  context: context, 
                                                                                  builder: (BuildContext context) => MyInfoDialog(
                                                                                    title: "Connessione non riuscita", 
                                                                                    bodyText: "Offerta non accettata, la connessione con i nostri server non è stata stabilita correttamente. Riprova più tardi.", 
                                                                                    buttonText: "Ok", 
                                                                                    onPressed: () {Navigator.pop(context);}
                                                                                  )
                                                                                );
                                                                              } catch (e) {
                                                                                print(e);
                                                                                Navigator.pop(context);
                                                                                Navigator.pop(context);
                                                                                showDialog(
                                                                                  context: context, 
                                                                                  builder: (BuildContext context) => MyInfoDialog(
                                                                                    title: "Errore",
                                                                                    bodyText: "Offerta non accettata.", 
                                                                                    buttonText: "Ok", 
                                                                                    onPressed: () {Navigator.pop(context);}
                                                                                  )
                                                                                );
                                                                              }
                                                                            
                                                                            },
                                                                          )
                                        );
                                    },
                                    color: context.onSecondary
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
                                                                          leftButtonColor: context.secondary,
                                                                          rightButtonText: "Si",
                                                                          rightButtonColor: context.tertiary,
                                                                          onPressLeftButton: (){Navigator.pop(context);},
                                                                          onPressRightButton: () async {
                                                                            LoadingHelper.showLoadingDialogNotDissmissible(context, color: context.secondary);
                                                                            try {
                                                                              int statusCode = await OffertaService.aggiornaStatoOfferta(widget.offertaSelezionata, Enumerations.statoOfferte[2]);
                                                                              Navigator.pop(context);
                                                                              Navigator.pop(context);
                                                                              await StatusCodeController.controllaStatusCodeAndShowPopUp(context, statusCode, 200, "Conferma", "Offerta rifiutata", "Errore", "Offerta non rifiutata");
                                                                              setState(() {
                                                                                hasAnnuncioOfferte = false;
                                                                                areDataRetrieved = false;
                                                                                areServersAvailable = false;
                                                                              });
                                                                              getStoricoOfferte();
                                                                            }on TimeoutException {
                                                                              Navigator.pop(context);
                                                                              Navigator.pop(context);
                                                                              showDialog(
                                                                                context: context, 
                                                                                builder: (BuildContext context) => MyInfoDialog(
                                                                                  title: "Connessione non riuscita", 
                                                                                  bodyText: "Offerta non rifiutata, la connessione con i nostri server non è stata stabilita correttamente. Riprova più tardi.", 
                                                                                  buttonText: "Ok", 
                                                                                  onPressed: () {Navigator.pop(context);}
                                                                                )
                                                                              );
                                                                            } catch (e) {
                                                                              print(e);
                                                                              Navigator.pop(context);
                                                                              Navigator.pop(context);
                                                                              showDialog(
                                                                                context: context, 
                                                                                builder: (BuildContext context) => MyInfoDialog(
                                                                                  title: "Errore",
                                                                                  bodyText: "Offerta non rifiutata.", 
                                                                                  buttonText: "Ok", 
                                                                                  onPressed: () {Navigator.pop(context);}
                                                                                )
                                                                              );
                                                                            }
                                                                          },
                                                                        )
                                      );
                                  },
                                  color: context.secondary
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
                    MyElevatedButtonRectWidget(text: "Invia", onPressed: () async {
                                      await inviaControproposta(context);
                                      }, color: context.onSecondary),
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
                                  itemCount: listaStoricoOfferte.length,
                                  itemBuilder: (context, index) {
                                    final elemento = listaStoricoOfferte[index];
                                    return ListTile(
                                      title: Column(
                                        children: [
                                          Text("${FormatStrings.formatNumber(elemento.prezzo)} EUR", style: TextStyle(color: coloreScritte),),
                                          Text("Data offerta: ${FormatStrings.formattaDataGGMMAAAAeHHMM(elemento.data!)}", style: TextStyle(color: coloreScritte),),
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

  Future<void> inviaControproposta(BuildContext context) async {
    if(contropropostaController.text.isEmpty){
      showDialog(
        barrierDismissible: false,
        context: context, 
        builder: (BuildContext context) => MyInfoDialog(title: "Attenzione", bodyText: "Inserire una controproposta", buttonText: "Ok", onPressed: (){Navigator.pop(context);})
      );
    }

    try {
      int nuovaControproposta = int.parse(contropropostaController.text);

      if(widget.offertaSelezionata.prezzo >= nuovaControproposta){
        showDialog(
        barrierDismissible: false,
        context: context, 
        builder: (BuildContext context) => MyInfoDialog(title: "Attenzione", bodyText: "La controproposta deve essere maggiore dell'offerta", buttonText: "Ok", onPressed: (){Navigator.pop(context);})
        );
      }else if(nuovaControproposta > widget.offertaSelezionata.annuncio.prezzo){
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
                                            leftButtonColor: context.secondary,
                                            rightButtonText: "Si",
                                            rightButtonColor: context.tertiary,
                                            onPressLeftButton: (){Navigator.pop(context);},
                                            onPressRightButton: () async {
                                                    LoadingHelper.showLoadingDialog(context);
                                                    try {
                                                      int statusCode = await OffertaService.aggiornaStatoOfferta(widget.offertaSelezionata, Enumerations.statoOfferte[3], controproposta: double.parse(contropropostaController.text));
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      await StatusCodeController.controllaStatusCodeAndShowPopUp(context, statusCode, 200, "Conferma", "Controproposta inviata", "Errore", "Controproposta non inviata");
                                                      setState(() {
                                                        hasAnnuncioOfferte = false;
                                                        areDataRetrieved = false;
                                                        areServersAvailable = false;
                                                      });
                                                      getStoricoOfferte();
                                                    }on TimeoutException {
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      showDialog(
                                                        context: context, 
                                                        builder: (BuildContext context) => MyInfoDialog(
                                                          title: "Connessione non riuscita", 
                                                          bodyText: "Controproposta non inviata, la connessione con i nostri server non è stata stabilita correttamente. Riprova più tardi.", 
                                                          buttonText: "Ok", 
                                                          onPressed: () {Navigator.pop(context);}
                                                        )
                                                      );
                                                    } catch (e) {
                                                      print(e);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      showDialog(
                                                        context: context, 
                                                        builder: (BuildContext context) => MyInfoDialog(
                                                          title: "Errore",
                                                          bodyText: "Controproposta non inviata.", 
                                                          buttonText: "Ok", 
                                                          onPressed: () {Navigator.pop(context);}
                                                        )
                                                      );
                                                    }
                                            },
                                          )
        );
      }
    } catch (e) {
       print("Errore durante la conversione: $e");
    }
  }
}