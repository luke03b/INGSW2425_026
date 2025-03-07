import 'dart:async';

import 'package:domus_app/back_end_communication/class_services/offerta_service.dart';
import 'package:domus_app/back_end_communication/communication_utils/status_code_controller.dart';
import 'package:domus_app/back_end_communication/dto/annuncio_dto.dart';
import 'package:domus_app/back_end_communication/dto/offerta_dto.dart';
import 'package:domus_app/services/formatStrings.dart';
import 'package:domus_app/ui_elements/theme/ui_constants.dart';
import 'package:domus_app/ui_elements/utils/my_buttons_widgets.dart';
import 'package:domus_app/ui_elements/utils/my_loading.dart';
import 'package:domus_app/ui_elements/utils/my_pop_up_widgets.dart';
import 'package:domus_app/ui_elements/utils/my_text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:domus_app/ui_elements/utils/my_ui_messages_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreaOffertaPage extends StatefulWidget {
  final AnnuncioDto annuncioSelezionato;
  final bool isOffertaManuale;
  const CreaOffertaPage({
    super.key,
    required this.annuncioSelezionato,
    required this.isOffertaManuale
  });

  @override
  State<CreaOffertaPage> createState() => _CreaOffertaPageState();
}

class _CreaOffertaPageState extends State<CreaOffertaPage> {
  bool areServersAvailable = false;
  bool areDataRetrieved = false;
  bool hasAnnuncioOfferte = false;
  static const double GRANDEZZA_SCRITTE = 23;
  static const double GRANDEZZA_ICONE = 25;
  static const double GRANDEZZA_SCRITTE_PICCOLE = 18;
  static const double GRANDEZZA_ICONE_PICCOLE = 20;
  TextEditingController offertaController = TextEditingController();
  TextEditingController nomeOfferenteController = TextEditingController();
  TextEditingController cognomeOfferenteController = TextEditingController();
  TextEditingController emailOfferenteController = TextEditingController();
  late ScrollController storicoOfferteScrollController;

  List<OffertaDto> listaStoricoOfferte = [];

