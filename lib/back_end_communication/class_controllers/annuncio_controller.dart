import 'dart:async';
import 'dart:convert';

import 'package:domus_app/back_end_communication/communication_utils/url_builder.dart';
import 'package:domus_app/back_end_communication/dto/annuncio_dto.dart';
import 'package:domus_app/back_end_communication/dto/filtri_ricerca_dto.dart';
import 'package:domus_app/back_end_communication/dto/utente_dto.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class AnnuncioController {
  static Future<int> inviaAnnuncio(AnnuncioDto annuncio) async {
    final url = UrlBuilder.createUrl(
      UrlBuilder.PROTOCOL_HTTP, 
      UrlBuilder.LOCALHOST_ANDROID, 
      port: UrlBuilder.PORTA_SPRINGBOOT, 
      UrlBuilder.ENDPOINT_ANNUNCI
    );

    debugPrint("\n\n\n\n\n\n\n\n\n\n\n");
    debugPrint(url.toString());
    debugPrint("\n\n\n\n\n\n\n\n\n\n\n");
    debugPrint(json.encode(annuncio));
    
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
    final url = UrlBuilder.createUrl(UrlBuilder.PROTOCOL_HTTP, UrlBuilder.LOCALHOST_ANDROID, port: UrlBuilder.PORTA_SPRINGBOOT, UrlBuilder.ENDPOINT_ANNUNCI_AGENTE, queryParams: {'sub': sub});

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
    final url = UrlBuilder.createUrl(
      UrlBuilder.PROTOCOL_HTTP, 
      UrlBuilder.LOCALHOST_ANDROID, 
      port: UrlBuilder.PORTA_SPRINGBOOT, 
      UrlBuilder.ENDPOINT_ANNUNCI,
      queryParams: filtriRicerca.toJson()
    );

    debugPrint("\n\n\n\n\n\n\n\n\n\n\n");
    debugPrint(url.toString());
    debugPrint("\n\n\n\n\n\n\n\n\n\n\n");

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
    final url = UrlBuilder.createUrl(
      UrlBuilder.PROTOCOL_HTTP, 
      UrlBuilder.LOCALHOST_ANDROID, 
      port: UrlBuilder.PORTA_SPRINGBOOT, 
      UrlBuilder.ENDPOINT_GET_ANNUNCI_RECENTI,
      queryParams: {'idCliente' : cliente.id}
    );

    debugPrint("\n\n\n\n\n\n\n\n\n\n\n");
    debugPrint(url.toString());
    debugPrint("\n\n\n\n\n\n\n\n\n\n\n");

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

  static Future<http.Response> chiamataHTTPrecuperaAnnunciByAgenteSubConOffertePrenotazioni(String sub, bool offerte, bool prenotazioni, bool disponibili) async {
    final url = UrlBuilder.createUrl(
      UrlBuilder.PROTOCOL_HTTP, 
      UrlBuilder.LOCALHOST_ANDROID, 
      port: UrlBuilder.PORTA_SPRINGBOOT, 
      UrlBuilder.ENDPOINT_GET_ANNUNCI_CON_OFFERTE_PRENOTAZIONI, 
      queryParams: {
        'sub': sub,
        'offerte' : offerte.toString(),
        'prenotazioni' : prenotazioni.toString(),
        'disponibili' : disponibili.toString()
      }
    );

    debugPrint("\n\n\n\n\n\n\n\n\n\n\n");
    debugPrint(url.toString());
    debugPrint("\n\n\n\n\n\n\n\n\n\n\n");

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

  static Future<http.Response> chiamataHTTPrecuperaAnnunciById(String idAnnuncio) async {
    final url = UrlBuilder.createUrl(
      UrlBuilder.PROTOCOL_HTTP, 
      UrlBuilder.LOCALHOST_ANDROID, 
      port: UrlBuilder.PORTA_SPRINGBOOT, 
      UrlBuilder.ENDPOINT_GET_ANNUNCI_BY_ID, 
      queryParams: {
        "idAnnuncio" : idAnnuncio
      }
    );

    debugPrint("\n\n\n\n\n\n\n\n\n\n\n");
    debugPrint(url.toString());
    debugPrint("\n\n\n\n\n\n\n\n\n\n\n");

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