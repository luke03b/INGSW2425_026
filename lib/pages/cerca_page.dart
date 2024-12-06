import 'package:domus_app/utils/my_buttons_widgets.dart';
import 'package:domus_app/utils/my_text_widgets.dart';
import 'package:flutter/material.dart';

class CercaPage extends StatefulWidget {
  const CercaPage({super.key});

  @override
  State<CercaPage> createState() => _CercaPageState();
}

class _CercaPageState extends State<CercaPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("House Hunters", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 5,
          shadowColor: Colors.black,
        ),
        body: Column(
          children: [
            TabBar(
              dividerColor: Colors.transparent,
              tabs: [
                Tab(text: "Compra"),
                Tab(text: "Affitta"),
              ]
            ),

            Expanded(
              child: TabBarView(children: [
                CompraTab(),
                AffittaTab(),
              ]),
            )
          ],
        ),
      ),
    );
  }
}

//AffittaTab
class AffittaTab extends StatelessWidget {
  final TextEditingController affittaController = TextEditingController();
  AffittaTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
        //   child: TextFormField(
        //     controller: affittaController,
        //     style: TextStyle(
        //       fontSize: 18.0, 
        //     ),
        //     decoration: InputDecoration(
        //       hintText: "Inserisci una zona di ricerca",
        //       suffixIcon: Icon(Icons.search),
        //     ),
        //   ),
        // ),

        SizedBox(
          height: MediaQuery.sizeOf(context).height/18,
          width: MediaQuery.sizeOf(context).width/1.05,
          child: MyTextFieldSuffixIcon(
            controller: affittaController, 
            text: "Inserisci una zona di ricerca", 
            icon: Icon(Icons.search)
          )
          // child: Container(
          //   color: Colors.red,
          // )
        ),

        Align(
          alignment: Alignment.centerRight,
          child: MyTextButtonWidget(
            text: "Ricerca Avanzata", 
            onPressed: (){}
          )
        )


      ],
    );
  }
}


//CompraTab
class CompraTab extends StatelessWidget {
  const CompraTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("compra"),
      ),
    );
  }
}