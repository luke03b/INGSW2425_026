import 'dart:async';
import 'dart:io'; 
import 'package:domus_app/back_end_communication/class_services/annuncio_service.dart';
import 'package:domus_app/back_end_communication/class_services/utente_service.dart';
import 'package:domus_app/costants/enumerations.dart';
import 'package:domus_app/back_end_communication/dto/utente_dto.dart';
import 'package:domus_app/services/aws_cognito.dart';
import 'package:domus_app/ui_elements/theme/ui_constants.dart';
import 'package:domus_app/ui_elements/utils/my_buttons_widgets.dart';
import 'package:domus_app/ui_elements/utils/my_loading.dart';
import 'package:domus_app/ui_elements/utils/my_pop_up_widgets.dart';
import 'package:domus_app/ui_elements/utils/my_text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:image_picker/image_picker.dart';

List<String> listaClassiEnergetiche = Enumerations.listaClassiEnergetiche;
List<String> listaPiani = Enumerations.listaPiani;

class AgenteCreaAnnuncioPage extends StatefulWidget {
  const AgenteCreaAnnuncioPage({super.key});

  @override
  State<AgenteCreaAnnuncioPage> createState() => _AgenteCreaAnnuncioPageState();
}

class _AgenteCreaAnnuncioPageState extends State<AgenteCreaAnnuncioPage> {
  static const double GRANDEZZA_SCRITTE_PICCOLE = 18;
  final TextEditingController prezzoController = TextEditingController();
  final TextEditingController descrizioneController = TextEditingController();
  final TextEditingController cittaController = TextEditingController();
  final TextEditingController capController = TextEditingController();
  final TextEditingController viaController = TextEditingController();
  final TextEditingController superficieController = TextEditingController();
  final TextEditingController numeroPianoController = TextEditingController();
  final TextEditingController stanzeController = TextEditingController();

  final GlobalKey<MyTextFieldOnlyPositiveNumbersWithValidationState> _prezzoKey = GlobalKey<MyTextFieldOnlyPositiveNumbersWithValidationState>();
  final GlobalKey<MyTextFieldWithValidationState> _descrizioneKey = GlobalKey<MyTextFieldWithValidationState>();
  final GlobalKey<MyTextFieldOnlyPositiveNumbersWithValidationState> _indirizzoKey = GlobalKey<MyTextFieldOnlyPositiveNumbersWithValidationState>();
  final GlobalKey<MyTextFieldOnlyPositiveNumbersWithValidationState> _superficieKey = GlobalKey<MyTextFieldOnlyPositiveNumbersWithValidationState>();
  final GlobalKey<MyTextFieldOnlyPositiveNumbersWithValidationState> _nStanzeKey = GlobalKey<MyTextFieldOnlyPositiveNumbersWithValidationState>();
  final GlobalKey<MyTextFieldOnlyPositiveNumbersWithValidationState> _pianoKey = GlobalKey<MyTextFieldOnlyPositiveNumbersWithValidationState>();
  final GlobalKey<MyTextFieldOnlyPositiveNumbersWithValidationState> _nPianoKey = GlobalKey<MyTextFieldOnlyPositiveNumbersWithValidationState>();
  final GlobalKey<MyTextFieldOnlyPositiveNumbersWithValidationState> _classeEnergeticaKey = GlobalKey<MyTextFieldOnlyPositiveNumbersWithValidationState>();

