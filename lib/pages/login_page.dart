import 'package:domus_app/services/aws_cognito.dart';
import 'package:domus_app/utils/my_buttons_widgets.dart';
import 'package:domus_app/utils/my_pop_up_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/my_text_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String? userGroup;
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
              onPressed: ()
                async {

                  String? group = await login(mailController.text, passwordController.text);
                  if (group != null){
                    setState(() {
                      userGroup = group;
                    });
                  }
                  
                  if (userGroup == 'admin'){
                    debugPrint('Admin action');
                  } else if (userGroup == 'cliente') {
                    debugPrint('Cliente action');
                    Navigator.pushNamedAndRemoveUntil(context, '/HomePage', (r) => false);
                  } else {
                    debugPrint('Errore Action');
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => MyInfoDialog(title: 'Errore', bodyText: 'Campi non validi. Riprovare', buttonText: 'Ok', onPressed: () {Navigator.pop(context);}));
                  }
                },
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