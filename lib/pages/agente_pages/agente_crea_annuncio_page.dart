import 'dart:io'; 
import 'package:domus_app/utils/my_buttons_widgets.dart';
import 'package:domus_app/utils/my_pop_up_widgets.dart';
import 'package:domus_app/utils/my_text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:image_picker/image_picker.dart';

const List<String> listaClassiEnergetiche = <String>['Tutte', 'A4', 'A3', 'A2', 'A1', 'B', 'C', 'D', 'E', 'F', 'G'];
const List<String> listaPiani = <String>['Tutti', 'Terra', 'Intermedio', 'Ultimo'];

class AgenteCreaAnnuncioPage extends StatefulWidget {
  const AgenteCreaAnnuncioPage({super.key});

  @override
  State<AgenteCreaAnnuncioPage> createState() => _AgenteCreaAnnuncioPageState();
}

class _AgenteCreaAnnuncioPageState extends State<AgenteCreaAnnuncioPage> {
  static const double GRANDEZZA_SCRITTE_PICCOLE = 18;
  final TextEditingController prezzoController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController cittaController = TextEditingController();
  final TextEditingController capController = TextEditingController();
  final TextEditingController viaController = TextEditingController();
  final TextEditingController superficieController = TextEditingController();
  final TextEditingController numeroPianoController = TextEditingController();

  final TextEditingController mappeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  double? latitude = null;
  double? longitude = null;

  bool _isGarageSelected = false;

  bool _isGiardinoSelected = false;

  bool _isAscensoreSelected = false;

  bool _isPiscinaSelected = false;

  bool _isArredatoSelected = false;

  bool _isBalconeSelected = false;

  List<bool> selectedVendiAffitta = <bool>[false, false];

  String sceltaClasseEnergetica = listaClassiEnergetiche.first;
  String sceltaPiano = listaPiani.first;

  bool isSceltaNumeroPianoVisible = false;
  bool isIndirizzoValidato = false;

