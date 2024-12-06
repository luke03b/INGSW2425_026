import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/my_text_widgets.dart';
import '../utils/my_buttons_widgets.dart';

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              //Logo
              Padding(
                padding: const EdgeInsets.only(top: 70.0),
                // child: SafeArea(child: SvgPicture.asset('lib/assets/house_logo.svg', width: 150,)),
                child: Image.asset('lib/assets/HouseHunter.png', height: 140,),
              ),
        
              //nomeTextField
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 30.0, top: 50.0),
                child: MyTextFieldPrefixIcon(controller: nomeController, text: "nome", icon: const Icon(Icons.face))
              ),
        
              //cognomeTextField
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 30.0, top: 10.0),
                child: MyTextFieldPrefixIcon(controller: cognomeController, text: "cognome", icon: const Icon(FontAwesomeIcons.idCard))
              ),
        
              //emailTextField
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 30.0, top: 10.0),
                child: MyTextFieldPrefixIcon(controller: mailController, text: "email", icon: const Icon(Icons.person))
              ),
        
              //passwordTextField
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 30.0, top: 10.0),
                child: MyPasswordFieldWidget(controller: passwordController, text: "password", icon: const Icon(Icons.lock))
              ),
        
              //Altre Opzioni
              MyTextButtonWidget(text: "Hai già un account?", 
                onPressed: (){Navigator.pushNamedAndRemoveUntil(context, '/LoginPage', (r) => false);}),
        
              //RegistratiButton
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: MyElevatedButtonWidget(text: "Registrati", onPressed: (){}),
              ),
        
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Text("------------------ oppure ------------------"),
              ),
        
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(onPressed: (){}, icon: SvgPicture.asset('lib/assets/google_logo.svg', width: 40, ),),
                    IconButton(onPressed: (){}, icon: SvgPicture.asset('lib/assets/facebook_logo.svg', width: 40,)),
                    IconButton(onPressed: (){}, icon: SvgPicture.asset('lib/assets/apple_logo.svg', width: 40,),)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}