import 'dart:async';
import 'dart:convert';
import 'package:domus_app/class_services/utente_service.dart';
import 'package:domus_app/communication_utils/url_builder.dart';
import 'package:domus_app/dto/annuncio_dto.dart';
import 'package:domus_app/dto/utente_dto.dart';
import 'package:domus_app/services/aws_cognito.dart';
import 'package:http/http.dart' as http;

class AnnuncioService {
  static Future<int> creaAnnuncio(String tipoAnnuncio, String prezzo, String superficie, String indirizzo,
    String descrizione, bool isGarageSelected, bool isAscensoreSelected, bool isPiscinaSelected,
    bool isArredatoSelected, bool isBalconeSelected, bool isGiardinoSelected, String stanze, String numeroPiano,
    String sceltaClasseEnergetica, String sceltaPiano, double latitudine, double longitudine, String idUtente) async {

    AnnuncioDto nuovoAnnuncio = creaAnnuncioDto(tipoAnnuncio, prezzo, superficie, indirizzo, descrizione, isGarageSelected,
      isAscensoreSelected, isPiscinaSelected, isArredatoSelected, isBalconeSelected, isGiardinoSelected, stanze, numeroPiano,
      sceltaClasseEnergetica, sceltaPiano, latitudine, longitudine, idUtente);

      try {
        return await inviaAnnuncio(nuovoAnnuncio);
      } on TimeoutException {
        throw TimeoutException("Il server non risponde.");
      }
  }

