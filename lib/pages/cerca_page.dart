import 'package:carousel_slider/carousel_slider.dart';
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

  final List<Widget> _widgetCompraAffitta = <Widget>[Text('Compra'), Text('Affitta')];
  final List<bool> _selectedCompraAffitta = <bool>[true, false];

  String sceltaClasseEnergetica = listaClassiEnergetiche.first;

  int _currentSliderIndex = 0;

  final List<Map<String, dynamic>> listaCase = [
    {
      'image1': 'lib/assets/casa1_1_placeholder.png',
      'image2' : 'lib/assets/casa1_2_placeholder.png',
      'image3' : 'lib/assets/casa1_3_placeholder.png',
      'prezzo': '275.000',
      'indirizzo': 'Via Dalmazia 13,\nCavalleggeri 80124 (NA)',
      'superficie': '100 mq'
    },
    {
      'image1': 'lib/assets/casa2_1_placeholder.png',
      'image2' : 'lib/assets/casa2_2_placeholder.png',
      'image3' : 'lib/assets/casa2_3_placeholder.png',
      'prezzo': '300.000',
      'indirizzo': 'Via Dalmazia 14,\nCavalleggeri 80124 (NA)',
      'superficie': '120 mq'
    },
    {
      'image1': 'lib/assets/casa3_1_placeholder.png',
      'image2' : 'lib/assets/casa3_2_placeholder.png',
      'image3' : 'lib/assets/casa3_3_placeholder.png',
      'prezzo': '250.000',
      'indirizzo': 'Via Dalmazia 10,\nCavalleggeri 80124 (NA)',
      'superficie': '80 mq'
    },

  ];

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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("House Hunters", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 5,
          shadowColor: Colors.black,
          ),
        body: Column(
          children: [
            //tasto Compra Affitta
            Align(
              alignment: Alignment.centerLeft,
              widthFactor: 2.37,
              heightFactor: 1.5,
              child: ToggleButtons(
                onPressed: (int index){
                  setState(() {
                    for (int i = 0; i < _selectedCompraAffitta.length; i++){
                      _selectedCompraAffitta[i] = i == index;
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
                isSelected: _selectedCompraAffitta,
                children: _widgetCompraAffitta),
            ),

            //TextBox
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.92,
              child: MyTextFieldSuffixIcon(
                controller: _affittaController, 
                text: "Inserisci una zona di ricerca", 
                icon: Icon(Icons.search)
              )
            ),

            //Tasto ricerca avanzata
            Align(
              alignment: Alignment.centerRight,
              child: MyTextButtonWidget(
                text: "Ricerca Avanzata", 
                onPressed: _navigateBottomBar,
                color: Theme.of(context).colorScheme.primary
              )
            ),

            //parametri ricerca avanzata
            Visibility(
              visible: _ricercaAvanzataVisibile,
              child: Column(
                children: [

                  //prezzo
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

                  //superficie
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

                  //Stanze
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
                  
                  Divider(height: 50, thickness: 2, indent: 10, endIndent: 10, color: Theme.of(context).colorScheme.tertiary,),

                  //Selettore Garage e Giardino
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
                  
                  //Selettore Ascensore Piscina
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

                  //Selettore Arredato Balcone
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

                  //Selettore Classe Energetica
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

            MyElevatedButtonWidget(
              text: "Cerca",
              onPressed: (){Navigator.pushNamed(context, '/RisultatiCercaPage');},
              color: Theme.of(context).colorScheme.tertiary
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height/13,
            ),

            Visibility(
              visible: !_ricercaAvanzataVisibile, 
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width/9,),
                      Icon(Icons.history, color: Theme.of(context).colorScheme.primary,),
                      Text('Ultime Visite', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    ],
                  ),
                  GestureDetector(
                    onTap: (){},
                    child: CarouselSlider(
                      items: listaCase.asMap().entries.map((entry) {
                        int indice = entry.key;
                        Map<String, dynamic> indiceCasaCorrente = entry.value;
                        double scaleFactor = indice == _currentSliderIndex ? 1.0 : 0.7;
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary, 
                            borderRadius: BorderRadius.circular(10),
                            shape: BoxShape.rectangle,
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 15,
                              offset: Offset(0, 10),)],
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                                child: SizedBox(
                                  child: Image.asset(indiceCasaCorrente['image1']))),
                              Row(
                                children: [
                                  Expanded(child: Image.asset(indiceCasaCorrente['image2'])),
                                  Expanded(child: Image.asset(indiceCasaCorrente['image3'])),
                                ],
                              ),
                              SizedBox(
                                height: scaleFactor * MediaQuery.of(context).size.height/50,
                              ),
                              Row(
                                children: [
                                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                                  Icon(Icons.euro, size: scaleFactor * 22, color: Theme.of(context).colorScheme.surface,),
                                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                                  Text(indiceCasaCorrente['prezzo'], style: TextStyle(fontSize: scaleFactor * 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.surface),),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                                  Icon(Icons.location_on, size: scaleFactor * 22, color: Theme.of(context).colorScheme.surface,),
                                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                                  Text(indiceCasaCorrente['indirizzo'], style: TextStyle(fontSize: scaleFactor * 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.surface)),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                                  Icon(FontAwesomeIcons.arrowsUpDownLeftRight, size: scaleFactor * 22, color: Theme.of(context).colorScheme.surface,),
                                  SizedBox(width: MediaQuery.of(context).size.width/45,),
                                  Text(indiceCasaCorrente['superficie'], style: TextStyle(fontSize: scaleFactor * 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.surface)),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 400,
                        enlargeCenterPage: true,
                        onPageChanged: (indiceCasaCorrente, reason) {
                          setState(() {
                            _currentSliderIndex = indiceCasaCorrente;
                          });
                        }
                      )),
                  ),
                ],
              ))

          ],
        )
      ),
    );
  }
}