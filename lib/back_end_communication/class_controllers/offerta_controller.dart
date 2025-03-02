import 'dart:async';
import 'dart:convert';

import 'package:domus_app/back_end_communication/communication_utils/url_builder.dart';
import 'package:domus_app/back_end_communication/dto/annuncio_dto.dart';
import 'package:domus_app/back_end_communication/dto/offerta_dto.dart';
import 'package:domus_app/back_end_communication/dto/utente_dto.dart';
import 'package:http/http.dart' as http;

class OffertaController {
  static Future<http.Response> chiamataHTTPcreaOffertaCliente(OffertaDto offerta) async {
    final url = UrlBuilder.createUrl(
      UrlBuilder.PROTOCOL_HTTP, 
      UrlBuilder.LOCALHOST_ANDROID, 
      port: UrlBuilder.PORTA_SPRINGBOOT, 
      UrlBuilder.ENDPOINT_POST_OFFERTE,
    );

    print("\n\n\n\n\n\n\n");
    print(url);
    print("\n\n\n\n\n\n\n");
    print(json.encode(offerta));

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(offerta),
    ).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw TimeoutException("Il server non risponde.");
      },
    );
    
    return response;
  }

  static Future<http.Response> chiamataHTTPrecuperaOfferteByAnnuncio(AnnuncioDto annuncio) async {
    print(annuncio.idAnnuncio);
    final url = UrlBuilder.createUrl(
      UrlBuilder.PROTOCOL_HTTP, 
      UrlBuilder.LOCALHOST_ANDROID, 
      port: UrlBuilder.PORTA_SPRINGBOOT, 
      UrlBuilder.ENDPOINT_GET_OFFERTE, 
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

  static Future<http.Response> chiamataHTTPrecuperaAnnunciConOfferteCliente(UtenteDto cliente) async {
    final url = UrlBuilder.createUrl(
      UrlBuilder.PROTOCOL_HTTP, 
      UrlBuilder.LOCALHOST_ANDROID, 
      port: UrlBuilder.PORTA_SPRINGBOOT, 
      UrlBuilder.ENDPOINT_GET_ANNUNCI_OFFERTE,
      queryParams: {'idCliente' : cliente.id}
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

  static Future<http.Response> chiamataHTTPrifiutaOfferta(OffertaDto offerta, String stato) async {
    final url = UrlBuilder.createUrl(
      UrlBuilder.PROTOCOL_HTTP, 
      UrlBuilder.LOCALHOST_ANDROID, 
      port: UrlBuilder.PORTA_SPRINGBOOT, 
      UrlBuilder.ENDPOINT_GET_OFFERTE,
      queryParams: {"stato" : stato.toUpperCase()}
    );

    print("\n\n\n\n\n\n\n\n\n\n\n");
    print(url);
    print("\n\n\n\n\n\n\n\n\n\n\n");

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(offerta),
    ).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw TimeoutException("Il server non risponde.");
      },
    );

    print(json.encode(offerta));
    print(response.body);
    
    return response;
  }
}