  static Future<int> inviaAnnuncio(AnnuncioDto annuncio) async {
    final url = Urlbuilder.createUrl(Urlbuilder.LOCALHOST_ANDROID, Urlbuilder.PORTA_SPRINGBOOT, Urlbuilder.ENDPOINT_ANNUNCI);
    
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(annuncio),
    ).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw TimeoutException("Il server non risponde.");
      },
    );
    
    return response.statusCode;
  }

  static AnnuncioDto creaAnnuncioDto(String tipoAnnuncio, String prezzo, String superficie, String indirizzo,
    String descrizione, bool isGarageSelected, bool isAscensoreSelected, bool isPiscinaSelected,
    bool isArredatoSelected, bool isBalconeSelected, bool isGiardinoSelected, String stanze, String numeroPiano,
    String sceltaClasseEnergetica, String sceltaPiano, double latitudine, double longitudine, String idUtente){

    String prezzoStringa = prezzo;
    double prezzoDouble = double.parse(prezzoStringa);

    String superficieStringa = superficie;
    int superficieInt = int.parse(superficieStringa);

    String nStanzeStringa = stanze;
    int nStanzeInt = int.parse(nStanzeStringa);

    int? nPianoInt;

    if(sceltaPiano == "Intermedio") {
      String nPianoStringa = numeroPiano;
      nPianoInt = int.parse(nPianoStringa);
    }


    return AnnuncioDto(
      tipoAnnuncio: tipoAnnuncio.toUpperCase(),
      prezzo: prezzoDouble, 
      superficie: superficieInt, 
      numStanze: nStanzeInt, 
      garage: isGarageSelected, 
      ascensore: isAscensoreSelected, 
      piscina: isPiscinaSelected, 
      arredo: isArredatoSelected,
      balcone: isBalconeSelected,
      giardino: isGiardinoSelected,
      classeEnergetica: sceltaClasseEnergetica.toUpperCase(),
      piano: sceltaPiano.toUpperCase(),
      numeroPiano: nPianoInt,
      agente: idUtente,
      indirizzo: indirizzo,
      latitudine: latitudine,
      longitudine: longitudine,
      descrizione: descrizione,
    );
  }

  static Future<http.Response> chiamataHTTPrecuperaAnnunciByAgenteSub(String sub) async {
    final url = Urlbuilder.createUrl(Urlbuilder.LOCALHOST_ANDROID, Urlbuilder.PORTA_SPRINGBOOT, Urlbuilder.ENDOPOINT_ANNUNCI_AGENTE, queryParams: {'sub': sub});

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    ).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw TimeoutException("Il server non risponde.");
      },
    );
    
    return response;
  }

  static Future<List<AnnuncioDto>> recuperaAnnunciByAgenteSub(String sub) async {
    try{
      http.Response response = await chiamataHTTPrecuperaAnnunciByAgenteSub(sub);
      
      if(response.statusCode == 200){
        List<dynamic> data = json.decode(response.body);

        List<AnnuncioDto> annunci = data.map((item) => AnnuncioDto.fromJson(item)).toList();
        return annunci;        
      }
      else{
        throw Exception("Errore nel recupero degli annunci dell'agente");
      }

    } on TimeoutException {
      throw Exception("Errore nel recupero dell'utente.");
    }
  }

  static Future<List<AnnuncioDto>> recuperaAnnunciByAgenteLoggato() async{
    String? sub = await AWSServices().recuperaSubUtenteLoggato();
    return recuperaAnnunciByAgenteSub(sub!);
  }

  static Future<List<AnnuncioDto>> recuperaAnnunciByCriteriDiRicerca(
    double latitudine,
    double longitudine,
    String tipoAnnuncio, {
    double? raggioRicerca,
    String? prezzoMin,
    String? prezzoMax,
    String? superficieMin,
    String? superficieMax,
    String? nStanzeMin,
    String? nStanzeMax,
    bool? garage,
    bool? ascensore,
    bool? arredato,
    bool? giardino,
    bool? piscina,
    bool? balcone,
    bool? vicinoScuole,
    bool? vicinoParchi,
    bool? vicinoMezzi,
    String? piano,
    String? classeEnergetica,
  }) async {
    try{
      print("chiamo il server");
      http.Response response = await chiamataHTTPrecuperaAnnunciByCriteriDiRicerca(
        latitudine, 
        longitudine, 
        tipoAnnuncio, 
        raggioRicerca,
        prezzoMin: prezzoMin,
        prezzoMax: prezzoMax,
        superficieMin: superficieMin,
        superficieMax: superficieMax,
        nStanzeMin: nStanzeMin,
        nStanzeMax: nStanzeMax,
        garage: garage,
        ascensore: ascensore,
        arredato: arredato,
        giardino: giardino,
        piscina: piscina,
        balcone: balcone,
        vicinoScuole: vicinoScuole,
        vicinoParchi: vicinoParchi,
        vicinoMezzi: vicinoMezzi,
        piano: piano,
        classeEnergetica: classeEnergetica,);
      
      if(response.statusCode == 200){
        List<dynamic> data = json.decode(response.body);

        List<AnnuncioDto> annunci = data.map((item) => AnnuncioDto.fromJson(item)).toList();
        return annunci;        
      }
      else{
        throw Exception("Errore nel recupero degli annunci");
      }

    } on TimeoutException {
      throw Exception("Errore nel recupero degli annunci. Timeout");
    }
  }

  static Future<http.Response> chiamataHTTPrecuperaAnnunciByCriteriDiRicerca(
    double latitudine,
    double longitudine,
    String tipoAnnuncio,
    double? raggioRicerca, {
    String? prezzoMin,
    String? prezzoMax,
    String? superficieMin,
    String? superficieMax,
    String? nStanzeMin,
    String? nStanzeMax,
    bool? garage,
    bool? ascensore,
    bool? arredato,
    bool? giardino,
    bool? piscina,
    bool? balcone,
    bool? vicinoScuole,
    bool? vicinoParchi,
    bool? vicinoMezzi,
    String? piano,
    String? classeEnergetica,
  }) async {
    final url = Urlbuilder.createUrl(
      Urlbuilder.LOCALHOST_ANDROID, 
      Urlbuilder.PORTA_SPRINGBOOT, 
      Urlbuilder.ENDPOINT_ANNUNCI,
      queryParams: filterQueryParams({
        'tipo_annuncio' : tipoAnnuncio.toString().toUpperCase(),
        'latitudine': latitudine.toString(),
        'longitudine': longitudine.toString(),
        'raggioKm' : raggioRicerca.toString(),
        'prezzoMinimo' : prezzoMin.toString(),
        'prezzoMassimo' :prezzoMax.toString(),
        'superficieMinima' :superficieMin.toString(),
        'superficieMassima' : superficieMax.toString(),
        'numStanzeMinime' :nStanzeMin.toString(),
        'numStanzeMassime' : nStanzeMax.toString(),
        'garage' : garage.toString(),
        'ascensore' : ascensore.toString(),
        'arredo' : arredato.toString(),
        'giardino' : giardino.toString(),
        'piscina' : piscina.toString(),
        'balcone' : balcone.toString(),
        'vicino_scuole' : vicinoScuole.toString(),
        'vicino_parchi' : vicinoParchi.toString(),
        'vicino_trasporti' : vicinoMezzi.toString(),
        'piano' : piano.toString().toUpperCase(),
        'classeEnergetica' : classeEnergetica.toString().toUpperCase(),
      })
    );

    print("\n\n\n\n\n\n\n\n\n\n\n");
    print(url);
    print("\n\n\n\n\n\n\n\n\n\n\n");

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    ).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw TimeoutException("Il server non risponde.");
      },
    );
    
    return response;
  }

  static Map<String, String> filterQueryParams(Map<String, String> params) {
    // Rimuovi i parametri o nulli o vuoti o false
    params.removeWhere((key, value) {
      return value == "false" || value.isEmpty || value == "null";
    });
    return params;
  }

}