  void getStoricoOfferte() async {
    try{
      List<OffertaDto> data = await OffertaService.recuperaTutteOfferteByAnnuncio(widget.annuncioSelezionato);
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
    storicoOfferteScrollController = ScrollController();
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
    storicoOfferteScrollController.dispose();
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
                        Text(FormatStrings.formatNumber(widget.annuncioSelezionato.prezzo), style: TextStyle(fontSize: GRANDEZZA_SCRITTE, fontWeight: FontWeight.bold, color: coloreScritte)),
                        Text(" EUR", style: TextStyle(fontSize: GRANDEZZA_SCRITTE, fontWeight: FontWeight.bold, color: coloreScritte)),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Visibility(
                      visible: widget.isOffertaManuale,
                      child:
                      Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(width: MediaQuery.of(context).size.height/50,),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.90,
                                child: MyTextFieldPrefixIcon(controller: nomeOfferenteController, text: "nome offerente", icon: Icon(Icons.face), color: coloreScritte,)
                              )
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              SizedBox(width: MediaQuery.of(context).size.height/50,),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.90,
                                child: MyTextFieldPrefixIcon(controller: cognomeOfferenteController, text: "cognome offerente", icon: Icon(FontAwesomeIcons.idCard), color: coloreScritte,)
                              )
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              SizedBox(width: MediaQuery.of(context).size.height/50,),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.90,
                                child: MyTextFieldPrefixIcon(controller: emailOfferenteController, text: "email offerente", icon: Icon(Icons.person), color: coloreScritte,)
                              )
                            ],
                          ),
                          SizedBox(height: 10,),
                        ]
                      )
                    ),
                    Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.height/50,),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text("Inserisci offerta: ", style: TextStyle(fontSize: GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.bold, color: coloreScritte),),
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width * 0.55,
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
                        controllaOfferta(context);
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
                        child: switch ((areDataRetrieved, areServersAvailable, hasAnnuncioOfferte)) {
                                (false, _, _) => MyUiMessagesWidgets.myTextWithLoading(context, "Stiamo recuperando le offerte fatte su questo annuncio"),
                                (true, false, _) => MyUiMessagesWidgets.myErrorWithButton(
                                                                          context, "Server non raggiungibili. Controllare la connessione a internet e riprovare", 
                                                                          "Riprova", 
                                                                          (){
                                                                            setState(() {
                                                                              hasAnnuncioOfferte = false;
                                                                              areDataRetrieved = false;
                                                                              areServersAvailable = false;
                                                                            });
                                                                            getStoricoOfferte();
                                                                          }
                                                                        ),
                                (true, true, false) => Column(
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
                                    MyUiMessagesWidgets.myText(context, "Sii il primo ad aggiungere un'offerta!"),
                                  ],
                                ),
                                (true, true, true) => myStoricoOfferte(),
                              }
                      ),
                    ),
                ],),
        ),
      );
  }

  Column myStoricoOfferte(){
    Color coloreScritte = context.outline;
    return Column(
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
                    controller: storicoOfferteScrollController,
                    thumbVisibility: true,
                    thickness: 6,
                    radius: Radius.circular(8),
                    child: ListView.builder(
                      controller: storicoOfferteScrollController,
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
            );
  }

  void controllaOfferta(BuildContext context) {
    if(offertaController.text.isEmpty){
      showDialog(
        barrierDismissible: false,
        context: context, 
        builder: (BuildContext context) => MyInfoDialog(title: "Attenzione", bodyText: "Inserire un'offerta", buttonText: "Ok", onPressed: (){Navigator.pop(context);})
      );
    }

    try {
      //conversione delle stringhe in numeri
      String prezzoAnnuncioStringa = FormatStrings.formatNumber(widget.annuncioSelezionato.prezzo);
      int prezzoAnnuncio = int.parse(prezzoAnnuncioStringa.replaceAll('.', ''));
      int nuovaOfferta = int.parse(offertaController.text);

      if(nuovaOfferta > prezzoAnnuncio){
        showDialog(
        barrierDismissible: false,
        context: context, 
        builder: (BuildContext context) => MyInfoDialog(title: "Attenzione", bodyText: "L'offerta deve essere minore del prezzo iniziale", buttonText: "Ok", onPressed: (){Navigator.pop(context);})
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
                                            onPressLeftButton: () async {
                                              LoadingHelper.showLoadingDialogNotDissmissible(context, color: context.secondary);
                                              try {
                                                int statusCode;
                                                if(nomeOfferenteController.text.isEmpty && cognomeOfferenteController.text.isEmpty && emailOfferenteController.text.isEmpty){
                                                  statusCode = await OffertaService.creaOfferta(widget.annuncioSelezionato, offertaController.text);
                                                } else {
                                                  statusCode = await OffertaService.creaOfferta(widget.annuncioSelezionato, offertaController.text, nomeOfferente: nomeOfferenteController.text, cognomeOfferente: cognomeOfferenteController.text, emailOfferente: emailOfferenteController.text);
                                                }
                                                Navigator.pop(context);
                                                await StatusCodeController.controllaStatusCodeAndShowPopUp(context, statusCode, 201, "Conferma", "Offerta inviata", "Errore", "Offerta non inviata");
                                                setState(() {
                                                  hasAnnuncioOfferte = false;
                                                  areDataRetrieved = false;
                                                  areServersAvailable = false;
                                                  offertaController.text = "";
                                                  nomeOfferenteController.text = "";
                                                  cognomeOfferenteController.text = "";
                                                  emailOfferenteController.text = "";
                                                });
                                                getStoricoOfferte();
                                              } on TimeoutException {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                showDialog(
                                                  context: context, 
                                                  builder: (BuildContext context) => MyInfoDialog(
                                                    title: "Connessione non riuscita", 
                                                    bodyText: "Offerta non inviata, la connessione con i nostri server non è stata stabilita correttamente. Riprova più tardi.", 
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
                                                    bodyText: "Offerta non inviata. $e", 
                                                    buttonText: "Ok", 
                                                    onPressed: () {Navigator.pop(context);}
                                                  )
                                                );
                                              }
                                            },
                                            onPressRightButton: (){Navigator.pop(context);}
                                          )
        );
      }
    } catch (e) {
       print("Errore durante la conversione: $e");
    }
  }
}