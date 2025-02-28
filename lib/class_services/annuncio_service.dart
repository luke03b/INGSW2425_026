import 'dart:async';
import 'dart:convert';
import 'package:domus_app/class_services/utente_service.dart';
import 'package:domus_app/communication_utils/url_builder.dart';
import 'package:domus_app/dto/annuncio_dto.dart';
import 'package:domus_app/dto/filtri_ricerca_dto.dart';
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
    final url = Urlbuilder.createUrl(Urlbuilder.LOCALHOST_ANDROID, Urlbuilder.PORTA_SPRINGBOOT, Urlbuilder.ENDPOINT_ANNUNCI_AGENTE, queryParams: {'sub': sub});

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
      }else{
        throw Exception("Errore nel recupero degli annunci dell'agente");
      }

    } on TimeoutException {
      throw TimeoutException("Errore nel recupero dell'utente.");
    }
  }

  static Future<List<AnnuncioDto>> recuperaAnnunciByAgenteLoggato() async{
    String? sub = await AWSServices().recuperaSubUtenteLoggato();
    return recuperaAnnunciByAgenteSub(sub!);
  }

  static Future<List<AnnuncioDto>> recuperaAnnunciByCriteriDiRicerca(FiltriRicercaDto filtriRicerca) async {
    try{
      http.Response response = await chiamataHTTPrecuperaAnnunciByCriteriDiRicerca(filtriRicerca);
      
      if(response.statusCode == 200){
        List<dynamic> data = json.decode(response.body);

        List<AnnuncioDto> annunci = data.map((item) => AnnuncioDto.fromJson(item)).toList();
        return annunci;        
      }else{
        throw Exception("Errore nel recupero degli annunci (non timeout)");
      }

    } on TimeoutException {
      throw TimeoutException("Errore nel recupero degli annunci. Timeout");
    }
  }

  static Future<http.Response> chiamataHTTPrecuperaAnnunciByCriteriDiRicerca(FiltriRicercaDto filtriRicerca) async {
    final url = Urlbuilder.createUrl(
      Urlbuilder.LOCALHOST_ANDROID, 
      Urlbuilder.PORTA_SPRINGBOOT, 
      Urlbuilder.ENDPOINT_ANNUNCI,
      queryParams: filtriRicerca.toJson()
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

  static Future<List<AnnuncioDto>> recuperaAnnunciRecentementeVisusalizzatiCliente(UtenteDto cliente) async {
    try{
      http.Response response = await chiamataHTTPrecuperaAnnunciRecentementeVisusalizzatiCliente(cliente);
      
      if(response.statusCode == 200){
        List<dynamic> data = json.decode(response.body);

        List<AnnuncioDto> annunci = data.map((item) => AnnuncioDto.fromJson(item)).toList();
        return annunci;        
      }else{
        throw Exception("Errore nel recupero degli annunci (non timeout)");
      }

    } on TimeoutException {
      throw TimeoutException("Errore nel recupero degli annunci. Timeout");
    }
  }

  static Future<http.Response> chiamataHTTPrecuperaAnnunciRecentementeVisusalizzatiCliente(UtenteDto cliente) async {
    final url = Urlbuilder.createUrl(
      Urlbuilder.LOCALHOST_ANDROID, 
      Urlbuilder.PORTA_SPRINGBOOT, 
      Urlbuilder.ENDPOINT_GET_ANNUNCI_RECENTI,
      queryParams: {'id' : cliente.id}
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

  static Future<List<AnnuncioDto>> recuperaAnnunciByClienteLoggato() async{
    String? sub = await AWSServices().recuperaSubUtenteLoggato();
    UtenteDto cliente = await UtenteService.recuperaUtenteBySub(sub!);
    return recuperaAnnunciRecentementeVisusalizzatiCliente(cliente);
  }

}