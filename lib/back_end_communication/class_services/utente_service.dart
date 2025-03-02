import 'dart:async';
import 'dart:convert';
import 'package:domus_app/back_end_communication/class_controllers/utente_controller.dart';
import 'package:domus_app/back_end_communication/dto/agenzia_immobiliare_dto.dart';
import 'package:domus_app/back_end_communication/dto/utente_dto.dart';
import 'package:http/http.dart' as http;

class UtenteService{
  static UtenteDto creaUtenteDto(String sub, String tipo, String nome, String cognome, String email, AgenziaImmobiliareDto? agenziaImmobiliare){
    return UtenteDto(sub: sub, tipo: tipo, nome: nome, cognome: cognome, email: email, agenziaImmobiliare: agenziaImmobiliare);
  }

  static Future<int> creaUtente(String sub, String tipo, String nome, String cognome, String email, AgenziaImmobiliareDto? agenziaImmobiliare) async{
    UtenteDto utenteDto = creaUtenteDto(sub, tipo, nome, cognome, email, agenziaImmobiliare);

    try {
        return await UtenteController.inviaUtente(utenteDto);
      } on TimeoutException {
        throw TimeoutException("Il server non risponde.");
      }
  }

  static Future<UtenteDto> recuperaUtenteBySub(String sub) async {
    try {
      http.Response response = await UtenteController.chiamataHTTPRecuperaUtenteBySub(sub);
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

  static Future<AgenziaImmobiliareDto?> recuperaAgenziaDaUtenteSub (String sub) async {
    UtenteDto utenteDto = await recuperaUtenteBySub(sub);
    return utenteDto.agenziaImmobiliare ?? null;
  }
}