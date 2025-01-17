import 'package:domus_app/services/aws_cognito.dart';
import 'package:domus_app/utils/my_buttons_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/my_text_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  login(String email, String password) => AWSServices().signIn(email, password);

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
        
              //passwordTextField
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.92,
                child: MyPasswordFieldWidget(controller: passwordController, text: "password", icon: Icon(Icons.lock), color: coloriScritte,)),
              const Spacer(flex: 1),
        
              //Altre Opzioni
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyTextButtonWidget(
                    text: "Non hai un account?", 
                    onPressed: (){Navigator.pushNamedAndRemoveUntil(context, '/RegistrationPage', (r) => false);},
                    colore: coloriScritte,),
                  MyTextButtonWidget(
                    text: "Password dimenticata", 
                    onPressed: (){}, 
                    colore: coloriScritte)
                ],
              ),

              const Spacer(flex: 8),

              //LoginButton
              MyElevatedButtonWidget(text: "Login",
              onPressed: (){login(mailController.text, passwordController.text);},
              // onPressed: (){
              //   Navigator.pushNamedAndRemoveUntil(context, '/HomePage', (r) => false);
              //   showDialog(
              //     barrierDismissible: false,
              //     context: context,
              //     builder: (BuildContext context) => AlertDialog(
              //       title: Text("Login effettuato", style: TextStyle(fontSize: 25, color: Theme.of(context).colorScheme.outline),),
              //       content: Text("Login eseguito con successo! Ora puoi usare i servizi di HouseHunters! Enjoy :)", style: TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.outline)),
              //       actions: [
              //         ElevatedButton(
              //           style: ElevatedButton.styleFrom(
              //             backgroundColor: Theme.of(context).colorScheme.primary
              //           ),
              //           onPressed: (){
              //             Navigator.pop(context);
              //           }, 
              //           child: Text("Ok", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary,),)
              //         ),
              //       ],
              //     )
              //   );
              //   }, 
                color: Theme.of(context).colorScheme.tertiary),

              const Spacer(flex: 8),

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

              const Spacer(flex: 10),
            ],
          ),
        ),
      ),
    );
  }
}