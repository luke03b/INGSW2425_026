import 'package:domus_app/costants/costants.dart';
import 'package:domus_app/amazon_services/aws_cognito.dart';
import 'package:domus_app/ui_elements/theme/theme_provider.dart';
import 'package:domus_app/ui_elements/theme/ui_constants.dart';
import 'package:domus_app/ui_elements/utils/my_pop_up_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../ui_elements/utils/my_text_widgets.dart';
import '../../ui_elements/utils/my_buttons_widgets.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  TextEditingController cognomeController = TextEditingController();

  register(String nome, String cognome, String email, String password, String userGroup) => AWSServices().register(nome, cognome, email, password, userGroup, null);

  @override
  Widget build(BuildContext context) {
    Color coloriScritte = context.outline;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: context.surface,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Spacer(flex: 5),
              //Logo
              themeProvider.themeMode == ThemeMode.light ? Image.asset('lib/assets/HouseHunter.png', height: 140) : Image.asset('lib/assets/HouseHunterChiaro.png', height: 140,),
              const Spacer(flex: 5),

              //nomeTextField
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.92,
                child: MyTextFieldPrefixIcon(controller: nomeController, text: "nome", icon: const Icon(Icons.face), color: coloriScritte,)),
              const Spacer(),   

              //cognomeTextField
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.92,
                child: MyTextFieldPrefixIcon(controller: cognomeController, text: "cognome", icon: const Icon(FontAwesomeIcons.idCard), color: coloriScritte,)),
              const Spacer(),

              //emailTextField
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.92,
                child: MyTextFieldPrefixIcon(controller: mailController, text: "email", icon: const Icon(Icons.person), color: coloriScritte,)),
              const Spacer(),

              //passwordTextField
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.92,
                child: MyPasswordFieldWidget(controller: passwordController, text: "password", icon: const Icon(Icons.lock), color: coloriScritte,)),
              const Spacer(),

              //Altre Opzioni
              MyTextButtonWidget(text: "Hai già un account?", 
                onPressed: (){Navigator.pushNamedAndRemoveUntil(context, '/LoginPage', (r) => false);},
                colore: coloriScritte),
              const Spacer(flex: 5),

              //RegistratiButton
              MyElevatedButtonWidget(text: "Registrati", onPressed: () async{
                await registraETornaAlLogin(context);
              }, color: context.tertiary,),
              const Spacer(flex: 3),

              Row(
                children: [
                  Expanded(child: Divider(height: 50, thickness: 2, indent: 20, endIndent: 10, color: coloriScritte,)),
                  Text("oppure", style: TextStyle(color: coloriScritte),),
                  Expanded(child: Divider(height: 50, thickness: 2, indent: 10, endIndent: 20, color: coloriScritte,)),
                ],
              ),
              const Spacer(flex: 3),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(onPressed: (){}, icon: SvgPicture.asset('lib/assets/google_logo.svg', width: 40, ),),
                  IconButton(onPressed: (){}, icon: SvgPicture.asset('lib/assets/facebook_logo.svg', width: 40,)),
                  IconButton(onPressed: (){}, icon: SvgPicture.asset('lib/assets/apple_logo.svg', width: 40,),)
                ],
              ),
              const Spacer(flex: 5),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> registraETornaAlLogin(BuildContext context) async {
    Future<bool> isAllOk = register(nomeController.text, cognomeController.text, mailController.text, passwordController.text, TipoRuolo.CLIENTE);
    if (await isAllOk) {
      showDialog(
        barrierDismissible: false,
        context: context, 
        builder: (BuildContext context) => MyInfoDialog(title: 'Registrazione Completata', bodyText: 'Verrai reindirizzato al Login', buttonText: 'Ok', onPressed: (){Navigator.pop(context); Navigator.pushNamedAndRemoveUntil(context, '/LoginPage', (r) => false);})
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