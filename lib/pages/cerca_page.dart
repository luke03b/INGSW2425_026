import 'package:carousel_slider/carousel_slider.dart';
import 'package:domus_app/pages/annuncio_page.dart';
import 'package:domus_app/utils/my_buttons_widgets.dart';
import 'package:domus_app/utils/my_text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const List<String> listaClassiEnergetiche = <String>['Tutte', 'A4', 'A3', 'A2', 'A1', 'B', 'C', 'D', 'E', 'F', 'G'];
const List<String> listaPiani = <String>['Tutti', 'Terra', 'Intermedio', 'Ultimo'];

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
  final List<bool> selectedCompraAffitta = <bool>[true, false];

  String sceltaClasseEnergetica = listaClassiEnergetiche.first;
  String sceltaPiano = listaPiani.first;

  int _currentSliderIndex = 0;

  final List<Map<String, dynamic>> listaCase = [
    {
      'image1': 'lib/assets/casa1_1_placeholder.png',
      'image2' : 'lib/assets/casa1_2_placeholder.png',
      'image3' : 'lib/assets/casa1_3_placeholder.png',
      'prezzo': '275.000',
      'indirizzo': 'Via Dalmazia 13,\nCavalleggeri 80124 (NA)',
      'superficie': '100 mq',
      'numero_stanze': '6',
      'arredato' : "si",
      'piano' : 'Terra',
      'descrizione' : 'Nel cuore della rinomata collina di Posillipo, in una posizione dominante che regala una vista senza pari sul golfo di Napoli, Christie\'s International Real Estate propone in vendita un appartamento di 174 mq, un\'esclusiva residenza che fonde eleganza, comfort e luminosità. Questo immobile, caratterizzato da ampi spazi interni, è arricchito da una spettacolare superficie esterna di 286 mq, che include ampi balconi, un terrazzo panoramico di copertura e una veranda, tutti luoghi ideali per godere di momenti di convivialità e relax, circondati da un panorama unico. Posto all\'ultimo piano di un elegante edificio, questo appartamento si distingue per la luminosità che inonda ogni ambiente grazie all\'esposizione ideale e alle ampie vetrate che permettono di godere della vista sul mare in ogni angolo della casa. Il soggiorno doppio, spazioso e raffinato, offre un affaccio diretto sul mare, creando un ambiente perfetto per rilassarsi o intrattenere ospiti. La zona notte comprende tre camere da letto, tutte silenziose e confortevoli, mentre i due bagni e la cucina abitabile con accesso indipendente completano l\'immobile con praticità e funzionalità. Gli spazi esterni, ampi e ben progettati, offrono la possibilità di vivere all\'aperto durante tutto l\'anno, con aree ideali per cene all\'aperto, eventi sociali o semplicemente per godere di momenti di tranquillità, immersi nella bellezza naturale di Posillipo. A completare questa straordinaria proprieta\', una cantina e due posti auto coperti, per garantire il massimo della comodità e della sicurezza. Un\'opportunità imperdibile per chi cerca una residenza di lusso in uno dei quartieri più esclusivi di Napoli, dove la bellezza senza tempo del mare si fonde con il comfort moderno.'
    },
    {
      'image1': 'lib/assets/casa2_1_placeholder.png',
      'image2' : 'lib/assets/casa2_2_placeholder.png',
      'image3' : 'lib/assets/casa2_3_placeholder.png',
      'prezzo': '300.000',
      'indirizzo': 'Via Dalmazia 14,\nCavalleggeri 80124 (NA)',
      'superficie': '120 mq',
      'numero_stanze': '7',
      'arredato' : "no",
      'piano' : 'Ultimo',
      'descrizione' : ''
    },
    {
      'image1': 'lib/assets/casa3_1_placeholder.png',
      'image2' : 'lib/assets/casa3_2_placeholder.png',
      'image3' : 'lib/assets/casa3_3_placeholder.png',
      'prezzo': '250.000',
      'indirizzo': 'Via Dalmazia 10,\nCavalleggeri 80124 (NA)',
      'superficie': '80 mq',
      'numero_stanze': '5',
      'arredato' : "si",
      'piano' : '3',
      'descrizione' : ''
    },

  ];

  void _toggleRicercaAvanzata(){
    setState(() {
      _ricercaAvanzataVisibile = !_ricercaAvanzataVisibile;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    Color coloriPulsanti = Theme.of(context).colorScheme.outline;
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
            myCompraAffittaButton(context),

            //TextBox
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.92,
              child: MyTextFieldSuffixIcon(
                controller: _affittaController, 
                text: "Inserisci una zona di ricerca", 
                icon: Icon(Icons.search),
                colore: coloriPulsanti,
              )
            ),

            //Tasto ricerca avanzata
            Align(
              alignment: Alignment.centerRight,
              child: MyTextButtonWidget(
                text: "Ricerca Avanzata", 
                onPressed: _toggleRicercaAvanzata,
                colore: coloriPulsanti
              )
            ),

            //parametri ricerca avanzata
            myParametriRicercaAvanzata(coloriPulsanti, context),

            SizedBox(
              height: MediaQuery.of(context).size.height/35,
            ),
            //tasto cerca
            MyElevatedButtonWidget(
              text: "Cerca",
              onPressed: (){Navigator.pushNamed(context, '/ControllorePagine2');},
              color: Theme.of(context).colorScheme.tertiary
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height/13,
            ),

            myCronologia(context, coloriPulsanti)

          ],
        )
      ),
    );
  }

  Visibility myCronologia(BuildContext context, Color coloriPulsanti) {
    return Visibility(
      visible: !_ricercaAvanzataVisibile, 
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: MediaQuery.of(context).size.width/9,),
              Icon(Icons.history, color: coloriPulsanti,),
              Text('Ultime Visite', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: coloriPulsanti),),
            ],
          ),
          myCarouselSlider(context),
        ],
      )
    );
  }

  CarouselSlider myCarouselSlider(BuildContext context) {
    Color coloreScritte = Theme.of(context).colorScheme.outline;
    return CarouselSlider(
      items: listaCase.asMap().entries.map((entry) {
        int indice = entry.key;
        Map<String, dynamic> indiceCasaCorrente = entry.value;
        double scaleFactor = indice == _currentSliderIndex ? 1.0 : 0.7;
        return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AnnuncioPage(casaSelezionata: indiceCasaCorrente)));
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: Colors.white, 
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
                    Icon(Icons.euro, size: scaleFactor * 22, color: coloreScritte,),
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Text(indiceCasaCorrente['prezzo'], style: TextStyle(fontSize: scaleFactor * 20, fontWeight: FontWeight.bold, color: coloreScritte),),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Icon(Icons.location_on, size: scaleFactor * 22, color: coloreScritte,),
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Text(indiceCasaCorrente['indirizzo'], style: TextStyle(fontSize: scaleFactor * 20, fontWeight: FontWeight.bold, color: coloreScritte)),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Icon(FontAwesomeIcons.arrowsUpDownLeftRight, size: scaleFactor * 22, color: coloreScritte,),
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Text(indiceCasaCorrente['superficie'], style: TextStyle(fontSize: scaleFactor * 20, fontWeight: FontWeight.bold, color: coloreScritte)),
                  ],
                ),
              ],
            ),
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
      ));
  }

  Visibility myParametriRicercaAvanzata(Color coloriPulsanti, BuildContext context) {
    return Visibility(
            visible: _ricercaAvanzataVisibile,
            child: Column(
              children: [

                //prezzo
                myFiltroRicerca(coloriPulsanti, context, Icons.euro, _prezzoMinController, _prezzoMaxController, "Prezzo Min", "Prezzo Max"),

                //superficie
                myFiltroRicerca(coloriPulsanti, context, FontAwesomeIcons.arrowsUpDownLeftRight, _superficieMinController, _superficieMaxController, "Superficie Min", "Superficie Max"),

                //Stanze
                myFiltroRicerca(coloriPulsanti, context, FontAwesomeIcons.couch, _numeroStanzeMinController, _numeroStanzeMaxController, "N. Stanze Min", "N. Stanze Max"),
                
                Divider(height: 50, thickness: 2, indent: 10, endIndent: 10, color: Theme.of(context).colorScheme.primary,),

                Row(
                  children: [

                    SizedBox(width: 10.0),

                    //Colonna comunista
                    Column(
                      children: [

                        //Riga contenente tre colonne
                        Row(
                          children: [

                            //Colonna contenente icone
                            Column(
                              children: [
                                Icon(FontAwesomeIcons.car, size: 22, color: coloriPulsanti,),
                                SizedBox(height: 22,),
                                Icon(FontAwesomeIcons.elevator, size: 22, color: coloriPulsanti,),
                                SizedBox(height: 22,),
                                Icon(Icons.checkroom, size: 22, color: coloriPulsanti,),
                              ],
                            ),

                            SizedBox(width: 10,),
                            
                            //Colonna contenente nomi
                            Column(
                              children: [
                                Text("Garage", style: TextStyle(fontSize: 18.0, color: coloriPulsanti),),
                                SizedBox(height: 22,),
                                Text("Ascensore", style: TextStyle(fontSize: 18.0, color: coloriPulsanti)),
                                SizedBox(height: 22,),
                                Text("Arredato", style: TextStyle(fontSize: 18.0, color: coloriPulsanti)),
                              ],
                            ),
                            
                            SizedBox(width: 10,),

                            //colonna contenente switch
                            Column(
                              children: [
                                Switch(
                                  value: _isGarageSelected, 
                                  onChanged: (value){
                                    setState(() {
                                      _isGarageSelected = value;
                                    });
                                  }
                                ),
                                Switch(
                                  value: _isAscensoreSelected, 
                                  onChanged: (value){
                                    setState(() {
                                      _isAscensoreSelected = value;
                                    });
                                  }
                                ),
                                Switch(
                                  value: _isArredatoSelected, 
                                  onChanged: (value){
                                    setState(() {
                                      _isArredatoSelected = value;
                                    });
                                  }
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),

                    SizedBox(width: 30.0),

                    //Colonna fascista
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                       Row(
                          children: [

                            //Colonna contenente icone
                            Column(
                              children: [
                                Icon(Icons.park, size: 22, color: coloriPulsanti,),
                                SizedBox(height: 22,),
                                Icon(Icons.pool, size: 22, color: coloriPulsanti,),
                                SizedBox(height: 22,),
                                Icon(Icons.balcony, size: 22, color: coloriPulsanti,),
                              ],
                            ),

                            SizedBox(width: 10,),
                            
                            //Colonna contenente nomi
                            Column(
                              children: [
                                Text("Giardino", style: TextStyle(fontSize: 18.0, color: coloriPulsanti),),
                                SizedBox(height: 22,),
                                Text("Piscina", style: TextStyle(fontSize: 18.0, color: coloriPulsanti)),
                                SizedBox(height: 22,),
                                Text("Balcone", style: TextStyle(fontSize: 18.0, color: coloriPulsanti)),
                              ],
                            ),
                            
                            SizedBox(width: 10,),

                            //colonna contenente switch
                            Column(
                              children: [
                                Switch(
                                  value: _isGiardinoSelected, 
                                  onChanged: (value){
                                    setState(() {
                                      _isGiardinoSelected = value;
                                    });
                                  }
                                ),
                                Switch(
                                  value: _isPiscinaSelected, 
                                  onChanged: (value){
                                    setState(() {
                                      _isPiscinaSelected = value;
                                    });
                                  }
                                ),
                                Switch(
                                  value: _isBalconeSelected, 
                                  onChanged: (value){
                                    setState(() {
                                      _isBalconeSelected = value;
                                    });
                                  }
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),

                //Selettore Piano
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("           Piano           ", style: TextStyle(fontSize: 18.0, color: coloriPulsanti),),
                      DropdownMenu(
                        textStyle: TextStyle(color: coloriPulsanti),
                        inputDecorationTheme: InputDecorationTheme(labelStyle: TextStyle(color: coloriPulsanti), suffixIconColor: coloriPulsanti),
                        initialSelection: listaPiani.first,
                        onSelected: (String? value) {
                          setState(() {
                            sceltaClasseEnergetica = value!;
                          });
                        },
                        dropdownMenuEntries: 
                          listaPiani.map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(value: value, label: value,);}).toList(),
                          ),
                    ],
                  ),
                ),


                //Selettore Classe Energetica
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Classe Energetica", style: TextStyle(fontSize: 18.0, color: coloriPulsanti),),
                      DropdownMenu(
                        textStyle: TextStyle(color: coloriPulsanti),
                        inputDecorationTheme: InputDecorationTheme(labelStyle: TextStyle(color: coloriPulsanti), suffixIconColor: coloriPulsanti),
                        initialSelection: listaClassiEnergetiche.first,
                        onSelected: (String? value) {
                          setState(() {
                            sceltaClasseEnergetica = value!;
                          });
                        },
                        dropdownMenuEntries: 
                          listaClassiEnergetiche.map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(value: value, label: value,);}).toList(),
                          ),
                    ],
                  ),
                ),

              ],
            ),
          );
  }

  Row myFiltroRicerca(Color coloriPulsanti, BuildContext context, IconData icona, TextEditingController controllerMin, TextEditingController controllerMax, String nomeMin, String nomeMax) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Icon(icona, size: 22, color: coloriPulsanti,),
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.40,
          child: MyTextFieldOnlyPositiveNumbers(controller: controllerMin, text: nomeMin, colore: coloriPulsanti,)
        ),
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.40, 
          child: MyTextFieldOnlyPositiveNumbers(controller: controllerMax, text: nomeMax, colore: coloriPulsanti,)
        ),
      ],
    );
  }

  Align myCompraAffittaButton(BuildContext context) {
    return Align(
            alignment: Alignment.centerLeft,
            widthFactor: 2.37,
            heightFactor: 1.5,
            child: ToggleButtons(
              onPressed: (int index){
                setState(() {
                  for (int i = 0; i < selectedCompraAffitta.length; i++){
                    selectedCompraAffitta[i] = i == index;
                  }
                });
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: Colors.transparent,
              selectedColor: Theme.of(context).colorScheme.surface,
              fillColor: Theme.of(context).colorScheme.primary,
              color: Theme.of(context).colorScheme.outline,
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: 80.0,
              ),
              isSelected: selectedCompraAffitta,
              children: _widgetCompraAffitta),
          );
  }
}