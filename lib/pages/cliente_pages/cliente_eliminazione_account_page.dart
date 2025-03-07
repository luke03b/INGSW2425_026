import 'package:domus_app/back_end_communication/class_services/utente_service.dart';
import 'package:domus_app/services/aws_cognito.dart';
import 'package:domus_app/ui_elements/theme/ui_constants.dart';
import 'package:domus_app/ui_elements/utils/my_buttons_widgets.dart';
import 'package:domus_app/ui_elements/utils/my_pop_up_widgets.dart';
import 'package:domus_app/ui_elements/utils/my_text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClienteEliminazioneAccountPage extends StatefulWidget {
  final String? emailUtente;
  const ClienteEliminazioneAccountPage({
    super.key,
    required this.emailUtente,
  });

  @override
  State<ClienteEliminazioneAccountPage> createState() => _ClienteEliminazioneAccountPageState();
}

class _ClienteEliminazioneAccountPageState extends State<ClienteEliminazioneAccountPage> {
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  
  deleteUser(String email, String password) => AWSServices().eliminaUtenteLoggato(email, password);

  @override
  Widget build(BuildContext context) {
    Color coloriScritte = context.outline;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: context.onSecondary,
        ),
        title: Text("Elimina account", style: TextStyle(color: context.onSecondary),),
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
        
              //mailTextField
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.92,
                child: TextFormField(
                        readOnly: true,
                        controller: mailController,
                        style: TextStyle(
                          fontSize: 18.0, 
                          color: coloriScritte,
                        ),
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: context.outline), // Colore della linea quando non è in focus
                          ),
                            focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: context.onSecondary, width: 2.0), // Colore della linea quando scrivi
                          ),
                          hintStyle: TextStyle(color: coloriScritte),
                          hintText: widget.emailUtente ?? "email",
                          iconColor: coloriScritte,
                          icon: Icon(Icons.person),
                        ),
                  )),
              const Spacer(flex: 1),
        
              //passwordTextField
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.92,
                child: MyPasswordFieldWidget(controller: passwordController, text: "password", icon: Icon(Icons.lock), color: coloriScritte,)),

              const Spacer(flex: 3),

              //LoginButton
              MyElevatedButtonWidget(text: "Elimina account",
              onPressed: ()
                async { await eliminaAccount(context);},
                color: context.error),

              const Spacer(flex: 8),

              Row(
                children: [
                  Expanded(child: Divider(height: 50, thickness: 2, indent: 20, endIndent: 10, color: coloriScritte,)),
                  Text("oppure", style: TextStyle(color: coloriScritte),),
                  Expanded(child: Divider(height: 50, thickness: 2, indent: 10, endIndent: 20, color: coloriScritte,)),
                ],
              ),

              const Spacer(flex: 1),
        
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 375,
                    child: IconButton(onPressed: () async {
                        bool isAllOk = await AWSServices().signInWithGoogle();
                        if (await isAllOk) {
                          Navigator.pop(context); Navigator.pushNamedAndRemoveUntil(context, '/HomePage', (r) => false);
                        } else {
                          showDialog(
                            barrierDismissible: false,
                            context: context, 
                            builder: (BuildContext context) => MyInfoDialog(title: 'Errore', bodyText: 'Qualcosa è andato storto. Riprova :/', buttonText: 'Ok', onPressed: (){Navigator.pop(context);})
                          );
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(context.surface),
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: BorderSide(color: context.onSecondary),
                            ),
                          ),
                        ),
                        icon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Login con Google",
                              style: TextStyle(
                                color: context.onSecondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(width: 8),
                            SvgPicture.asset(
                              'lib/assets/google_logo.svg',
                              width: 25,
                              colorFilter: ColorFilter.mode(context.onSecondary, BlendMode.srcIn),
                            ),
                          ]
                        )
                    ),
                  )
                ],
              ),

              const Spacer(flex: 10),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> eliminaAccount(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => MyOptionsDialog(
                                          title: "Elimina account", 
                                          bodyText: "Sei sicuro di voler procedere? l'account con email ${widget.emailUtente} verrà eliminato e sarai reindirizzato al login.", 
                                          leftButtonText: "No", 
                                          leftButtonColor: context.secondary, 
                                          rightButtonText: "Si", 
                                          rightButtonColor: context.error, 
                                          onPressLeftButton: (){Navigator.pop(context);}, 
                                          onPressRightButton: () async {
                                            bool isUserDeleted = await deleteUser(widget.emailUtente ?? mailController.text, passwordController.text);
                                            isUserDeleted &= await UtenteService.eliminaUtenteDalNostroDb(await AWSServices().recuperaSubUtenteLoggato());
                                            final prefs = await SharedPreferences.getInstance();
                                            await prefs.remove('userToken');
                                            if(isUserDeleted){
                                              Navigator.pushNamedAndRemoveUntil(context, '/LoginPage', (r) => false);
                                            } else {
                                              showDialog(context: context, builder: (BuildContext content) => MyInfoDialog(title: "Errore", bodyText: "Qualcosa è andato storto con l'eliminazione dell'account di ${widget.emailUtente}.", buttonText: "Ok", onPressed: (){Navigator.pop(context);})
                                              );
                                            }
                                          }
                                        )
    );
  }

}