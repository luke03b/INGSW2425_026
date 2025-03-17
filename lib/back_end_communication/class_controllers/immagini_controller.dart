import 'dart:async';
import 'dart:convert';

import 'package:domus_app/back_end_communication/communication_utils/url_builder.dart';
import 'package:domus_app/back_end_communication/dto/annuncio/annuncio_dto.dart';
import 'package:domus_app/back_end_communication/dto/offerta_dto.dart';
import 'package:domus_app/back_end_communication/dto/utente_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImmaginiController {
  static Future<http.Response> chiamataHTTPrecuperaTutteImmaginiByAnnuncio(AnnuncioDto annuncio) async {
    print(annuncio.idAnnuncio);
    final url = UrlBuilder.createUrl(
      UrlBuilder.PROTOCOL_HTTP, 
      UrlBuilder.INDIRIZZO_IN_USO, 
      port: UrlBuilder.PORTA_SPRINGBOOT, 
      UrlBuilder.ENDPOINT_GET_IMMAGINI, 
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

  static Future<http.Response> chiamataHTTPrecuperaS3UrlImmagineByNome(String nomeImmagine) async{
    final url = UrlBuilder.createUrl(
      UrlBuilder.PROTOCOL_HTTP, 
      UrlBuilder.INDIRIZZO_IN_USO,
      port: UrlBuilder.PORTA_SPRINGBOOT, 
      UrlBuilder.ENDPOINT_IMMAGINI_S3_DOWNLOAD_PRESIGNED_URL,
      queryParams: {"fileName" : nomeImmagine}
    );

    final response = await http.get(url, headers: {"Content-Type" : 'application/json'}).timeout(const Duration(seconds: 30), onTimeout: () {throw TimeoutException("Il server non risponde.");},);

    return response;
  }
}