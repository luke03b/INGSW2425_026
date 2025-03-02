import 'package:domus_app/back_end_communication/class_services/utente_service.dart';
import 'package:domus_app/costants/costants.dart';
import 'package:domus_app/services/aws_cognito.dart';
import 'package:domus_app/ui_elements/theme/ui_constants.dart';
import 'package:domus_app/ui_elements/utils/my_buttons_widgets.dart';
import 'package:domus_app/ui_elements/utils/my_pop_up_widgets.dart';
import 'package:domus_app/ui_elements/utils/my_text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminCreaNuovoAdminPage extends StatefulWidget {
  final bool isNewUserAdmin;
  
  const AdminCreaNuovoAdminPage({
    super.key,
    required this.isNewUserAdmin,
  });

  @override
  State<AdminCreaNuovoAdminPage> createState() => _AdminCreaNuovoAdminPageState();
}

class _AdminCreaNuovoAdminPageState extends State<AdminCreaNuovoAdminPage> {
  TextEditingController newAdminMailController = TextEditingController();
  TextEditingController newAdminPasswordController = TextEditingController();
  TextEditingController newAdminNomeController = TextEditingController();
  TextEditingController newAdminCognomeController = TextEditingController();

  register(String nome, String cognome, String email, String password, String userGroup, String? agenziaImmobiliare) => AWSServices().register(nome, cognome, email, password, userGroup, agenziaImmobiliare);

  @override
  Widget build(BuildContext context) {
    Color coloriScritte = context.outline;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: context.onSecondary,
        ),
        title: Text( widget.isNewUserAdmin ? "Crea nuovo admin" : "Crea nuovo agente", style: TextStyle(color: context.onSecondary),),
        centerTitle: true,
        backgroundColor: context.primary,
        elevation: 5,
        shadowColor: context.shadow,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Spacer(flex: 5),

              //nomeTextField
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.92,
                child: MyTextFieldPrefixIcon(controller: newAdminNomeController, text: "nome", icon: const Icon(Icons.face), color: coloriScritte,)),
              const Spacer(),   

              //cognomeTextField
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.92,
                child: MyTextFieldPrefixIcon(controller: newAdminCognomeController, text: "cognome", icon: const Icon(FontAwesomeIcons.idCard), color: coloriScritte,)),
              const Spacer(),

              //emailTextField
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.92,
                child: MyTextFieldPrefixIcon(controller: newAdminMailController, text: "email", icon: const Icon(Icons.person), color: coloriScritte,)),
              const Spacer(),

              //passwordTextField
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.92,
                child: MyPasswordFieldWidget(controller: newAdminPasswordController, text: "password", icon: const Icon(Icons.lock), color: coloriScritte,)),
              const Spacer(flex: 5),

              //RegistratiButton
              MyElevatedButtonWidget(text: widget.isNewUserAdmin ? "Registra admin" : "Registra agente", onPressed: () async{
                if(widget.isNewUserAdmin){
                  showDialog(
                    barrierDismissible: false,
                    context: context, 
                    builder: (BuildContext context) => MyOptionsDialog(title: "Attenzione", bodyText: "Sei sicuro di voler creare un nuovo admin?", rightButtonText: "Si", rightButtonColor: context.tertiary, onPressRightButton: () async {await aggiungiAdmin(context);}, leftButtonText: "No", leftButtonColor: context.secondary, onPressLeftButton: (){Navigator.pop(context);})
                  );
                } else {
                  showDialog(
                    barrierDismissible: false,
                    context: context, 
                    builder: (BuildContext context) => MyOptionsDialog(title: "Attenzione", bodyText: "Sei sicuro di voler creare un nuovo agente?", rightButtonText: "Si", rightButtonColor: context.tertiary, onPressRightButton: () async {await aggiungiAgente(context);}, leftButtonText: "No", leftButtonColor: context.secondary, onPressLeftButton: (){Navigator.pop(context);})
                  );
                }
              }, color: context.tertiary,),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> aggiungiAdmin(BuildContext context) async {
    String? idAgenziaUtenteLoggato = await recuperaAgenzia();

    Future<bool> isAllOk = register(newAdminNomeController.text, newAdminCognomeController.text, newAdminMailController.text, newAdminPasswordController.text, TipoRuolo.ADMIN, idAgenziaUtenteLoggato);
    if (await isAllOk) {
      showDialog(
        barrierDismissible: false,
        context: context, 
        builder: (BuildContext context) => MyInfoDialog(title: 'Registrazione Completata', bodyText: 'Hai aggiunto con successo un nuovo admin', buttonText: 'Ok', onPressed: (){Navigator.pop(context);Navigator.pop(context);Navigator.pushNamedAndRemoveUntil(context, '/ControllorePagineAgente', (r) => false);})
      );
    } else {
      showDialog(
        barrierDismissible: false,
        context: context, 
        builder: (BuildContext context) => MyInfoDialog(title: 'Errore', bodyText: 'Qualcosa è andato storto. Riprova :/', buttonText: 'Ok', onPressed: (){Navigator.pop(context);})
      );
    }
  }

  Future<String?> recuperaAgenzia() async {
    String? subUtenteLoggato = await AWSServices().recuperaSubUtenteLoggato();
    String? idAgenziaUtenteLoggato;
    if (subUtenteLoggato != null){
      idAgenziaUtenteLoggato = await UtenteService.recuperaAgenziaDaUtenteSub(subUtenteLoggato);
    }
    return idAgenziaUtenteLoggato;
  }

  Future<void> aggiungiAgente(BuildContext context) async {
    String? idAgenziaUtenteLoggato = await recuperaAgenzia();
    
    Future<bool> isAllOk = register(newAdminNomeController.text, newAdminCognomeController.text, newAdminMailController.text, newAdminPasswordController.text, TipoRuolo.AGENTE, idAgenziaUtenteLoggato);
    if (await isAllOk) {
      showDialog(
        barrierDismissible: false,
        context: context, 
        builder: (BuildContext context) => MyInfoDialog(title: 'Registrazione Completata', bodyText: 'Hai aggiunto con successo un nuovo agente', buttonText: 'Ok', onPressed: (){Navigator.pop(context);Navigator.pop(context);Navigator.pushNamedAndRemoveUntil(context, '/ControllorePagineAgente', (r) => false);})
      );
    } else {
      showDialog(
        barrierDismissible: false,
        context: context, 
        builder: (BuildContext context) => MyInfoDialog(title: 'Errore', bodyText: 'Qualcosa è andato storto. Riprova :/', buttonText: 'Ok', onPressed: (){Navigator.pop(context);})
      );
    }
  }
}