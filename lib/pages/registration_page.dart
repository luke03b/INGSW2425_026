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
    Color coloriScritte = Theme.of(context).colorScheme.outline;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Spacer(flex: 5),
              //Logo
              Image.asset('lib/assets/HouseHunter.png', height: 140,),
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
              MyElevatedButtonWidget(text: "Registrati", onPressed: (){}, color: Theme.of(context).colorScheme.tertiary,),
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
}