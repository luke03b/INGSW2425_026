import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:domus_app/class_services/annuncio_service.dart';
import 'package:domus_app/dto/annuncio_dto.dart';
import 'package:domus_app/pages/cliente_pages/cliente_annuncio_page.dart';
import 'package:domus_app/services/formatStrings.dart';
import 'package:domus_app/theme/ui_constants.dart';
import 'package:domus_app/utils/my_loading.dart';
import 'package:domus_app/utils/my_pop_up_widgets.dart';
import 'package:flutter/material.dart';

class RisultatiCercaPage extends StatefulWidget {
  
  final String tipoAnnuncio;
  final double latitudine;
  final double longitudine;
  final double? raggioRicerca;
  final String? prezzoMin;
  final String? prezzoMax;
  final String? superficieMin;
  final String? superficieMax;
  final String? nStanzeMin;
  final String? nStanzeMax;
  final bool? garage;
  final bool? ascensore;
  final bool? arredato;
  final bool? giardino;
  final bool? piscina;
  final bool? balcone;
  final bool? vicinoScuole;
  final bool? vicinoParchi;
  final bool? vicinoMezzi;
  final String? piano;
  final String? classeEnergetica;

  const RisultatiCercaPage({
    super.key,
    required this.latitudine,
    required this.longitudine,
    required this.tipoAnnuncio,
    this.raggioRicerca,
    this.prezzoMin,
    this.prezzoMax,
    this.superficieMin,
    this.superficieMax,
    this.nStanzeMin,
    this.nStanzeMax,
    this.garage,
    this.ascensore,
    this.arredato,
    this.giardino,
    this.piscina,
    this.balcone,
    this.vicinoScuole,
    this.vicinoParchi,
    this.vicinoMezzi,
    this.piano,
    this.classeEnergetica,
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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Esegui getAnnunci dopo la fase di build
    Future.delayed(Duration.zero, () {
      getAnnunci();
    });
  }

  Future<void> getAnnunci() async {
    try {
      // Apri il loading dialog DOPO la fase di build
      Future.delayed(Duration.zero, () {
        LoadingHelper.showLoadingDialog(context, color: context.secondary);
      });

      List<AnnuncioDto> data = await AnnuncioService.recuperaAnnunciByCriteriDiRicerca(
        widget.latitudine,
        widget.longitudine,
        widget.tipoAnnuncio,
        raggioRicerca: widget.raggioRicerca,
        prezzoMin: widget.prezzoMin,
        prezzoMax: widget.prezzoMax,
        superficieMin: widget.superficieMin,
        superficieMax: widget.superficieMax,
        nStanzeMin: widget.nStanzeMin,
        nStanzeMax: widget.nStanzeMax,
        garage: widget.garage,
        ascensore: widget.ascensore,
        arredato: widget.arredato,
        giardino: widget.giardino,
        piscina: widget.piscina,
        balcone: widget.balcone,
        vicinoScuole: widget.vicinoScuole,
        vicinoParchi: widget.vicinoParchi,
        vicinoMezzi: widget.vicinoMezzi,
        piano: widget.piano,
        classeEnergetica: widget.classeEnergetica,
      );

      if (mounted) {
        setState(() {
          annunciList = data;
          hasUserAnnunci = annunciList.isNotEmpty;
        });
      }

      Navigator.pop(context); // Chiudi il loading dialog

    } on TimeoutException {
      if (mounted) {
        Navigator.pop(context); // Chiudi il loading dialog prima di mostrare l'errore
        showDialog(
          context: context, 
          builder: (BuildContext context) => MyInfoDialog(
            title: "Connessione non riuscita", 
            bodyText: "Annuncio non creato, la connessione con i nostri server non è stata stabilita correttamente.", 
            buttonText: "Ok", 
            onPressed: () { Navigator.pop(context); }
          )
        );
      }
    } catch (error) {
      Navigator.pop(context);
      print('Errore con il recupero degli annunci (il server potrebbe non essere raggiungibile) $error');
    }
  }

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
      'descrizione' : 'Nel cuore della rinomata collina di Posillipo, in una posizione dominante che regala una vista senza pari sul golfo di Napoli, Christie\'s International Real Estate propone in vendita un appartamento di 174 mq, un\'esclusiva residenza che fonde eleganza, comfort e luminosità. Questo immobile, caratterizzato da ampi spazi interni, è arricchito da una spettacolare superficie esterna di 286 mq, che include ampi balconi, un terrazzo panoramico di copertura e una veranda, tutti luoghi ideali per godere di momenti di convivialità e relax, circondati da un panorama unico. Posto all\'ultimo piano di un elegante edificio, questo appartamento si distingue per la luminosità che inonda ogni ambiente grazie all\'esposizione ideale e alle ampie vetrate che permettono di godere della vista sul mare in ogni angolo della casa. Il soggiorno doppio, spazioso e raffinato, offre un affaccio diretto sul mare, creando un ambiente perfetto per rilassarsi o intrattenere ospiti. La zona notte comprende tre camere da letto, tutte silenziose e confortevoli, mentre i due bagni e la cucina abitabile con accesso indipendente completano l\'immobile con praticità e funzionalità. Gli spazi esterni, ampi e ben progettati, offrono la possibilità di vivere all\'aperto durante tutto l\'anno, con aree ideali per cene all\'aperto, eventi sociali o semplicemente per godere di momenti di tranquillità, immersi nella bellezza naturale di Posillipo. A completare questa straordinaria proprieta\', una cantina e due posti auto coperti, per garantire il massimo della comodità e della sicurezza. Un\'opportunità imperdibile per chi cerca una residenza di lusso in uno dei quartieri più esclusivi di Napoli, dove la bellezza senza tempo del mare si fonde con il comfort moderno.',
      'vicino_scuole' : 'si',
      'vicino_parchi' : 'no',
      'vicino_mezzi' : 'si',
      'agenzia' : 'trovaCasa',
      'agente' : 'Marcella Bella',
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
      'descrizione' : '',
      'vicino_scuole' : 'si',
      'vicino_parchi' : 'no',
      'vicino_mezzi' : 'si',
      'agenzia' : 'trovaCasa',
      'agente' : 'Marcella Bella',
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
      'descrizione' : '',
      'vicino_scuole' : 'si',
      'vicino_parchi' : 'no',
      'vicino_mezzi' : 'si',
      'agenzia' : 'trovaCasa',
      'agente' : 'Marcella Bella',
    },

  ];

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
        AnnuncioDto casaCorrente = entry.value;
        double scaleFactor = indice == _currentSliderIndex ? 1.0 : 1.0;
        return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ClienteAnnuncioPage(casaSelezionata: casaCorrente)));
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: context.primaryContainer,
              borderRadius: BorderRadius.circular(10),
              shape: BoxShape.rectangle,
              boxShadow: [BoxShadow(color: context.shadow.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 15,
                offset: Offset(0, 10),)],
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                  child: SizedBox(
                    // child: Image.asset(casaCorrente['image1']))),
                    child: Image.asset('lib/assets/casa3_1_placeholder.png'),
                  )
                ),
                Row(
                  children: [
                    Expanded(child: Image.asset('lib/assets/casa3_1_placeholder.png')),
                    Expanded(child: Image.asset('lib/assets/casa3_1_placeholder.png')),
                  ],
                ),
                SizedBox(
                  height: scaleFactor * MediaQuery.of(context).size.height/50,
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Text(FormatStrings.formatNumber(casaCorrente.prezzo), style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE, fontWeight: FontWeight.bold, color: context.outline)),
                    Text(" EUR", style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE, fontWeight: FontWeight.bold, color: context.outline)),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Icon(Icons.location_on, size: scaleFactor * GRANDEZZA_ICONE, color: context.outline,),
                    SizedBox(width: MediaQuery.of(context).size.width/45,),
                    Text(casaCorrente.indirizzo, style: TextStyle(fontSize: scaleFactor * GRANDEZZA_SCRITTE_PICCOLE, fontWeight: FontWeight.normal, color: context.outline), softWrap: true),
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