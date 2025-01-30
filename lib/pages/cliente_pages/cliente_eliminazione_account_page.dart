import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:domus_app/services/aws_cognito.dart';
import 'package:domus_app/utils/my_buttons_widgets.dart';
import 'package:domus_app/utils/my_pop_up_widgets.dart';
import 'package:domus_app/utils/my_text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClienteEliminazioneAccountPage extends StatefulWidget {
  final String? emailUtente;
  const ClienteEliminazioneAccountPage({
    super.key,
    required this.emailUtente,
  });

  @override
  State<ClienteEliminazioneAccountPage> createState() => _ClienteEliminazioneAccountPageState();
}

class _ClienteEliminazioneAccountPageState extends State<ClienteEliminazioneAccountPage> {
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  login(String email, String password) => AWSServices().signIn(email, password);
  deleteUser(String email, String password) => AWSServices().eliminaUtenteLoggato(email, password);

  @override
  Widget build(BuildContext context) {
    Color coloriScritte = Theme.of(context).colorScheme.outline;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.surface,
        ),
        title: Text("Elimina account", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 5,
        shadowColor: Colors.black,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Spacer(flex: 5),
        
              //mailTextField
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.92,
                child: TextFormField(
                        readOnly: true,
                        controller: mailController,
                        style: TextStyle(
                          fontSize: 18.0, 
                          color: coloriScritte,
                        ),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: coloriScritte),
                          hintText: widget.emailUtente ?? "email",
                          iconColor: coloriScritte,
                          icon: Icon(Icons.person),
                        ),
                  )),
              const Spacer(flex: 1),
        
              //passwordTextField
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.92,
                child: MyPasswordFieldWidget(controller: passwordController, text: "password", icon: Icon(Icons.lock), color: coloriScritte,)),

              const Spacer(flex: 8),

              //LoginButton
              MyElevatedButtonWidget(text: "Elimina account",
              onPressed: ()
                async { await eliminaAccount(context);},
                color: Theme.of(context).colorScheme.error),

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
                  IconButton(onPressed: () async {
                      bool isAllOk = await AWSServices().signInWithGoogle();
                      if (await isAllOk) {
                        Navigator.pop(context); Navigator.pushNamedAndRemoveUntil(context, '/HomePage', (r) => false);
                      } else {
                        showDialog(
                          barrierDismissible: false,
                          context: context, 
                          builder: (BuildContext context) => MyInfoDialog(title: 'Errore', bodyText: 'Qualcosa è andato storto. Riprova :/', buttonText: 'Ok', onPressed: (){Navigator.pop(context);})
                        );
                      }
                    },  icon: SvgPicture.asset('lib/assets/google_logo.svg', width: 40, ),),
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

  Future<void> eliminaAccount(BuildContext context) async {
    debugPrint('Cliente action');
    showDialog(
      context: context,
      builder: (BuildContext context) => MyOptionsDialog(
                                          title: "Elimina account", 
                                          bodyText: "Sei sicuro di voler procedere? l'account con email ${widget.emailUtente} verrà eliminato e sarai reindirizzato al login.", 
                                          leftButtonText: "No", 
                                          leftButtonColor: Colors.grey, 
                                          rightButtonText: "Si", 
                                          rightButtonColor: Theme.of(context).colorScheme.error, 
                                          onPressLeftButton: (){Navigator.pop(context);}, 
                                          onPressRightButton: () async {
                                            bool isUserDeleted = await deleteUser(widget.emailUtente ?? mailController.text, passwordController.text);
                                            safePrint("\n\n\n\n\n\n");
                                            safePrint(isUserDeleted);
                                            safePrint("\n\n\n\n\n\n");
                                            if(isUserDeleted){
                                              Navigator.pushNamedAndRemoveUntil(context, '/LoginPage', (r) => false);
                                            } else {
                                              showDialog(context: context, builder: (BuildContext content) => MyInfoDialog(title: "Errore", bodyText: "Qualcosa è andato storto con l'eliminazione dell'account di ${widget.emailUtente}.", buttonText: "Ok", onPressed: (){Navigator.pop(context);})
                                              );
                                            }
                                          }
                                        )
    );
  }

}