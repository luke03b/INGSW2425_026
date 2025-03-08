import 'dart:async';
import 'package:domus_app/amazon_services/aws_cognito.dart';
import 'package:domus_app/ui_elements/theme/theme_provider.dart';
import 'package:domus_app/ui_elements/theme/ui_constants.dart';
import 'package:domus_app/ui_elements/utils/my_buttons_widgets.dart';
import 'package:domus_app/ui_elements/utils/my_countdown_timer_widgets.dart';
import 'package:domus_app/ui_elements/utils/my_pop_up_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../ui_elements/utils/my_text_widgets.dart';

class PasswordDimenticataPage extends StatefulWidget {
  const PasswordDimenticataPage({super.key});

  @override
  State<PasswordDimenticataPage> createState() => _PasswordDimenticataPageState();
}

class _PasswordDimenticataPageState extends State<PasswordDimenticataPage> {

  String? userGroup;
  TextEditingController mailController = TextEditingController();
  TextEditingController codiceController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isPasswordFieldVisible = false;
  bool _isInviaCodiceBtnVisible = true;
  bool _isEmailTextFieldOnlyReadable = false;

  void _togglePasswordVisibile(){
    setState(() {
      _isPasswordFieldVisible = !_isPasswordFieldVisible;
    });
  }

  void _toggleInviaCodiceBtnVisibile(){
    setState(() {
      _isInviaCodiceBtnVisible = !_isInviaCodiceBtnVisible;
    });
  }

  void _setEmailTextFieldOnlyReadable(){
    setState(() {
      _isEmailTextFieldOnlyReadable = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String? emailFromLogin = ModalRoute.of(context)?.settings.arguments as String?;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    Color coloriScritte = context.outline;
    return Scaffold(
      backgroundColor: context.surface,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Spacer(flex: 5),
              //Logo
              SafeArea(child: themeProvider.themeMode == ThemeMode.light ? Image.asset('lib/assets/HouseHunter.png', height: 140) : Image.asset('lib/assets/HouseHunterChiaro.png', height: 140)),
              const Spacer(flex: 5),
        
              //mailTextField
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.92,
                child: TextFormField(
                        cursorColor: context.onSecondary,
                        readOnly: _isEmailTextFieldOnlyReadable,
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
                          hintText: emailFromLogin ?? "email",
                          iconColor: coloriScritte,
                          icon: Icon(Icons.person),
                        ),
                  )),
              const Spacer(flex: 1),

              Visibility(
                visible: _isInviaCodiceBtnVisible,
                child: MyTextButtonWidget(
                  text: "invia codice", 
                  onPressed: () async {
                    if (!mounted) return;
                    Future<bool> isAllOk = AWSServices().startPasswordDimenticataProcedure(mailController.text);
                    if (await isAllOk){
                      _setEmailTextFieldOnlyReadable();
                      _togglePasswordVisibile();
                      _toggleInviaCodiceBtnVisibile();
                    } else {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) => MyInfoDialog(title: 'Errore', bodyText: 'Controlla i campi e riprova', buttonText: 'Ok', onPressed: (){Navigator.pop(context);}));
                    }
                  },
                  colore: coloriScritte,
                ),
              ),
              //codiceTextField
              Visibility(
                visible: _isPasswordFieldVisible,
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.92,
                  child: MyTextFieldPrefixIcon(controller: codiceController, text: "inserisci codice", icon: Icon(Icons.numbers), color: coloriScritte,)),
              ),
              const Spacer(flex: 1),

              Visibility(
                visible: _isPasswordFieldVisible,
                child: Center(
                  child: CountdownTimer(totalTime: 60, onPressed: () async {
                    if (!mounted) return;
                    Future<bool> isAllOk = AWSServices().startPasswordDimenticataProcedure(mailController.text);
                    if (await isAllOk){
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) => MyInfoDialog(title: 'Codice reinviato', bodyText: 'Abbiamo reinviato il codice a ${mailController.text}', buttonText: 'Ok', onPressed: (){Navigator.pop(context);}));
                    } else {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) => MyInfoDialog(title: 'Errore', bodyText: 'Controlla i campi e riprova', buttonText: 'Ok', onPressed: (){Navigator.pop(context);}));
                    }
                  },),
                ),
              ),
              const Spacer(flex: 1),

              //passwordTextField
              Visibility(
                visible: _isPasswordFieldVisible,
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.92,
                  child: MyPasswordFieldWidget(controller: passwordController, text: "nuova password", icon: Icon(Icons.lock), color: coloriScritte,)),
              ),
              const Spacer(flex: 1),


              const Spacer(flex: 8),

              Row(
                children: [
                  SizedBox(width: 10,),
                  Expanded(
                    child: MyElevatedButtonWidget(text: "Indietro",
                    onPressed: (){Navigator.pop(context);},
                      color: context.secondary),
                  ),
                  
                  SizedBox(width: 10,),
                  
                  Visibility(
                    visible: _isPasswordFieldVisible,
                    child: Expanded(
                      child: MyElevatedButtonWidget(text: "Conferma",
                      onPressed: ()
                         async {
                          Future<bool> isAllOk = AWSServices().endPasswordDimenticataProcedure(mailController.text, codiceController.text, passwordController.text);
                          if (await isAllOk){
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) => MyInfoDialog(title: 'Password cambiata', bodyText: 'Verrai reinderizzato al Login', buttonText: 'Ok', onPressed: (){Navigator.pop(context); Navigator.pop(context);}));
                          } else {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) => MyInfoDialog(title: 'Errore', bodyText: 'Controlla i campi e riprova', buttonText: 'Ok', onPressed: (){Navigator.pop(context);}));
                          }
                         },
                        color: context.tertiary),
                    ),
                  ),
                  SizedBox(width: 10,),
                ],
              ),

              const Spacer(flex: 8),
            ],
          ),
        ),
      ),
    );
  }
}