  final TextEditingController indirizzoController = TextEditingController();
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
        shadowColor: context.shadow,
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
                                    removeImage(index);
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
                          return SizedBox.shrink();
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
                      minHeight: 30,
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
                      child: MyTextFieldOnlyPositiveNumbersWithValidation(controller: prezzoController, text: "EUR", 
                        colore: coloreScritte, key: _prezzoKey, onChanged: (value) {},)
                    ),
                ],),
                Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
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
                                isIndirizzoOk = true;
                              });},
                              textEditingController: indirizzoController,
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
                                  indirizzoController.text = prediction.description!,
                              minInputLength: 3,
                            ),
                          ),
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
                                  isIndirizzoOk = true;
                                });
                                Navigator.pop(context);}, 
                              onPressRightButton: (){setState(() {
                                isIndirizzoValidato = true;
                                isIndirizzoOk = true;
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
                      child: MyTextFieldWithValidation(
                        controller: descrizioneController, 
                        text: 'Descrizione', 
                        hintText: 'Inserire una descrizione dell\'immobile',
                        colore: coloreScritte, 
                        onChanged: (value){},
                        key: _descrizioneKey,),
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
                      child: MyTextFieldOnlyPositiveNumbersWithValidation(
                        controller: superficieController,
                        text: "superficie", 
                        colore: isSuperficieOk ? coloreScritte : coloreErrore,
                        key: _superficieKey,
                        onChanged: (value){},)
                    ),
                    Text("m²", style: TextStyle(color: coloreScritte, fontWeight: FontWeight.normal, fontSize: GRANDEZZA_SCRITTE_PICCOLE),)
                ],),

                Row(
                  children: [
                    SizedBox(width: 30.0),
                    Text("N. Stanze", style: TextStyle(color: coloreScritte, fontWeight: FontWeight.normal, fontSize: GRANDEZZA_SCRITTE_PICCOLE),),
                    SizedBox(width: 119),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.37,
                      child: MyTextFieldOnlyPositiveNumbersWithValidation(
                        controller: stanzeController, 
                        text: "n. stanze", 
                        colore: isSuperficieOk ? coloreScritte : coloreErrore,
                        key: _nStanzeKey,
                        onChanged: (value){},)
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
                        textStyle: TextStyle(color: coloreScritte),
                        inputDecorationTheme: InputDecorationTheme(
                          labelStyle: TextStyle(color: coloreScritte), 
                          suffixIconColor: coloreScritte,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: isPianoOk ? context.outline : context.error), // Colore della linea quando non è in focus
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: isPianoOk ? context.onSecondary : context.error, width: 2.0), // Colore della linea quando scrivi
                          ),
                        ),
                        initialSelection: listaPiani.first,
                        onSelected: (String? value) {
                          setState(() {
                            isPianoOk = true;
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
                        child: MyTextFieldOnlyPositiveNumbersWithValidation(
                          controller: numeroPianoController, 
                          text: "n. piano", 
                          colore: isNPianoOk ? coloreScritte : coloreErrore,
                          key: _nPianoKey,
                          onChanged: (value){},)
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
                        inputDecorationTheme: InputDecorationTheme(
                          labelStyle: TextStyle(color: coloreScritte), 
                          suffixIconColor: coloreScritte,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: isClasseEnergeticaOk ? context.outline : context.error), // Colore della linea quando non è in focus
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: isClasseEnergeticaOk ? context.onSecondary : context.error, width: 2.0), // Colore della linea quando scrivi
                          ),
                        ),
                        initialSelection: listaClassiEnergetiche.first,
                        onSelected: (String? value) {
                          setState(() {
                            isClasseEnergeticaOk = true;
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
              color: context.tertiary,
              text: "Aggiungi annuncio", 
              onPressed: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                if(_validateFields()){
                  LoadingHelper.showLoadingDialogNotDissmissible(context, color: context.secondary);
                  try{
                    UtenteDto? utenteLoggato = await recuperaIdUtenteLoggato();
                    int statusCode = await AnnuncioService.creaAnnuncio(selectedVendiAffitta[0] ? "VENDITA" : "AFFITTO", prezzoController.text, superficieController.text, indirizzoController.text,
                      descrizioneController.text, _isGarageSelected, _isAscensoreSelected, _isPiscinaSelected, _isArredatoSelected, _isBalconeSelected, _isGiardinoSelected, stanzeController.text,
                      numeroPianoController.text, sceltaClasseEnergetica, sceltaPiano, latitude ?? 0.0, longitude ?? 0.0, utenteLoggato);
                    Navigator.pop(context);
                    controllaStatusCode(statusCode, context);
                  } on TimeoutException {
                    Navigator.pop(context);
                    showDialog(
                      context: context, 
                      builder: (BuildContext context) => MyInfoDialog(
                        title: "Connessione non riuscita", 
                        bodyText: "Annuncio non creato, la connessione con i nostri server non è stata stabilita correttamente. Riprova più tardi.", 
                        buttonText: "Ok", 
                        onPressed: () {Navigator.pop(context);}
                      )
                    );
                  } catch (e) {
                    print(e);
                    Navigator.pop(context);
                    showDialog(
                      context: context, 
                      builder: (BuildContext context) => MyInfoDialog(
                        title: "Errore",
                        bodyText: "Annuncio non creato. Il server potrebbe non essere raggiungibile. Riprova più tardi.", 
                        buttonText: "Ok", 
                        onPressed: () {Navigator.pop(context);}
                      )
                    );
                  }
                } else {
                  showDialog(context: context, builder: (BuildContext context) => MyInfoDialog(
                                title: "Attenzione", 
                                bodyText: "Inserire tutti i campi", 
                                buttonText: "Ok", 
                                onPressed: (){Navigator.pop(context);}
                                )
                              );
                }
                }
              ),
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }

  Future<UtenteDto> recuperaIdUtenteLoggato() async {
    String? sub = await AWSServices().recuperaSubUtenteLoggato();
    print(sub!);
    UtenteDto utenteLoggato = await UtenteService.recuperaUtenteBySub(sub);
    print(utenteLoggato.id);
    return utenteLoggato;
  }

  void controllaStatusCode(int statusCode, BuildContext context) {
    if (statusCode == 201) {
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
      showDialog(
        context: context, 
        builder: (BuildContext context) => MyInfoDialog(
          title: "Errore", 
          bodyText: "Annuncio non creato, controllare i campi e riprovare.", 
          buttonText: "Ok", 
          onPressed: () {Navigator.pop(context);}
        )
      );
    }
  }

  bool _validateFields(){
    bool allValid = true;
    if (prezzoController.text.trim().isEmpty) {
      _prezzoKey.currentState?.setError(true);
      allValid = false;
    }

    if (descrizioneController.text.trim().isEmpty) {
      _descrizioneKey.currentState?.setError(true);
      allValid = false;
    }

    if (!isIndirizzoValidato) {
      isIndirizzoOk = false;
      allValid = false;
    }

    if (superficieController.text.trim().isEmpty) {
      _superficieKey.currentState?.setError(true);
      allValid = false;
    }

    if (stanzeController.text.trim().isEmpty) {
      _nStanzeKey.currentState?.setError(true);
      allValid = false;
    }

    if(sceltaPiano == "―"){
      isPianoOk = false;
      allValid = false;
    }

    if (sceltaPiano == "Intermedio" && numeroPianoController.text.trim().isEmpty) {
      _nPianoKey.currentState?.setError(true);
      allValid = false;
    }

    if (sceltaClasseEnergetica == "―") {
      isClasseEnergeticaOk = false;
      allValid = false;
    }

    return allValid;
  }
}