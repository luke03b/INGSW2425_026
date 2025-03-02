import 'package:domus_app/services/aws_cognito.dart';
import 'package:domus_app/ui_elements/theme/ui_constants.dart';
import 'package:domus_app/ui_elements/utils/my_buttons_widgets.dart';
import 'package:domus_app/ui_elements/utils/my_pop_up_widgets.dart';
import 'package:domus_app/ui_elements/utils/my_text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CambiaPasswordPage extends StatefulWidget {
  final String? emailUtente;
  const CambiaPasswordPage({
    super.key,
    required this.emailUtente,
  });

  @override
  State<CambiaPasswordPage> createState() => _CambiaPasswordPageState();
}

class _CambiaPasswordPageState extends State<CambiaPasswordPage> {
  TextEditingController mailController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  changePassword(String email, String oldPassword, String newPassword) => AWSServices().cambiaPasswordUtenteLoggato(email, oldPassword, newPassword);

  @override
  Widget build(BuildContext context) {
    Color coloriScritte = context.outline;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: context.onSecondary,
        ),
        title: Text("Cambia password", style: TextStyle(color: context.onSecondary),),
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
                child: MyPasswordFieldWidget(controller: oldPasswordController, text: "vecchia password", icon: Icon(FontAwesomeIcons.lockOpen), color: coloriScritte,)),
              const Spacer(flex: 1),
        
              //passwordTextField
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.92,
                child: MyPasswordFieldWidget(controller: newPasswordController, text: "nuova password", icon: Icon(FontAwesomeIcons.lock), color: coloriScritte,)),

              const Spacer(flex: 3),

              //LoginButton
              MyElevatedButtonWidget(text: "Cambia password",
              onPressed: ()
                async {await cambiaPassword(context);},
                color: context.tertiary),

              const Spacer(flex: 8),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> cambiaPassword(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => MyOptionsDialog(
                                          title: "Cambia password", 
                                          bodyText: "Sei sicuro di voler procedere? All'account con email ${widget.emailUtente} verrà cambiata la password e sarai reindirizzato al login.", 
                                          leftButtonText: "No", 
                                          leftButtonColor: Colors.grey, 
                                          rightButtonText: "Si", 
                                          rightButtonColor: context.tertiary, 
                                          onPressLeftButton: (){Navigator.pop(context);}, 
                                          onPressRightButton: () async {
                                            bool isPasswordChanged = await changePassword(widget.emailUtente ?? mailController.text, oldPasswordController.text, newPasswordController.text);
                                            if(isPasswordChanged){
                                              Navigator.pushNamedAndRemoveUntil(context, '/LoginPage', (r) => false);
                                            } else {
                                              showDialog(context: context, builder: (BuildContext content) => MyInfoDialog(title: "Errore", bodyText: "Qualcosa è andato storto con il cambio password dell'account di ${widget.emailUtente}.", buttonText: "Ok", onPressed: (){Navigator.pop(context);})
                                              );
                                            }
                                          }
                                        )
    );
  }
}