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
                child: SafeArea(child: Image.asset('lib/assets/HouseHunter.png', height: 140,)),
              ),
        
              //mailTextField
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 30.0, top: 50.0),
                child: MyTextFieldPrefixIcon(controller: mailController, text: "email", icon: Icon(Icons.person))
              ),
        
              //passwordTextField
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 30.0, top: 10.0),
                child: MyPasswordFieldWidget(controller: passwordController, text: "password", icon: Icon(Icons.lock))
              ),
        
              //Altre Opzioni
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyTextButtonWidget(text: "Non hai un account?", 
                    onPressed: (){Navigator.pushNamedAndRemoveUntil(context, '/RegistrationPage', (r) => false);}),
                  MyTextButtonWidget(text: "Password dimenticata", onPressed: (){})
                ],
              ),
        
              //LoginButton
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: MyElevatedButtonWidget(text: "Login", onPressed: (){Navigator.pushNamedAndRemoveUntil(context, '/HomePage', (r) => false);}),
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