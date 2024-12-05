import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool _isObscured = false;

  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  TextEditingController cognomeController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          children: [
            //Logo
            // Padding(
            //   padding: const EdgeInsets.only(top: 15.0),
            //   child: SafeArea(child: SvgPicture.asset('lib/assets/domus_logo.svg', width: 200,)),
            // ),
      
            //nomeTextField
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 30.0, top: 70.0),
              child: nomeTextField(),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 30.0, top: 10.0),
              child: cognomeTextField(),
            ),


            //mailTextField
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 30.0, top: 10.0),
              child: mailTextField(),
            ),
      
            //passwordTextField
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 30.0, top: 10.0),
              child: passwordTextField(),
            ),
      
            //passwordDimenticataButton
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  haiGiaUnAccountButton(context),    
                ],
              ),
            ),
      
            //RegistrationButton
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: registratiButton(context),
            ),
      
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text("------------------ oppure ------------------"),
            ),
      
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(onPressed: (){}, icon: SvgPicture.asset('lib/assets/google_logo.svg', width: 50, ),),
                  IconButton(onPressed: (){}, icon: SvgPicture.asset('lib/assets/facebook_logo.svg', width: 50,)),
                  IconButton(onPressed: (){}, icon: SvgPicture.asset('lib/assets/apple_logo.svg', width: 50,),)
                ],
              ),
            ),
      
            Padding(
              padding: const EdgeInsets.only(top: 108.0),
              child: SafeArea(child: Image.asset('lib/assets/houses_login.png')),
            ),

          ],
        ),
      ),
    );
  }

  ElevatedButton registratiButton(BuildContext context) {
    return ElevatedButton(
              onPressed: (){},
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                fixedSize: Size(MediaQuery.sizeOf(context).width/2, MediaQuery.sizeOf(context).height/18),
              ),
              child: Text("Registrati",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 18.0),
              ),
            );
  }

  TextButton haiGiaUnAccountButton(BuildContext context) {
    return TextButton(
                  onPressed: (){
                    Navigator.pushNamedAndRemoveUntil(context, '/LoginPage', (r) => false);
                  }, 
                  child: Text("Hai già un account?",
                    style: TextStyle(
                      decoration: TextDecoration.underline),
                      ),
                );
  }

  TextFormField passwordTextField() {
    return TextFormField(
              controller: passwordController,
              style: TextStyle(fontSize: 18.0),
              obscureText: _isObscured,
              decoration: InputDecoration(
                hintText: "password",
                icon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  }, 
                  icon: _isObscured ? Icon(Icons.visibility) : Icon(Icons.visibility_off))
              ),
            );
  }

  TextFormField mailTextField() {
    return TextFormField(
              controller: mailController,
              style: TextStyle(
                fontSize: 18.0,
              ),
              decoration: InputDecoration(
                hintText: "email",
                icon: Icon(Icons.person),
              ),
            );
  }

  TextFormField cognomeTextField() {
    return TextFormField(
              controller: cognomeController,
              style: TextStyle(fontSize: 18.0),
              obscureText: _isObscured,
              decoration: InputDecoration(
                hintText: "cognome",
                icon: Icon(Icons.recent_actors),
              ),
            );
  }

  SafeArea nomeTextField() {
    return SafeArea(
              child: TextFormField(
                controller: nomeController,
                style: TextStyle(fontSize: 18.0),
                obscureText: _isObscured,
                decoration: InputDecoration(
                  hintText: "nome",
                  icon: Icon(Icons.face),
                ),
              ),
            );
  }
}