  final imagePicker = ImagePicker();
  List<XFile>? imageList = [];

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    
    if (selectedImages != null && selectedImages.isNotEmpty) {
      // Limita la selezione in modo che non vengano aggiunte più di 15 foto in totale
      final int maxImages = 15;
      final int remainingSpace = maxImages - imageList!.length;
      
      if (remainingSpace > 0) {
        final int imagesToAdd = selectedImages.length > remainingSpace ? remainingSpace : selectedImages.length;
        imageList!.addAll(selectedImages.take(imagesToAdd)); // Aggiungi solo il numero di immagini che possono essere caricate
        setState(() {});
      }
    }
  }

  void removeImage(int index) {
    setState(() {
      imageList!.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    Color coloreScritte = Theme.of(context).colorScheme.outline;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.surface,
        ),
        title: Text("Crea annuncio",
            style:
                TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 5,
        shadowColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(width: 7),
                Text(
                  "Seleziona immagini:",
                  style: TextStyle(
                      fontSize: GRANDEZZA_SCRITTE_PICCOLE,
                      color: coloreScritte,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              children: [
                Visibility(
                  visible: imageList!.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(), // Per evitare problemi di scorrimento
                      itemCount: imageList!.length + 1,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 3,
                        mainAxisSpacing: 7,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        if (index == imageList!.length && imageList!.length < 15) {
                          // Mostra il pulsante "+" solo se ci sono meno di 15 immagini
                          return GestureDetector(
                            onTap: () {
                              selectImages();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(5),
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              child: Icon(
                                Icons.add,
                                size: 50,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          );
                        } else if (index < imageList!.length) {
                          // Mostra le immagini solo se l'indice è valido
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.file(
                                  File(imageList![index].path),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                              Positioned(
                                top: 3,
                                right: 3,
                                child: GestureDetector(
                                  onTap: () {
                                    removeImage(index); // Aggiungi la logica per rimuovere l'immagine
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.error.withOpacity(1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Icon(Icons.close, size: 18, color: Theme.of(context).colorScheme.surface),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          // Evita errori se l'indice è fuori dai limiti
                          return SizedBox.shrink();  // Non visualizzare nulla se l'indice è fuori dai limiti
                        }
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: imageList!.isEmpty,
                  child: GestureDetector(
                    onTap: () {
                      selectImages();
                    },
                    child: Card(
                      color: Theme.of(context).colorScheme.onSurface,
                      child: Column(
                        children: [
                          const SizedBox(height: 75),
                          Center(
                              child: Card(
                                  color:
                                      Theme.of(context).colorScheme.primary,
                                  child:
                                      const Icon(Icons.add, color: Colors.white))),
                          const SizedBox(height: 75),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(width: 7,),
                    Text("Tipo annuncio:", style: TextStyle(color: coloreScritte, fontWeight: FontWeight.bold, fontSize: GRANDEZZA_SCRITTE_PICCOLE),),
                    SizedBox(width: 7,),
                    ToggleButtons(
                    borderRadius: BorderRadius.circular(100),
                    isSelected: selectedVendiAffitta,
                    onPressed: (int index) {
                      setState(() {
                        for (int i = 0; i < selectedVendiAffitta.length; i++) {
                          selectedVendiAffitta[i] = i == index;
                        }
                      });
                    },
                    constraints: BoxConstraints(
                      minHeight: 30, // imposta l'altezza minima
                    ),
                    children: [
                      Row(
                        children: [
                          Icon(
                            selectedVendiAffitta[0] ? Icons.radio_button_on : Icons.radio_button_off,
                            color: Theme.of(context).colorScheme.primary,
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text("Vendi"),
                          SizedBox(width: 10)
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            selectedVendiAffitta[1] ? Icons.radio_button_on : Icons.radio_button_off,
                            color: Theme.of(context).colorScheme.primary,
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text("Affitta"),
                          SizedBox(width: 15)
                        ],
                      ),
                    ],
                  )
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 7),
                    Text("Prezzo annuncio:", style: TextStyle(color: coloreScritte, fontWeight: FontWeight.bold, fontSize: GRANDEZZA_SCRITTE_PICCOLE),),
                    SizedBox(width: 7),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.40,
                      child: MyTextFieldOnlyPositiveNumbers(controller: prezzoController, text: "EUR", colore: coloreScritte,)
                    ),
                ],),
                Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Form(
                              key: _formKey,
                              autovalidateMode: _autovalidateMode,
                              child: SizedBox(
                                width: 309,
                                child: GooglePlacesAutoCompleteTextFormField(
                                  onChanged: (value){setState(() {
                                    latitude = null;
                                    longitude = null;
                                    isIndirizzoValidato = false;
                                  });},
                                  textEditingController: mappeController,
                                  googleAPIKey: "AIzaSyBUkzr-VCtKVyTTfssndaWR5Iy5TyfM0as",
                                  decoration: InputDecoration(
                                    hintText: 'Inserire un indirizzo',
                                    labelText: 'Indirizzo',
                                    labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  // proxyURL: _yourProxyURL,
                                  maxLines: 1,
                                  overlayContainerBuilder: (child) => Material(
                                    elevation: 1.0,
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    child: child,
                                  ),
                                  fetchCoordinates: true,
                                  onPlaceDetailsWithCoordinatesReceived: (prediction) {
                                    print('placeDetails ${prediction.lat} , ${prediction.lng}');
                                    latitude = double.tryParse(prediction.lat ?? '');
                                    longitude = double.tryParse(prediction.lng ?? '');
                                    print('new coordinates $latitude , $longitude');
                                  },
                                  onSuggestionClicked: (Prediction prediction) =>
                                      mappeController.text = prediction.description!,
                                  minInputLength: 3,
                                ),
                              ),
                            ),
                            // const SizedBox(height: 24),
                            // TextButton(
                            //   onPressed: _onSubmit,
                            //   child: const Text('Submit'),
                            // ),
                          ],
                        ),
                        SizedBox(width: 10,),
                        Container(
                          decoration: BoxDecoration(
                            color: isIndirizzoValidato ? Colors.green : Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                            // border: Border.all(color: Colors.black, width: 1),
                            border: Border.all(color: Theme.of(context).colorScheme.onSurface, width: 1),
                          ),
                          child: IconButton(onPressed: (){
                            FocusScope.of(context).unfocus();
                            if(latitude == null || longitude == null){
                              showDialog(context: context, builder: (BuildContext context) => MyInfoDialog(
                                title: "Attenzione", 
                                bodyText: "L'indirizzo inserito non è valido. Riprovare con un indirizzo valido", 
                                buttonText: "Ok", 
                                onPressed: (){Navigator.pop(context);}
                                )
                              );
                            } else {
                            showDialog(context: context, builder: (BuildContext context) => MyMapDialog(
                              title: "Attenzione", 
                              bodyText: "Controllare che l'indirizzo sia corretto", 
                              leftButtonText: "No", 
                              leftButtonColor: Colors.grey, 
                              rightButtonText: "Si", 
                              rightButtonColor: Theme.of(context).colorScheme.tertiary, 
                              onPressLeftButton: (){
                                setState(() {
                                  isIndirizzoValidato = false;
                                });
                                Navigator.pop(context);}, 
                              onPressRightButton: (){setState(() {
                                isIndirizzoValidato = true;
                              });
                              Navigator.pop(context);}, 
                              latitude: latitude, 
                              longitude: longitude),);
                            }
                            // FocusScope.of(context).unfocus();
                          }, icon: Icon(FontAwesomeIcons.check, color: Theme.of(context).colorScheme.onSurface,),))
                      ],
                    ),
                  ),
                // Divider(),
                // MyLocationsPredictions(location: "Via Dalmazia 13, Napoli (NA), 80124", press: (){}),
                SizedBox(height: 25,),
                Row(
                  children: [
                    SizedBox(width: 7,),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width/1.04,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Descrizione',  // Testo del label
                          labelStyle: TextStyle(
                            fontSize: 24,  // Aumenta la dimensione del font
                            fontWeight: FontWeight.bold,  // Rende il font più bold, opzionale
                            color: coloreScritte,  // Colore opzionale
                          ),
                          hintText: 'Inserisci una descrizione dell\'immobile',  // Testo di suggerimento
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                          style: TextStyle(
                            fontSize: 18,  // Aumenta la dimensione del font del testo inserito
                            color: coloreScritte,  // Colore del testo inserito
                          ),
                        maxLines: null,
                        controller: descController,
                      )
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    SizedBox(width: 7,),
                    Text("Caratteristiche:", style: TextStyle(color: coloreScritte, fontWeight: FontWeight.bold, fontSize: GRANDEZZA_SCRITTE_PICCOLE),)
                ],),
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
                                Icon(FontAwesomeIcons.car, size: 22, color: coloreScritte,),
                                SizedBox(height: 22,),
                                Icon(FontAwesomeIcons.elevator, size: 22, color: coloreScritte,),
                                SizedBox(height: 22,),
                                Icon(FontAwesomeIcons.chair, size: 22, color: coloreScritte,),
                              ],
                            ),

                            SizedBox(width: 10,),
                            
                            //Colonna contenente nomi
                            Column(
                              children: [
                                Text("Garage", style: TextStyle(fontSize: 18.0, color: coloreScritte, ),),
                                SizedBox(height: 22,),
                                Text("Ascensore", style: TextStyle(fontSize: 18.0, color: coloreScritte)),
                                SizedBox(height: 22,),
                                Text("Arredato", style: TextStyle(fontSize: 18.0, color: coloreScritte)),
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
                                Icon(Icons.park, size: 22, color: coloreScritte,),
                                SizedBox(height: 22,),
                                Icon(Icons.pool, size: 22, color: coloreScritte,),
                                SizedBox(height: 22,),
                                Icon(Icons.balcony, size: 22, color: coloreScritte,),
                              ],
                            ),

                            SizedBox(width: 10,),
                            
                            //Colonna contenente nomi
                            Column(
                              children: [
                                Text("Giardino", style: TextStyle(fontSize: 18.0, color: coloreScritte),),
                                SizedBox(height: 22,),
                                Text("Piscina", style: TextStyle(fontSize: 18.0, color: coloreScritte)),
                                SizedBox(height: 22,),
                                Text("Balcone", style: TextStyle(fontSize: 18.0, color: coloreScritte)),
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

                Row(
                  children: [
                    SizedBox(width: 30.0),
                    Text("Superficie", style: TextStyle(color: coloreScritte, fontWeight: FontWeight.normal, fontSize: GRANDEZZA_SCRITTE_PICCOLE),),
                    SizedBox(width: 115),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.37,
                      child: MyTextFieldOnlyPositiveNumbers(controller: superficieController, text: "superficie", colore: coloreScritte,)
                    ),
                    Text("m²", style: TextStyle(color: coloreScritte, fontWeight: FontWeight.normal, fontSize: GRANDEZZA_SCRITTE_PICCOLE),)
                ],),

                //Selettore Piano
                SizedBox(
                  height: 50,
                  width: MediaQuery.sizeOf(context).width/1,
                  child: Row(
                    children: [
                      SizedBox(width: 30.0),
                      Text("Piano", style: TextStyle(fontSize: 18.0, color: coloreScritte),),
                      SizedBox(width: 150.0),
                      DropdownMenu(
                        width: 175,
                        textStyle: TextStyle(color: coloreScritte),
                        inputDecorationTheme: InputDecorationTheme(labelStyle: TextStyle(color: coloreScritte), suffixIconColor: coloreScritte),
                        initialSelection: listaPiani.first,
                        onSelected: (String? value) {
                          setState(() {
                            sceltaPiano = value!;
                            if(sceltaPiano == "Intermedio"){
                              isSceltaNumeroPianoVisible = true;
                            } else {
                              isSceltaNumeroPianoVisible = false;
                            }
                          });
                        },
                        dropdownMenuEntries: 
                          listaPiani.map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(value: value, label: value,);}).toList(),
                          ),
                    ],
                  ),
                ),

                SizedBox(height: 10.0),

                Visibility(
                  visible: isSceltaNumeroPianoVisible,
                  child: Row(
                    children: [
                      SizedBox(width: 30.0),
                      Text("N. piano", style: TextStyle(color: coloreScritte, fontWeight: FontWeight.normal, fontSize: GRANDEZZA_SCRITTE_PICCOLE),),
                      SizedBox(width: 130.0),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.42,
                        child: MyTextFieldOnlyPositiveNumbers(controller: numeroPianoController, text: "n. piano", colore: coloreScritte,)
                      ),
                      SizedBox(height: 10.0),
                  ],),
                ),

                //Selettore Classe Energetica
                SizedBox(
                  height: 50,
                  width: MediaQuery.sizeOf(context).width/1,
                  child: Row(
                    children: [
                      SizedBox(width: 30.0),
                      Text("Classe Energetica", style: TextStyle(fontSize: 18.0, color: coloreScritte),),
                      SizedBox(width: 50.0),
                      DropdownMenu(
                        width: 175,
                        textStyle: TextStyle(color: coloreScritte),
                        inputDecorationTheme: InputDecorationTheme(labelStyle: TextStyle(color: coloreScritte), suffixIconColor: coloreScritte),
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
                )
              ],
            ),
            SizedBox(height: 20,),
            MyElevatedButtonWidget(text: "Aggiungi annuncio", onPressed: (){debugPrint("annuncio creato!!!");}, color: Theme.of(context).colorScheme.tertiary),
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _autovalidateMode = AutovalidateMode.always);
      return;
    }
  }
}