import 'dart:async';
import 'dart:convert';
import 'package:domus_app/communication_utils/url_builder.dart';
import 'package:domus_app/dto/utente_dto.dart';
import 'package:http/http.dart' as http;

class UtenteService{
  static UtenteDto creaUtenteDto(String sub, String tipo, String? agenziaImmobiliare){
    return UtenteDto(sub: sub, tipo: tipo, agenziaImmobiliare: agenziaImmobiliare);
  }

  static Future<int> creaUtente(String sub, String tipo, String? agenziaImmobiliare) async{
    UtenteDto utenteDto = creaUtenteDto(sub, tipo, agenziaImmobiliare);

    try {
        return await inviaUtente(utenteDto);
      } on TimeoutException {
        throw TimeoutException("Il server non risponde.");
      }
  }

  static Future<int> inviaUtente(UtenteDto utente) async {
    final url = Urlbuilder.createUrl(Urlbuilder.LOCALHOST_ANDROID, Urlbuilder.PORTA_SPRINGBOOT, Urlbuilder.ENDPOINT_UTENTI);
    
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(utente),
    ).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw TimeoutException("Il server non risponde.");
      },
    );
    
    return response.statusCode;
  }

  static Future<UtenteDto> recuperaUtenteBySub(String sub) async {
    try {
      http.Response response = await chiamataHTTPRecuperaUtenteBySub(sub);
      print(response);
      print(response.body);

        // Verifica che la risposta sia OK
      if (response.statusCode == 200) {
        // Se la risposta è corretta, deserializza il corpo JSON e mappalo all'oggetto UtenteDto
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        print(UtenteDto.fromJson(jsonResponse));
        print(UtenteDto.fromJson(jsonResponse).id);
        return UtenteDto.fromJson(jsonResponse); // Chiama fromJson per creare l'oggetto UtenteDto
      } else {
        // Se la risposta non è OK, lancia un'eccezione
        throw Exception("Errore nel recupero dell'utente.");
      }
    } on TimeoutException {
      throw TimeoutException("Il server non risponde.");
    }
  }

  static Future<http.Response> chiamataHTTPRecuperaUtenteBySub(String sub) async{
    final url = Urlbuilder.createUrl(Urlbuilder.LOCALHOST_ANDROID, Urlbuilder.PORTA_SPRINGBOOT, Urlbuilder.ENDPOINT_UTENTI, queryParams: {'sub': sub});

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

  static Future<String?> recuperaAgenziaDaUtenteSub (String sub) async{
    UtenteDto utenteDto = await recuperaUtenteBySub(sub);
    return utenteDto.agenziaImmobiliare ?? null;
  }
}