import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:domus_app/back_end_communication/class_services/annuncio_service.dart';
import 'package:domus_app/back_end_communication/class_services/immagini_service.dart';
import 'package:domus_app/back_end_communication/dto/annuncio/annuncio_dto.dart';
import 'package:domus_app/back_end_communication/dto/annuncio/filtri_ricerca_dto.dart';
import 'package:domus_app/back_end_communication/dto/immagini_dto.dart';
import 'package:domus_app/pages/shared_pages/annuncio_page.dart';
import 'package:domus_app/ui_elements/utils/formatStrings.dart';
import 'package:domus_app/ui_elements/theme/ui_constants.dart';
import 'package:domus_app/ui_elements/utils/my_loading.dart';
import 'package:domus_app/ui_elements/utils/my_pop_up_widgets.dart';
import 'package:flutter/material.dart';

class RisultatiCercaPage extends StatefulWidget {

  final FiltriRicercaDto filtriRicerca;

  const RisultatiCercaPage({
    super.key,
    required this.filtriRicerca,
  });

  @override
  State<RisultatiCercaPage> createState() => _RisultatiCercaPageState();
}

class _RisultatiCercaPageState extends State<RisultatiCercaPage> {
  static const int GRANDEZZA_SCRITTE = 23;
  static const int GRANDEZZA_ICONE = 25;
  static const int GRANDEZZA_SCRITTE_PICCOLE = 18;
  static const int GRANDEZZA_ICONE_PICCOLE = 20;
  int _currentSliderIndex = 0;
  List<AnnuncioDto> annunciList = [];
  bool hasUserAnnunci = false;

  @override
  void initState() {
    super.initState();
    getAnnunci();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
  }

