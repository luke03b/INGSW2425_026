import 'package:domus_app/pages/admin_pages/admin_crea_nuovo_admin_o_agente_page.dart';
import 'package:domus_app/pages/cliente_pages/cliente_eliminazione_account_page.dart';
import 'package:domus_app/pages/shared_pages/cambia_password_page.dart';
import 'package:domus_app/services/aws_cognito.dart';
import 'package:domus_app/theme/theme_provider.dart';
import 'package:domus_app/theme/ui_constants.dart';
import 'package:domus_app/utils/my_buttons_widgets.dart';
import 'package:domus_app/utils/my_pop_up_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("House Hunters", style: TextStyle(color: context.onSecondary),),
        centerTitle: true,
        backgroundColor: context.primary,
        elevation: 5,
        shadowColor: context.shadow,
      ),
      body: Column(
        children: [
          Center(
            child: Card(
              color: context.primaryContainer,
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, size: 125, color: context.outline,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("Nome: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: context.outline),),
                              Text(nomeUtenteLoggato ?? "Non disponibile", style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: context.outline),),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Cognome: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: context.outline),),
                              Text(cognomeUtenteLoggato ?? "Non disponibile", style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: context.outline),),
                            ],
                          ),
                          
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: MediaQuery.sizeOf(context).height/60,),
                      Text("Email: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: context.outline),),
                      Expanded(
                        child: FittedBox(
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.scaleDown,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(mailUtenteLoggato ?? "Non disponibile", style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: context.outline),))),
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

          Card(
          color: context.primaryContainer,
          child: ListTile(
            title: Text("Tema scuro", style: TextStyle(color: context.outline),),
            leading: Icon(Icons.dark_mode, color: context.outline,),
            trailing: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              children: <Widget>[
                Switch(
                  activeTrackColor: context.onSecondary,
                  activeColor: context.primary,
                  value: themeProvider.themeMode == ThemeMode.dark, 
                  onChanged: (value){
                    setState(() {
                      value = !value;
                      themeProvider.toggleTheme();
                    });
                  }
                ),
              ],
            ),
          ),
                      ),

          Visibility(
            visible: gruppoUtenteLoggato == "admin",
            child: GestureDetector(
              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => AdminCreaNuovoAdminPage(isNewUserAdmin: true,)));},
              child: Card(
              color: context.primaryContainer,
              child: ListTile(
                title: Text("Aggiungi admin", style: TextStyle(color: context.outline),),
                leading: Icon(Icons.person_add, color: context.outline,),
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  children: <Widget>[
                    Icon(Icons.arrow_circle_right_outlined, color: context.outline,),
                  ],
                ),
              ),
            ),
            ),
          ),

          Visibility(
            visible: gruppoUtenteLoggato == "agente" || gruppoUtenteLoggato == "admin",
            child: GestureDetector(
              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => AdminCreaNuovoAdminPage(isNewUserAdmin: false,)));},
              child: Card(
              color: context.primaryContainer,
              child: ListTile(
                title: Text("Aggiungi agente immobiliare", style: TextStyle(color: context.outline),),
                leading: Icon(Icons.person_add, color: context.outline,),
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  children: <Widget>[
                    Icon(Icons.arrow_circle_right_outlined, color: context.outline,),
                  ],
                ),
              ),
            ),
            ),
          ),

          GestureDetector(
              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => CambiaPasswordPage(emailUtente: mailUtenteLoggato,)));},
              child: Card(
              color: context.primaryContainer,
              child: ListTile(
                title: Text("Modifica password", style: TextStyle(color: context.outline),),
                leading: Icon(Icons.password, color: context.outline,),
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  children: <Widget>[
                    Icon(Icons.arrow_circle_right_outlined, color: context.outline,),
                  ],
                ),
              ),
            ),
          ),

          GestureDetector(
              onTap: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context) => MyInfoDialog(title: "Assistenza", bodyText: "Se ha bisogno di assistenza ci contatti tramite la seguente email: househunters004@gmail.com", buttonText: "Ok", onPressed:(){Navigator.pop(context);})
                );
              },
              child: Card(
              color: context.primaryContainer,
              child: ListTile(
                title: Text("Assistenza", style: TextStyle(color: context.outline),),
                leading: Icon(Icons.help, color: context.outline,),
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  children: <Widget>[
                    Icon(Icons.arrow_circle_right_outlined, color: context.outline,),
                  ],
                ),
              ),
            ),
          ),

          Visibility(
            visible: gruppoUtenteLoggato == "cliente",
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ClienteEliminazioneAccountPage(emailUtente: mailUtenteLoggato,)));
              },
              child: Card(
              color: context.primaryContainer,
              child: ListTile(
                title: Text("Elimina account", style: TextStyle(color: context.outline),),
                leading: Icon(Icons.delete, color: context.outline,),
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  children: <Widget>[
                    Icon(Icons.arrow_circle_right_outlined, color: context.outline,),
                  ],
                ),
              ),
            ),
            ),
          ),

          SizedBox(height: MediaQuery.sizeOf(context).height/7),
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
                      leftButtonColor: context.secondary,
                      rightButtonText: 'Esci', 
                      rightButtonColor: context.error,
                      onPressLeftButton: (){Navigator.pop(context);}, 
                      onPressRightButton: () async {logout(); Navigator.pushNamedAndRemoveUntil(context, '/LoginPage', (r) => false);}
                    )
                );
            }, color: context.error),
          SizedBox(height: MediaQuery.sizeOf(context).height/29),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              '© 2025 HouseHunters. Tutti i diritti riservati.',
              style: TextStyle(
                fontSize: 12,
                color: context.outline,
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