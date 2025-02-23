import 'dart:io'; 
import 'package:domus_app/dto/annuncio_dto.dart';
import 'package:domus_app/theme/ui_constants.dart';
import 'package:domus_app/utils/my_buttons_widgets.dart';
import 'package:domus_app/utils/my_loading.dart';
import 'package:domus_app/utils/my_pop_up_widgets.dart';
import 'package:domus_app/utils/my_text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

const List<String> listaClassiEnergetiche = <String>['―', 'A4', 'A3', 'A2', 'A1', 'B', 'C', 'D', 'E', 'F', 'G'];
const List<String> listaPiani = <String>['―', 'Terra', 'Intermedio', 'Ultimo'];

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
  final TextEditingController stanzeController = TextEditingController();

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

  List<bool> selectedVendiAffitta = <bool>[true, false];

  String sceltaClasseEnergetica = listaClassiEnergetiche.first;
  String sceltaPiano = listaPiani.first;

  bool isSceltaNumeroPianoVisible = false;
  bool isIndirizzoValidato = false;

  bool isPrezzoOk = true;
  bool isIndirizzoOk = true;
  bool isDescrizioneOk = true;
  bool isSuperficieOk = true;
  bool isStanzeOk = true;
  bool isPianoOk = true;
  bool isNPianoOk = true;
  bool isClasseEnergeticaOk = true;

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
    Color coloreErrore = context.error;
    Color coloreSfondo = context.primary;
    Color coloreScritte = context.outline;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: context.onSecondary,
        ),
        title: Text("Crea annuncio", style: TextStyle(color: context.onSecondary)),
        centerTitle: true,
        backgroundColor: context.primary,
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
                                  color: context.onSecondary,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(5),
                                color: context.primary,
                              ),
                              child: Icon(
                                Icons.add,
                                size: 50,
                                color: context.onSecondary,
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
                                      color: context.error.withOpacity(1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Icon(Icons.close, size: 18, color: context.surface),
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
                      color: context.primaryContainer,
                      child: Column(
                        children: [
                          const SizedBox(height: 75),
                          Center(
                              child: Card(
                                  color:
                                      context.onSecondary,
                                  child:
                                      Icon(Icons.add, color: context.primary))),
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
                            color: context.onSecondary,
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text("Vendi", style: TextStyle(color: context.onSecondary),),
                          SizedBox(width: 10)
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            selectedVendiAffitta[1] ? Icons.radio_button_on : Icons.radio_button_off,
                            color: context.onSecondary,
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text("Affitta", style: TextStyle(color: context.onSecondary)),
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
                      child: MyTextFieldOnlyPositiveNumbers(controller: prezzoController, text: "EUR", 
                        colore: coloreScritte)
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
                                    hintStyle: TextStyle(color: coloreScritte),
                                    labelText: 'Indirizzo',
                                    labelStyle: TextStyle(color: isIndirizzoOk ? context.onSecondary : coloreErrore),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: context.outline),),
                                    border: OutlineInputBorder(),
                                  ),
                                  style: TextStyle(color: context.onPrimary),
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
                                    color: coloreSfondo,
                                    borderRadius: BorderRadius.circular(12),
                                    child: child
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
                            color: isIndirizzoValidato ? Colors.green : isIndirizzoOk ? Colors.transparent : coloreErrore,
                            borderRadius: BorderRadius.circular(4),
                            // border: Border.all(color: Colors.black, width: 1),
                            border: Border.all(color: context.onSecondary, width: 1),
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
                              leftButtonColor: context.secondary, 
                              rightButtonText: "Si", 
                              rightButtonColor: context.tertiary, 
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
                          }, icon: Icon(FontAwesomeIcons.check, color: context.onSecondary,),))
                      ],
                    ),
                  ),
                // Divider(),
                // MyLocationsPredictions(location: "Via Dalmazia 13, Napoli (NA), 80124", press: (){}),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 370,
                      child: TextField(
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: context.outline),),
                          labelText: 'Descrizione',  // Testo del label
                          labelStyle: TextStyle(color: isDescrizioneOk ? context.onSecondary : coloreErrore,),
                          hintText: 'Inserire una descrizione dell\'immobile',  // Testo di suggerimento
                          hintStyle: TextStyle(color: coloreScritte),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.5),
                          )
                        ),
                        style: TextStyle(color: coloreScritte,),
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
                                  activeTrackColor: context.onSecondary,
                                  activeColor: context.primary,
                                  value: _isGarageSelected, 
                                  onChanged: (value){
                                    setState(() {
                                      _isGarageSelected = value;
                                    });
                                  }
                                ),
                                Switch(
                                  activeTrackColor: context.onSecondary,
                                  activeColor: context.primary,
                                  value: _isAscensoreSelected, 
                                  onChanged: (value){
                                    setState(() {
                                      _isAscensoreSelected = value;
                                    });
                                  }
                                ),
                                Switch(
                                  activeTrackColor: context.onSecondary,
                                  activeColor: context.primary,
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
                                  activeTrackColor: context.onSecondary,
                                  activeColor: context.primary,
                                  value: _isGiardinoSelected, 
                                  onChanged: (value){
                                    setState(() {
                                      _isGiardinoSelected = value;
                                    });
                                  }
                                ),
                                Switch(
                                  activeTrackColor: context.onSecondary,
                                  activeColor: context.primary,
                                  value: _isPiscinaSelected, 
                                  onChanged: (value){
                                    setState(() {
                                      _isPiscinaSelected = value;
                                    });
                                  }
                                ),
                                Switch(
                                  activeTrackColor: context.onSecondary,
                                  activeColor: context.primary,
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
                      child: MyTextFieldOnlyPositiveNumbers(controller: superficieController, text: "superficie", colore: isSuperficieOk ? coloreScritte : coloreErrore,)
                    ),
                    Text("m²", style: TextStyle(color: coloreScritte, fontWeight: FontWeight.normal, fontSize: GRANDEZZA_SCRITTE_PICCOLE),)
                ],),

                Row(
                  children: [
                    SizedBox(width: 30.0),
                    Text("N. Stanze", style: TextStyle(color: coloreScritte, fontWeight: FontWeight.normal, fontSize: GRANDEZZA_SCRITTE_PICCOLE),),
                    SizedBox(width: 115),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.37,
                      child: MyTextFieldOnlyPositiveNumbers(controller: stanzeController, text: "n. stanze", colore: isSuperficieOk ? coloreScritte : coloreErrore,)
                    ),
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
                        textStyle: TextStyle(color: isPianoOk ? coloreScritte : coloreErrore),
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
                            return DropdownMenuEntry<String>(value: value, label: value, style: MenuItemButton.styleFrom(foregroundColor: coloreScritte));}).toList(),
                        
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
                        child: MyTextFieldOnlyPositiveNumbers(controller: numeroPianoController, text: "n. piano", colore: isNPianoOk ? coloreScritte : coloreErrore,)
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
                        textStyle: TextStyle(color: isClasseEnergeticaOk ? coloreScritte : coloreErrore),
                        inputDecorationTheme: InputDecorationTheme(labelStyle: TextStyle(color: coloreScritte), suffixIconColor: coloreScritte),
                        initialSelection: listaClassiEnergetiche.first,
                        onSelected: (String? value) {
                          setState(() {
                            sceltaClasseEnergetica = value!;
                          });
                        },
                        dropdownMenuEntries: 
                          listaClassiEnergetiche.map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(value: value, label: value, style: MenuItemButton.styleFrom(foregroundColor: coloreScritte));}).toList(),
                          ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 20,),
            MyElevatedButtonWidget(
              text: "Aggiungi annuncio", 
              onPressed: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                if (checkCampiValidi()){
                  AnnuncioDto nuovoAnnuncio = creaAnnuncio();
                  inviaAnnuncio(nuovoAnnuncio, context.onPrimary);
                } else {
                  showDialog(context: context, builder: (BuildContext context) => MyInfoDialog(
                                title: "Attenzione", 
                                bodyText: "Inserire tutti i campi", 
                                buttonText: "Ok", 
                                onPressed: (){Navigator.pop(context);}
                                )
                              );
                }
              },
              color: context.tertiary
            ),
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }

  bool checkCampiValidi() {
    bool isAllOk = true;
    if (prezzoController.text.isEmpty) {
      isPrezzoOk = false;
      isAllOk = false;
    }
    if (isIndirizzoValidato == false) {
      isIndirizzoOk = false;
      isAllOk = false;
    }
    if(descController.text.isEmpty) {
      isDescrizioneOk = false;
      isAllOk = false;
    }
    if(superficieController.text.isEmpty) {
      isSuperficieOk = false;
      isAllOk = false;
    }
    if(stanzeController.text.isEmpty){
      isStanzeOk = false;
      isAllOk = false;
    }
    if(sceltaPiano == "―"){
      isPianoOk = false;
      isAllOk = false;
    }
    if(sceltaPiano == "Intermedio" && numeroPianoController.text.isEmpty){
      isNPianoOk = false;
      isAllOk = false;
    }
    if(sceltaClasseEnergetica == "―"){
      isClasseEnergeticaOk = false;
      isAllOk = false;
    }
    return isAllOk;
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _autovalidateMode = AutovalidateMode.always);
      return;
    }
  }

  AnnuncioDto creaAnnuncio(){
    String prezzoStringa = prezzoController.text;
    double prezzoDouble = double.parse(prezzoStringa);

    String superficieStringa = superficieController.text;
    int superficieInt = int.parse(superficieStringa);

    String nStanzeStringa = stanzeController.text;
    int nStanzeInt = int.parse(nStanzeStringa);

    int? nPianoInt;

    if(sceltaPiano == "Intermedio") {
      String nPianoStringa = numeroPianoController.text;
      nPianoInt = int.parse(nPianoStringa);
    }
    // DateTime now = DateTime.now(); // Ottieni la data e ora correnti
    // String formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(now);

    print(mappeController.text);

    //manca il tipo dell'annuncio (n vendita o in affitto)
    return AnnuncioDto(
      tipo_annuncio: selectedVendiAffitta[0] ? "VENDITA" : "AFFITTO",
      prezzo: prezzoDouble, 
      superficie: superficieInt, 
      numStanze: nStanzeInt, 
      garage: _isGarageSelected, 
      ascensore: _isAscensoreSelected, 
      piscina: _isPiscinaSelected, 
      arredo: _isArredatoSelected,
      balcone: _isBalconeSelected,
      giardino: _isGiardinoSelected,
      // vicino_scuole: ,
      // vicino_parchi: ,
      // vicino_trasporti: ,
      classe_energetica: sceltaClasseEnergetica.toUpperCase(),
      piano: sceltaPiano.toUpperCase(),
      numero_piano: nPianoInt,
      // data_creazione: formattedDate,
      agente: "159cb08f-351f-4d63-8330-822bd55f8721",
      indirizzo: mappeController.text,
      latitudine: latitude ?? 0.0,
      longitudine: longitude ?? 0.0,
      descrizione: descController.text,
    );
  }

  Future<void> inviaAnnuncio(AnnuncioDto nuovoAnnuncioDto, Color coloreCaricamento) async {
    
    LoadingHelper.showLoadingDialog(context, color: coloreCaricamento);
  
    try {
      final url = Uri.parse('http://10.0.2.2:8080/api/annunci');
      // Invia la richiesta POST con il corpo in formato JSON
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json', // Indica che invii dati in formato JSON
        },
        body: json.encode(nuovoAnnuncioDto), // Codifica i dati in formato JSON
      );

      Navigator.pop(context);

      // Controlla la risposta del server
      if (response.statusCode == 201) {
        showDialog(
          context: context, 
          builder: (BuildContext context) => MyInfoDialog(
            title: "Conferma", 
            bodyText: "Annuncio creato", 
            buttonText: "Ok", 
            onPressed: () {Navigator.pop(context); Navigator.pushNamedAndRemoveUntil(context, '/ControllorePagineAgente', (r) => false);}
          )
        );
      } else {
        Navigator.pop(context);
        print('Errore nella creazione dell\'annuncio: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Errore nella richiesta: $e');
    }
  }
}