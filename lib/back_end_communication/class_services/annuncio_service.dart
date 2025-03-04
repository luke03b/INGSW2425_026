import 'dart:async';
import 'dart:convert';
import 'package:domus_app/back_end_communication/class_controllers/annuncio_controller.dart';
import 'package:domus_app/back_end_communication/class_services/utente_service.dart';
import 'package:domus_app/back_end_communication/dto/annuncio_dto.dart';
import 'package:domus_app/back_end_communication/dto/filtri_ricerca_dto.dart';
import 'package:domus_app/back_end_communication/dto/utente_dto.dart';
import 'package:domus_app/services/aws_cognito.dart';
import 'package:http/http.dart' as http;

class AnnuncioService {
  static Future<int> creaAnnuncio(String tipoAnnuncio, String prezzo, String superficie, String indirizzo,
    String descrizione, bool isGarageSelected, bool isAscensoreSelected, bool isPiscinaSelected,
    bool isArredatoSelected, bool isBalconeSelected, bool isGiardinoSelected, String stanze, String numeroPiano,
    String sceltaClasseEnergetica, String sceltaPiano, double latitudine, double longitudine, UtenteDto agente) async {

    AnnuncioDto nuovoAnnuncio = _creaAnnuncioDto(tipoAnnuncio, prezzo, superficie, indirizzo, descrizione, isGarageSelected,
      isAscensoreSelected, isPiscinaSelected, isArredatoSelected, isBalconeSelected, isGiardinoSelected, stanze, numeroPiano,
      sceltaClasseEnergetica, sceltaPiano, latitudine, longitudine, agente);

      try {
        return await AnnuncioController.inviaAnnuncio(nuovoAnnuncio);
      } on TimeoutException {
        throw TimeoutException("Il server non risponde.");
      }
  }

  static AnnuncioDto _creaAnnuncioDto(String tipoAnnuncio, String prezzo, String superficie, String indirizzo,
    String descrizione, bool isGarageSelected, bool isAscensoreSelected, bool isPiscinaSelected,
    bool isArredatoSelected, bool isBalconeSelected, bool isGiardinoSelected, String stanze, String numeroPiano,
    String sceltaClasseEnergetica, String sceltaPiano, double latitudine, double longitudine, UtenteDto agente){

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
      agente: agente,
      indirizzo: indirizzo,
      latitudine: latitudine,
      longitudine: longitudine,
      descrizione: descrizione,
    );
  }

  static Future<List<AnnuncioDto>> _recuperaAnnunciByAgenteSub(String sub) async {
    try{
      http.Response response = await AnnuncioController.chiamataHTTPrecuperaAnnunciByAgenteSub(sub);
      
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
    return _recuperaAnnunciByAgenteSub(sub!);
  }

  static Future<List<AnnuncioDto>> recuperaAnnunciByCriteriDiRicerca(FiltriRicercaDto filtriRicerca) async {
    try{
      http.Response response = await AnnuncioController.chiamataHTTPrecuperaAnnunciByCriteriDiRicerca(filtriRicerca);
      
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

  static Future<List<AnnuncioDto>> _recuperaAnnunciRecentementeVisusalizzatiCliente(UtenteDto cliente) async {
    try{
      http.Response response = await AnnuncioController.chiamataHTTPrecuperaAnnunciRecentementeVisusalizzatiCliente(cliente);
      
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

  static Future<List<AnnuncioDto>> recuperaAnnunciRecentementeVisualizzatiByClienteLoggato() async {
    String? sub = await AWSServices().recuperaSubUtenteLoggato();
    UtenteDto cliente = await UtenteService.recuperaUtenteBySub(sub!);
    return _recuperaAnnunciRecentementeVisusalizzatiCliente(cliente);
  }

  static Future<List<AnnuncioDto>> recuperaAnnunciByAgenteLoggatoConOffertePrenotazioniInAttesa(bool offerte, bool prenotazioni) async{
    String? sub = await AWSServices().recuperaSubUtenteLoggato();
    return _recuperaAnnunciByAgenteSubConOffertePrenotazioniInAttesa(sub!, offerte, prenotazioni);
  }

   static Future<List<AnnuncioDto>> _recuperaAnnunciByAgenteSubConOffertePrenotazioniInAttesa(String sub, bool offerte, bool prenotazioni) async {
    try{
      http.Response response = await AnnuncioController.chiamataHTTPrecuperaAnnunciByAgenteSubConOffertePrenotazioni(sub, offerte, prenotazioni);
      
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

}