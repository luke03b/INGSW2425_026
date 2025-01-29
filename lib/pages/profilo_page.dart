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
  String? gruppoUtenteLoggato;

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
                              Text(nomeUtenteLoggato ?? "Non disponibile", style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Theme.of(context).colorScheme.outline),),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Cognome: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.outline),),
                              Text(cognomeUtenteLoggato ?? "Non disponibile", style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Theme.of(context).colorScheme.outline),),
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
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.scaleDown,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(mailUtenteLoggato ?? "Non disponibile", style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Theme.of(context).colorScheme.outline),))),
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

          Visibility(
            visible: gruppoUtenteLoggato == "admin",
            child: GestureDetector(
              onTap: (){debugPrint("admin creato!!");},
              child: Card(
              color: Colors.white,
              child: ListTile(
                title: Text("Aggiungi admin", style: TextStyle(color: Colors.black),),
                leading: Icon(Icons.person_add, color: Colors.black,),
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  children: <Widget>[
                    Icon(Icons.arrow_circle_right_outlined, color: Colors.black,),
                  ],
                ),
              ),
            ),
            ),
          ),

          Visibility(
            visible: gruppoUtenteLoggato == "agente" || gruppoUtenteLoggato == "admin",
            child: GestureDetector(
              onTap: (){debugPrint("agente creato!!");},
              child: Card(
              color: Colors.white,
              child: ListTile(
                title: Text("Aggiungi agente immobiliare", style: TextStyle(color: Colors.black),),
                leading: Icon(Icons.person_add, color: Colors.black,),
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  children: <Widget>[
                    Icon(Icons.arrow_circle_right_outlined, color: Colors.black,),
                  ],
                ),
              ),
            ),
            ),
          ),

          GestureDetector(
              onTap: (){debugPrint("password cambiata!!");},
              child: Card(
              color: Colors.white,
              child: ListTile(
                title: Text("Modifica password", style: TextStyle(color: Colors.black),),
                leading: Icon(Icons.password, color: Colors.black,),
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  children: <Widget>[
                    Icon(Icons.arrow_circle_right_outlined, color: Colors.black,),
                  ],
                ),
              ),
            ),
          ),

          GestureDetector(
              onTap: (){debugPrint("assistenza!!");},
              child: Card(
              color: Colors.white,
              child: ListTile(
                title: Text("Assistenza", style: TextStyle(color: Colors.black),),
                leading: Icon(Icons.help, color: Colors.black,),
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  children: <Widget>[
                    Icon(Icons.arrow_circle_right_outlined, color: Colors.black,),
                  ],
                ),
              ),
            ),
          ),

          Visibility(
            visible: gruppoUtenteLoggato == "cliente",
            child: GestureDetector(
              onTap: (){debugPrint("account eliminato!!");},
              child: Card(
              color: Colors.white,
              child: ListTile(
                title: Text("Elimina account", style: TextStyle(color: Colors.black),),
                leading: Icon(Icons.delete, color: Colors.black,),
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  children: <Widget>[
                    Icon(Icons.arrow_circle_right_outlined, color: Colors.black,),
                  ],
                ),
              ),
            ),
            ),
          ),

          SizedBox(height: MediaQuery.sizeOf(context).height/5),
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
    String? gruppoUtenteLoggatoTemp = await AWSInstance.recuperaGruppoUtenteLoggato();

    setState(() {
      nomeUtenteLoggato = nomeUtenteLoggatoTemp;
      cognomeUtenteLoggato = cognomeUtenteLoggatoTemp;
      mailUtenteLoggato = mailUtenteLoggatoTemp;
      gruppoUtenteLoggato = gruppoUtenteLoggatoTemp;
    });
  }
}