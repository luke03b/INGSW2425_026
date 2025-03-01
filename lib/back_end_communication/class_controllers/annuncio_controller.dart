import 'dart:async';
import 'dart:convert';

import 'package:domus_app/back_end_communication/communication_utils/url_builder.dart';
import 'package:domus_app/back_end_communication/dto/annuncio_dto.dart';
import 'package:domus_app/back_end_communication/dto/filtri_ricerca_dto.dart';
import 'package:domus_app/back_end_communication/dto/utente_dto.dart';
import 'package:http/http.dart' as http;

class AnnuncioController {
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
}