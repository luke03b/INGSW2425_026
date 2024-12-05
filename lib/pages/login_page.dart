import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordObscured = true;

  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          children: [
            //Logo
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: SafeArea(child: SvgPicture.asset('lib/assets/house_logo.svg', width: 150,)),
            ),
      
            //mailTextField
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 30.0, top: 20.0),
              child: mailTextField(),
            ),
      
            //passwordTextField
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 30.0, top: 10.0),
              child: passwordTextField(),
            ),
      
            //Altre Opzioni
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  nonHaiUnAccountButton(context),
                  passwordDimenticataButton(),
                ],
              ),
            ),
      
            //LoginButton
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: loginButton(context),
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
              padding: const EdgeInsets.only(top: 120.0),
              child: SafeArea(child: Image.asset('lib/assets/houses_login.png')),
            ),
      
          ],
        ),
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

  TextButton passwordDimenticataButton() {
    return TextButton(
                  onPressed: (){}, 
                  child: Text("Password dimenticata?",
                    style: TextStyle(
                      decoration: TextDecoration.underline),
                      ),
                );
  }

  TextButton nonHaiUnAccountButton(BuildContext context) {
    return TextButton(
                  onPressed: (){
                    Navigator.pushNamedAndRemoveUntil(context, '/RegistrationPage', (r) => false);
                  }, 
                  child: Text("Non hai un account?",
                    style: TextStyle(
                      decoration: TextDecoration.underline),
                      ),
                );
  }

  ElevatedButton loginButton(BuildContext context) {
    return ElevatedButton(
              onPressed: (){},
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                fixedSize: Size(MediaQuery.sizeOf(context).width/2, MediaQuery.sizeOf(context).height/18),
              ),
              child: Text("Login",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 18.0),
              ),
            );
  }

  TextFormField passwordTextField() {
    return TextFormField(
              controller: passwordController,
              style: TextStyle(fontSize: 18.0),
              obscureText: _isPasswordObscured,
              decoration: InputDecoration(
                hintText: "password",
                // contentPadding: EdgeInsets.only(left: 10.0),
                icon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isPasswordObscured = !_isPasswordObscured;
                    });
                  }, 
                  icon: _isPasswordObscured ? Icon(Icons.visibility) : Icon(Icons.visibility_off))
              ),
            );
  }
}