  Future<void> getAnnunci() async {
    try {
    
      Future.delayed(Duration.zero, () {
        LoadingHelper.showLoadingDialogNotDissmissible(context, color: context.secondary);
      });

      List<AnnuncioDto> data = await AnnuncioService.recuperaAnnunciByCriteriDiRicerca(widget.filtriRicerca);

      for(AnnuncioDto annuncio in data){
        List<ImmaginiDto> immaginiPerAnnuncio = await ImmaginiService.recuperaTutteImmaginiByAnnuncio(annuncio);
        ImmaginiDto.ordinaImmaginiPerNumero(immaginiPerAnnuncio);
        annuncio.listaImmagini = immaginiPerAnnuncio;
      }

      for(AnnuncioDto annuncio in data){
        if(annuncio.listaImmagini != null && annuncio.listaImmagini!.isNotEmpty){
          for(ImmaginiDto immagine in annuncio.listaImmagini!){
            immagine.urlS3 = await ImmaginiService.recuperaFileImmagine(immagine.url); 
          }
        }
      }

      if (mounted) {
        setState(() {
          annunciList = data;
          hasUserAnnunci = annunciList.isNotEmpty;
        });
      }

      Navigator.pop(context);

    } on TimeoutException {
      if (mounted) {
        Navigator.pop(context);
        showDialog(
          context: context, 
          builder: (BuildContext context) => MyInfoDialog(
            title: "Connessione non riuscita", 
            bodyText: "Non è stato possibile recuperare gli annunci, la connessione con i nostri server non è stata stabilita correttamente.", 
            buttonText: "Ok", 
            onPressed: () { Navigator.pop(context);  Navigator.pop(context);}
          )
        );
      }
    } catch (error) {
      if (mounted) {
        Navigator.pop(context);
        showDialog(
            context: context, 
            builder: (BuildContext context) => MyInfoDialog(
              title: "Connessione non riuscita", 
              bodyText: "Non è stato possibile recuperare gli annunci, Probabilmente i server non sono raggiungibili.", 
              buttonText: "Ok", 
              onPressed: () { Navigator.pop(context); Navigator.pop(context);}
            )
          );
      }
      print('Errore 3 con il recupero degli annunci (il server potrebbe non essere raggiungibile) $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: context.onSecondary,
        ),
        title: Text("House Hunters", style: TextStyle(color: context.onSecondary),),
        centerTitle: true,
        backgroundColor: context.primary,
        elevation: 5,
        shadowColor: context.shadow,
      ),
      body: hasUserAnnunci ? myCarouselSlider(context) : Center(child: Text("Non esistono annunci che soddisfano le tue necessità", style: TextStyle(color: context.onSecondary, fontSize: 20))));
  }

  CarouselSlider myCarouselSlider(BuildContext context) {
    return CarouselSlider(
      items: annunciList.asMap().entries.map((entry) {
        int indice = entry.key;
        AnnuncioDto annuncioCorrente = entry.value;
        double scaleFactor = indice == _currentSliderIndex ? 1.0 : 1.0;
        return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AnnuncioPage(idAnnuncioSelezionato: annuncioCorrente.idAnnuncio!)));
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: context.primaryContainer,
              borderRadius: BorderRadius.circular(10),
              shape: BoxShape.rectangle,
            ),
            child: Column(
              children: [
                ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                      child: SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                // color: Colors.black,
                                image: DecorationImage(image: AssetImage('lib/assets/blank_house.png'),
                                fit: BoxFit.cover)
                              ),
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: (annuncioCorrente.listaImmagini != null && annuncioCorrente.listaImmagini!.isNotEmpty && annuncioCorrente.listaImmagini!.length>=1  &&
                                        annuncioCorrente.listaImmagini!.first.urlS3 != null && annuncioCorrente.listaImmagini!.first.urlS3!.isNotEmpty) ?
                                        Image.network(annuncioCorrente.listaImmagini!.first.urlS3!, 
                                          errorBuilder: (context, error, stackTrace) {
                                          return Image.asset('lib/assets/blank_house.png');}, 
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,) : 
                                        SizedBox.shrink()))
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: SizedBox(
                          height: 110,
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(image: AssetImage('lib/assets/blank_house.png'),
                                  fit: BoxFit.cover)
                                ),
                              ),
                              Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: (annuncioCorrente.listaImmagini != null && annuncioCorrente.listaImmagini!.isNotEmpty && annuncioCorrente.listaImmagini!.length>=2  &&
                                        annuncioCorrente.listaImmagini!.elementAt(1).urlS3 != null && annuncioCorrente.listaImmagini!.elementAt(1).urlS3!.isNotEmpty) ?
                                        Image.network(annuncioCorrente.listaImmagini!.elementAt(1).urlS3!, 
                                          errorBuilder: (context, error, stackTrace) {
                                          return Image.asset('lib/assets/blank_house.png');}, 
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,) : 
                                        SizedBox.shrink()))
                            ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                          height: 110,
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(image: AssetImage('lib/assets/blank_house.png'),
                                  fit: BoxFit.cover)
                                ),
                              ),
                              Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: (annuncioCorrente.listaImmagini != null && annuncioCorrente.listaImmagini!.isNotEmpty && annuncioCorrente.listaImmagini!.length>=3  &&
                                        annuncioCorrente.listaImmagini!.elementAt(2).urlS3 != null && annuncioCorrente.listaImmagini!.elementAt(2).urlS3!.isNotEmpty) ?
                                        Image.network(annuncioCorrente.listaImmagini!.elementAt(2).urlS3!, 
                                          errorBuilder: (context, error, stackTrace) {
                                          return Image.asset('lib/assets/blank_house.png');}, 
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,) : 
                                        SizedBox.shrink()))
                            ],
                          ),
                          ),
                        ),
                      ],
                    ),
                SizedBox(
                  height: scaleFactor * MediaQuery.of(context).size.height/50,
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Text(FormatStrings.formatNumber(annuncioCorrente.prezzo), style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE, fontWeight: FontWeight.bold, color: context.outline)),
                    Text(" EUR", style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE, fontWeight: FontWeight.bold, color: context.outline)),
                    Visibility(
                      visible: annuncioCorrente.tipoAnnuncio == "AFFITTO", 
                      child: Row(
                        children: [
                          SizedBox(width: 3,),
                          Text("/Mese", style: TextStyle(color: context.outline, fontWeight: FontWeight.bold, fontSize: scaleFactor * GRANDEZZA_SCRITTE),),
                        ],
                      )
                    )
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Icon(Icons.location_on, size: scaleFactor * GRANDEZZA_ICONE, color: context.outline,),
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Expanded(
                      child: AutoSizeText(
                        annuncioCorrente.indirizzo,
                        style: TextStyle(
                          fontSize: scaleFactor * 18,
                          fontWeight: FontWeight.normal,
                          color: context.outline,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        minFontSize: 12,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
      options: CarouselOptions(
        enableInfiniteScroll: false,
        viewportFraction: 0.56,
        height: 753,
        enlargeCenterPage: true,
        scrollDirection: Axis.vertical,
        onPageChanged: (indiceCasaCorrente, reason) {
          setState(() {
            _currentSliderIndex = indiceCasaCorrente;
          });
        }
      ));
  }
}