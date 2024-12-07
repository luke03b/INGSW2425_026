import 'package:domus_app/utils/my_buttons_widgets.dart';
import 'package:domus_app/utils/my_text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const List<String> listaClassiEnergetiche = <String>['Tutte', 'A4', 'A3', 'A2', 'A1', 'B', 'C', 'D', 'E', 'F', 'G'];

class CercaPage extends StatefulWidget {
  const CercaPage({super.key});

  @override
  State<CercaPage> createState() => _CercaPageState();
}

class _CercaPageState extends State<CercaPage> {

  final TextEditingController _affittaController = TextEditingController();

  final TextEditingController _prezzoMaxController = TextEditingController();

  final TextEditingController _prezzoMinController = TextEditingController();


  final TextEditingController _superficieMinController = TextEditingController();

  final TextEditingController _superficieMaxController = TextEditingController();


  final TextEditingController _numeroStanzeMinController = TextEditingController();

  final TextEditingController _numeroStanzeMaxController = TextEditingController();


  bool _ricercaAvanzataVisibile = false;

  bool _isGarageSelected = false;

  bool _isGiardinoSelected = false;

  bool _isAscensoreSelected = false;

  bool _isPiscinaSelected = false;

  bool _isArredatoSelected = false;

  bool _isBalconeSelected = false;

  List<Widget> fruits = <Widget>[Text('Compra'), Text('Affitta')];
  final List<bool> _selectedFruits = <bool>[true, false];

  String sceltaClasseEnergetica = listaClassiEnergetiche.first;

  void _navigateBottomBar(){
    setState(() {
      _ricercaAvanzataVisibile = !_ricercaAvanzataVisibile;
    });
  }
  
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
            Align(
              alignment: Alignment.centerLeft,
              widthFactor: 2.37,
              heightFactor: 1.5,
              child: ToggleButtons(
                onPressed: (int index){
                  setState(() {
                    for (int i = 0; i < _selectedFruits.length; i++){
                      _selectedFruits[i] = i == index;
                    }
                  });
                },
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                selectedBorderColor: Colors.transparent,
                selectedColor: Theme.of(context).colorScheme.surface,
                fillColor: Theme.of(context).colorScheme.primary,
                color: Theme.of(context).colorScheme.primary,
                constraints: const BoxConstraints(
                  minHeight: 40.0,
                  minWidth: 80.0,
                ),
                isSelected: _selectedFruits,
                children: fruits),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.92,
              child: MyTextFieldSuffixIcon(
                controller: _affittaController, 
                text: "Inserisci una zona di ricerca", 
                icon: Icon(Icons.search)
              )
            ),

            Align(
              alignment: Alignment.centerRight,
              child: MyTextButtonWidget(
                text: "Ricerca Avanzata", 
                onPressed: _navigateBottomBar
              )
            ),

            Visibility(
              visible: _ricercaAvanzataVisibile,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.euro, size: 22, color: Theme.of(context).colorScheme.primary,),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.40,
                        child: MyTextFieldOnlyPositiveNumbers(controller: _prezzoMinController, text: "Prezzo Min")
                      ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.40, 
                        child: MyTextFieldOnlyPositiveNumbers(controller: _prezzoMaxController, text: "Prezzo Max")
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(FontAwesomeIcons.arrowsUpDownLeftRight, size: 20, color: Theme.of(context).colorScheme.primary,),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.40,
                        child: MyTextFieldOnlyPositiveNumbers(controller: _superficieMinController, text: "Superficie Min")
                      ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.40,
                        child: MyTextFieldOnlyPositiveNumbers(controller: _superficieMaxController, text: "Superficie Max")
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(FontAwesomeIcons.couch, size: 20, color: Theme.of(context).colorScheme.primary,),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.40,
                        child: MyTextFieldOnlyPositiveNumbers(controller: _numeroStanzeMinController, text: "N. Stanze Min")
                      ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.40,
                        child: MyTextFieldOnlyPositiveNumbers(controller: _numeroStanzeMaxController, text: "N. Stanze Max")
                      ),
                    ],
                  ),
                  
                  Divider(height: 50, thickness: 2, indent: 10, endIndent: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(FontAwesomeIcons.car, size: 22, color: Theme.of(context).colorScheme.primary,),
                      Text("Garage", style: TextStyle(fontSize: 18.0),),
                      Switch(value: _isGarageSelected, onChanged: (value){
                        setState(() {
                          _isGarageSelected = value;
                        });
                      }),
                      Icon(Icons.park, size: 22, color: Theme.of(context).colorScheme.primary,),
                      Text("Giardino", style: TextStyle(fontSize: 18.0),),
                      Switch(value: _isGiardinoSelected, onChanged: (value){
                        setState(() {
                          _isGiardinoSelected = value;
                        });
                      })
                    ],
                  ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(FontAwesomeIcons.elevator, size: 22, color: Theme.of(context).colorScheme.primary,),
                      Text("Ascensore", style: TextStyle(fontSize: 18.0),),
                      Switch(value: _isAscensoreSelected, onChanged: (value){
                        setState(() {
                          _isAscensoreSelected = value;
                        });
                      }),
                      Icon(Icons.pool, size: 22, color: Theme.of(context).colorScheme.primary,),
                      Text("Piscina", style: TextStyle(fontSize: 18.0),),
                      Switch(value: _isPiscinaSelected, onChanged: (value){
                        setState(() {
                          _isPiscinaSelected = value;
                        });
                      })
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.checkroom, size: 22, color: Theme.of(context).colorScheme.primary,),
                      Text("Arredato", style: TextStyle(fontSize: 18.0),),
                      Switch(value: _isArredatoSelected, onChanged: (value){
                        setState(() {
                          _isArredatoSelected = value;
                        });
                      }),
                      Icon(Icons.balcony, size: 22, color: Theme.of(context).colorScheme.primary,),
                      Text("Balcone", style: TextStyle(fontSize: 18.0),),
                      Switch(value: _isBalconeSelected, onChanged: (value){
                        setState(() {
                          _isBalconeSelected = value;
                        });
                      })
                    ],
                  ),

                  SizedBox(
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Classe Energetica", style: TextStyle(fontSize: 18.0),),
                        DropdownMenu(
                          initialSelection: listaClassiEnergetiche.first,
                          onSelected: (String? value) {
                            setState(() {
                              sceltaClasseEnergetica = value!;
                            });
                          },
                          dropdownMenuEntries: listaClassiEnergetiche.map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(value: value, label: value);}).toList(),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}