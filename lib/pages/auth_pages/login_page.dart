import 'package:domus_app/costants/costants.dart';
import 'package:domus_app/amazon_services/aws_cognito.dart';
import 'package:domus_app/ui_elements/theme/theme_provider.dart';
import 'package:domus_app/ui_elements/theme/ui_constants.dart';
import 'package:domus_app/ui_elements/utils/my_buttons_widgets.dart';
import 'package:domus_app/ui_elements/utils/my_pop_up_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../ui_elements/utils/my_text_widgets.dart';

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
              SafeArea(child: themeProvider.themeMode == ThemeMode.light ? Image.asset('lib/assets/HouseHunter.png', height: 140) : Image.asset('lib/assets/HouseHunterChiaro.png', height: 140)),
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
                    text: "Password dimenticata?", 
                    onPressed: (){
                      if(mailController.text != ""){
                        Navigator.pushNamed(context, '/PasswordDimenticataPage', arguments: mailController.text);
                      } 
                      else {
                        Navigator.pushNamed(context, '/PasswordDimenticataPage',);
                      }
                      }, 
                    colore: coloriScritte)
                ],
              ),

              const Spacer(flex: 8),

              //LoginButton
              MyElevatedButtonWidget(text: "Login",
              onPressed: ()
                async { await loginECambioPagina(context);},
                color: context.tertiary),

              const Spacer(flex: 8),

              Row(
                children: [
                  Expanded(child: Divider(height: 50, thickness: 2, indent: 20, endIndent: 10, color: coloriScritte,)),
                  Text("oppure", style: TextStyle(color: coloriScritte),),
                  Expanded(child: Divider(height: 50, thickness: 2, indent: 10, endIndent: 20, color: coloriScritte,)),
                ],
              ),

              const Spacer(flex: 1),
        
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 375,
                    child: IconButton(onPressed: () async {
                        bool isAllOk = await AWSServices().signInWithGoogle();
                        if (isAllOk) {
                          Navigator.pop(context); Navigator.pushNamedAndRemoveUntil(context, '/HomePage', (r) => false);
                        } else {
                          showDialog(
                            barrierDismissible: false,
                            context: context, 
                            builder: (BuildContext context) => MyInfoDialog(title: 'Errore', bodyText: 'Qualcosa è andato storto. Riprova :/', buttonText: 'Ok', onPressed: (){Navigator.pop(context);})
                          );
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(context.surface),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: BorderSide(color: context.onSecondary),
                          ),
                        ),
                      ),
                      icon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Login con Google",
                            style: TextStyle(
                              color: context.onSecondary,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(width: 8),
                          SvgPicture.asset(
                            'lib/assets/google_logo.svg',
                            width: 25,
                            colorFilter: ColorFilter.mode(context.onSecondary, BlendMode.srcIn),
                          ),
                        ]
                      )
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 10),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loginECambioPagina(BuildContext context) async {
    String? group = await login(mailController.text, passwordController.text);
    if (group != null){
      setState(() {
        userGroup = group;
      });
    }
    
    if (userGroup == TipoRuolo.ADMIN || userGroup == TipoRuolo.AGENTE){
      debugPrint('Admin action or Agente action');
      Navigator.pushNamedAndRemoveUntil(context, '/ControllorePagineAgente', (r) => false);
    } else if (userGroup == TipoRuolo.CLIENTE) {
      debugPrint('Cliente action');
      Navigator.pushNamedAndRemoveUntil(context, '/HomePage', (r) => false);
    } else {
      debugPrint('Errore Action');
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => MyInfoDialog(title: 'Errore', bodyText: 'Campi non validi. Riprovare', buttonText: 'Ok', onPressed: () {Navigator.pop(context);}));
    }
  }
}