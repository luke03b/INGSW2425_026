import 'dart:async';
import 'dart:convert';

import 'package:domus_app/back_end_communication/communication_utils/url_builder.dart';
import 'package:domus_app/back_end_communication/dto/annuncio_dto.dart';
import 'package:domus_app/back_end_communication/dto/utente_dto.dart';
import 'package:domus_app/back_end_communication/dto/visita_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VisitaController {
  static Future<http.Response> chiamataHTTPrecuperaVisiteAnnuncio(AnnuncioDto annuncio) async {
    final url = UrlBuilder.createUrl(
      UrlBuilder.PROTOCOL_HTTP, 
      UrlBuilder.LOCALHOST_ANDROID, 
      port: UrlBuilder.PORTA_SPRINGBOOT, 
      UrlBuilder.ENDPOINT_GET_VISITE_ANNUNCIO, 
      queryParams: { "idAnnuncio" : annuncio.idAnnuncio }
    );

    debugPrint("\n\n\n\n\n\n\n\n");
    debugPrint(url.toString());
    debugPrint("\n\n\n\n\n\n\n\n");

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

  static Future<http.Response> chiamataHTTPcreaVisitaCliente(VisitaDto visita) async {
    debugPrint(UrlBuilder.ENDPOINT_POST_VISITE);
    final url = UrlBuilder.createUrl(
      UrlBuilder.PROTOCOL_HTTP, 
      UrlBuilder.LOCALHOST_ANDROID, 
      port: UrlBuilder.PORTA_SPRINGBOOT, 
      UrlBuilder.ENDPOINT_POST_VISITE,
    );

    debugPrint("\n\n\n\n\n\n\n");
    debugPrint(url.toString());
    debugPrint("\n\n\n\n\n\n\n");
    debugPrint(json.encode(visita));

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(visita),
    ).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw TimeoutException("Il server non risponde.");
      },
    );

    debugPrint(response.body);
    
    return response;
  }

  static Future<http.Response> chiamataHTTPrecuperaVisiteByCliente(UtenteDto cliente) async {
    final url = UrlBuilder.createUrl(
      UrlBuilder.PROTOCOL_HTTP, 
      UrlBuilder.LOCALHOST_ANDROID, 
      port: UrlBuilder.PORTA_SPRINGBOOT, 
      UrlBuilder.ENDPOINT_GET_VISITE_CLIENTE, 
      queryParams: { "idCliente" : cliente.id }
    );

    debugPrint("\n\n\n\n\n\n\n\n");
    debugPrint(url.toString());
    debugPrint("\n\n\n\n\n\n\n\n");

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

  static Future<http.Response> chiamataHTTPrecuperaVisiteConStatoByAnnuncio(AnnuncioDto annuncio, String stato) async {
    final url = UrlBuilder.createUrl(
      UrlBuilder.PROTOCOL_HTTP, 
      UrlBuilder.LOCALHOST_ANDROID, 
      port: UrlBuilder.PORTA_SPRINGBOOT, 
      UrlBuilder.ENDPOINT_GET_VISITE_STATO,
      queryParams: { 
        "idAnnuncio" : annuncio.idAnnuncio,
        "stato" : stato.toUpperCase()
      }
    );

    debugPrint("\n\n\n\n\n\n\n\n");
    debugPrint(url.toString());
    debugPrint("\n\n\n\n\n\n\n\n");

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

  static Future<http.Response> chiamataHTTPrecuperaTutteVisiteConStatoByAgente(String stato, String sub) async {
    final url = UrlBuilder.createUrl(
      UrlBuilder.PROTOCOL_HTTP, 
      UrlBuilder.LOCALHOST_ANDROID, 
      port: UrlBuilder.PORTA_SPRINGBOOT, 
      UrlBuilder.ENDPOINT_GET_VISITE_AGENTE_STATO,
      queryParams: { 
        "stato" : stato.toUpperCase(),
        "subAgente" : sub,
      }
    );

    debugPrint("\n\n\n\n\n\n\n\n");
    debugPrint(url.toString());
    debugPrint("\n\n\n\n\n\n\n\n");

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

  static Future<http.Response> chiamataHTTPaggiornaStatoVisita(VisitaDto visita, String stato) async {
    final url = UrlBuilder.createUrl(
      UrlBuilder.PROTOCOL_HTTP, 
      UrlBuilder.LOCALHOST_ANDROID, 
      port: UrlBuilder.PORTA_SPRINGBOOT, 
      UrlBuilder.ENDPOINT_GET_VISITE_ANNUNCIO,
      queryParams: {"stato" : stato.toUpperCase()},
    );

    debugPrint("\n\n\n\n\n\n\n\n\n\n\n");
    debugPrint(url.toString());
    debugPrint("\n\n\n\n\n\n\n\n\n\n\n");
    debugPrint(json.encode(visita).toString());

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(visita),
    ).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw TimeoutException("Il server non risponde.");
      },
    );
    debugPrint(response.body);
    
    return response;
  }
}