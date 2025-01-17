import 'package:domus_app/pages/login_page.dart';
import 'package:domus_app/utils/my_buttons_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfiloPage extends StatefulWidget {
  const ProfiloPage({super.key});

  @override
  State<ProfiloPage> createState() => _ProfiloPageState();
}

class _ProfiloPageState extends State<ProfiloPage> {
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
                              Text("Luca", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.outline),),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Cognome: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.outline),),
                              Text("Alessio", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.outline),),
                            ],
                          ),
                          
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                    Text(" Email: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.outline),),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("luca.e.alessio@gmail.com", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.outline),))),
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
                  builder: (BuildContext context) => AlertDialog(
                    title: Text("Logout", style: TextStyle(fontSize: 25, color: Theme.of(context).colorScheme.outline),),
                    content: Text("Sei sicuro di voler uscire?", style: TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.outline)),
                    actions: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          fixedSize: Size(MediaQuery.sizeOf(context).width/5, MediaQuery.sizeOf(context).height/27),
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                        }, 
                        child: Text("No", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary,),)
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error,
                          fixedSize: Size(MediaQuery.sizeOf(context).width/5, MediaQuery.sizeOf(context).height/27),
                        ),
                        onPressed: (){
                          Navigator.pushNamedAndRemoveUntil(context, '/LoginPage', (r) => false);
                        }, 
                        child: Text("Si", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary,),)
                      ),
                    ],
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

}