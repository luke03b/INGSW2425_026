import 'dart:async';
import 'dart:convert';

import 'package:domus_app/back_end_communication/communication_utils/url_builder.dart';
import 'package:domus_app/back_end_communication/dto/annuncio_dto.dart';
import 'package:domus_app/back_end_communication/dto/utente_dto.dart';
import 'package:domus_app/back_end_communication/dto/visita_dto.dart';
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

    print("\n\n\n\n\n\n\n\n");
    print(url);
    print("\n\n\n\n\n\n\n\n");

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
    print(UrlBuilder.ENDPOINT_POST_VISITE);
    final url = UrlBuilder.createUrl(
      UrlBuilder.PROTOCOL_HTTP, 
      UrlBuilder.LOCALHOST_ANDROID, 
      port: UrlBuilder.PORTA_SPRINGBOOT, 
      UrlBuilder.ENDPOINT_POST_VISITE,
    );

    print("\n\n\n\n\n\n\n");
    print(url);
    print("\n\n\n\n\n\n\n");
    print(json.encode(visita));

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

    print("\n\n\n\n\n\n\n\n");
    print(url);
    print("\n\n\n\n\n\n\n\n");

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