import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscured = false;

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
              child: SafeArea(child: SvgPicture.asset('lib/assets/domus_logo.svg', width: 200,)),
            ),
      
            //mailTextField
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 30.0, top: 50.0),
              child: TextFormField(
                controller: mailController,
                style: TextStyle(
                  fontSize: 18.0, 
                  // color: Theme.of(context).colorScheme.surface,
                ),
                decoration: InputDecoration(
                  hintText: "email",
                  // contentPadding: EdgeInsets.only(left: 10.0),
                  icon: Icon(Icons.person),
                  // iconColor: Theme.of(context).colorScheme.surface,
                  // enabledBorder: UnderlineInputBorder(
                  //   borderSide: BorderSide(color: Theme.of(context).colorScheme.surface),),
                  // disabledBorder: UnderlineInputBorder(
                  //   borderSide: BorderSide(color: Theme.of(context).colorScheme.surface),),
                  // focusedBorder: UnderlineInputBorder(
                  //   borderSide: BorderSide(color: Theme.of(context).colorScheme.surface, width: 2.0),),
                  // errorBorder: UnderlineInputBorder(
                  //   borderSide: BorderSide(color: Colors.red, width: 2.0),),
                ),
              ),
            ),
      
            //passwordTextField
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 30.0, top: 10.0),
              child: TextFormField(
                controller: passwordController,
                style: TextStyle(fontSize: 18.0),
                obscureText: _isObscured,
                decoration: InputDecoration(
                  hintText: "password",
                  // contentPadding: EdgeInsets.only(left: 10.0),
                  icon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    }, 
                    icon: _isObscured ? Icon(Icons.visibility) : Icon(Icons.visibility_off))
                ),
              ),
            ),
      
            //passwordDimenticataButton
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: (){}, 
                    child: Text("Non hai un account?",
                      style: TextStyle(
                        decoration: TextDecoration.underline),
                        ),
                  ),
                  TextButton(
                    onPressed: (){}, 
                    child: Text("Password dimenticata?",
                      style: TextStyle(
                        decoration: TextDecoration.underline),
                        ),
                  ),
              
                ],
              ),
            ),
      
            //LoginButton
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/ProvaPage');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  fixedSize: Size(MediaQuery.sizeOf(context).width/2, MediaQuery.sizeOf(context).height/18),
                ),
                child: Text("Login",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 18.0),
                ),
              ),
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
}