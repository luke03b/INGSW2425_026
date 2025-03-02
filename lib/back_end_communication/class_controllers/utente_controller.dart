import 'dart:async';
import 'dart:convert';

import 'package:domus_app/back_end_communication/communication_utils/url_builder.dart';
import 'package:domus_app/back_end_communication/dto/utente_dto.dart';
import 'package:http/http.dart' as http;

class UtenteController {
  static Future<int> inviaUtente(UtenteDto utente) async {
    final url = UrlBuilder.createUrl(UrlBuilder.PROTOCOL_HTTP, UrlBuilder.LOCALHOST_ANDROID, port: UrlBuilder.PORTA_SPRINGBOOT, UrlBuilder.ENDPOINT_UTENTI);
    
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

  static Future<http.Response> chiamataHTTPRecuperaUtenteBySub(String sub) async{
    final url = UrlBuilder.createUrl(UrlBuilder.PROTOCOL_HTTP, UrlBuilder.LOCALHOST_ANDROID, port: UrlBuilder.PORTA_SPRINGBOOT, UrlBuilder.ENDPOINT_UTENTI, queryParams: {'sub': sub});

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
}