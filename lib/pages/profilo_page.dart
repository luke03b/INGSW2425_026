import 'package:domus_app/pages/auth_pages/login_page.dart';
import 'package:domus_app/services/aws_cognito.dart';
import 'package:domus_app/utils/my_buttons_widgets.dart';
import 'package:domus_app/utils/my_pop_up_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfiloPage extends StatefulWidget {
  const ProfiloPage({super.key});

  @override
  State<ProfiloPage> createState() => _ProfiloPageState();
}

class _ProfiloPageState extends State<ProfiloPage> {
  logout() => AWSServices().signOut();
  String? nomeUtenteLoggato;
  String? cognomeUtenteLoggato;
  String? mailUtenteLoggato;

   @override
  void initState() {
    super.initState();
    recuperaCredenzialiUtenteLoggato();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("House Hunters", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 5,
        shadowColor: Colors.black,
      ),
      body: Column(
        children: [
          Center(
            child: Card(
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, size: 125, color: Theme.of(context).colorScheme.outline,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("Nome: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.outline),),
                              Text(nomeUtenteLoggato ?? "Non disponibile", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.outline),),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Cognome: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.outline),),
                              Text(cognomeUtenteLoggato ?? "Non disponibile", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.outline),),
                            ],
                          ),
                          
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: MediaQuery.sizeOf(context).height/60,),
                      Text("Email: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.outline),),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(mailUtenteLoggato ?? "Non disponibile", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.outline),))),
                      ),
                    ],
                    ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height/60,
                  )
                ],
              ),
            ),
          ),
    

          SizedBox(height: MediaQuery.sizeOf(context).height/2),
          MyElevatedButtonWidget(
            text: "Logout", 
            onPressed: (){
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) => 
                    MyOptionsDialog(
                      title: 'Disconnessione account', 
                      bodyText: 'Sei sicuro di voler uscire?', 
                      leftButtonText: 'No', 
                      leftButtonColor: Theme.of(context).colorScheme.secondary,
                      rightButtonText: 'Esci', 
                      rightButtonColor: Theme.of(context).colorScheme.error,
                      onPressLeftButton: (){Navigator.pop(context);}, 
                      onPressRightButton: () async {logout(); Navigator.pushNamedAndRemoveUntil(context, '/LoginPage', (r) => false);}
                    )
                );
            }, color: Theme.of(context).colorScheme.error),
          SizedBox(height: MediaQuery.sizeOf(context).height/29),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              '© 2025 HouseHunters. Tutti i diritti riservati.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ));
  }


  Future<void> recuperaCredenzialiUtenteLoggato() async{
    AWSServices AWSInstance = AWSServices();
    String? nomeUtenteLoggatoTemp = await AWSInstance.recuperaNomeUtenteLoggato();
    String? cognomeUtenteLoggatoTemp = await AWSInstance.recuperaCognomeUtenteLoggato();
    String? mailUtenteLoggatoTemp = await AWSInstance.recuperaEmailUtenteLoggato();

    setState(() {
      nomeUtenteLoggato = nomeUtenteLoggatoTemp;
      cognomeUtenteLoggato = cognomeUtenteLoggatoTemp;
      mailUtenteLoggato = mailUtenteLoggatoTemp;
    });
  }
}