import 'package:domus_app/services/aws_cognito.dart';
import 'package:domus_app/utils/my_buttons_widgets.dart';
import 'package:domus_app/utils/my_pop_up_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/my_text_widgets.dart';

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

  void _togglePasswordVisibile(){
    setState(() {
      _isPasswordFieldVisible = !_isPasswordFieldVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color coloriScritte = Theme.of(context).colorScheme.outline;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Spacer(flex: 5),
              //Logo
              SafeArea(child: Image.asset('lib/assets/HouseHunter.png', height: 140)),
              const Spacer(flex: 5),
        
              //mailTextField
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.92,
                child: MyTextFieldPrefixIcon(controller: mailController, text: "email", icon: Icon(Icons.person), color: coloriScritte,)),
              const Spacer(flex: 1),

              //codiceTextField
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.92,
                child: MyTextFieldPrefixIcon(controller: codiceController, text: "inserisci codice", icon: Icon(Icons.numbers), color: coloriScritte,)),
              const Spacer(flex: 1),

              MyTextButtonWidget(
                text: "invia codice", 
                onPressed: () async {
                  Future<bool> isAllOk = AWSServices().startPasswordDimenticataProcedure(mailController.text);
                  if (await isAllOk){
                    _togglePasswordVisibile();
                  } else {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => MyInfoDialog(title: 'Errore', bodyText: 'Controlla i campi e riprova', buttonText: 'Ok', onPressed: (){Navigator.pop(context);}));
                  }
                },
                colore: coloriScritte,
              ),
        
              //passwordTextField
              Visibility(
                visible: _isPasswordFieldVisible,
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.92,
                  child: MyPasswordFieldWidget(controller: passwordController, text: "nuova password", icon: Icon(Icons.lock), color: coloriScritte,)),
              ),
              const Spacer(flex: 1),


              const Spacer(flex: 8),

              //LoginButton
              Row(
                children: [
                  SizedBox(width: 10,),
                  Expanded(
                    child: MyElevatedButtonWidget(text: "Indietro",
                    onPressed: (){Navigator.pop(context);},
                      color: Theme.of(context).colorScheme.primary),
                  ),
                  
                  SizedBox(width: 10,),
                  
                  Expanded(
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
                      color: Theme.of(context).colorScheme.tertiary),
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