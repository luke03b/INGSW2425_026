import 'dart:async';
import 'dart:convert';

import 'package:domus_app/class_services/utente_service.dart';
import 'package:domus_app/communication_utils/url_builder.dart';
import 'package:domus_app/dto/annuncio_dto.dart';
import 'package:domus_app/dto/offerta_dto.dart';
import 'package:domus_app/dto/utente_dto.dart';
import 'package:domus_app/services/aws_cognito.dart';
import 'package:http/http.dart' as http;

class OffertaService {

  static Future<int> creaOfferta(AnnuncioDto annuncio, String prezzo) async {
    String? sub = await AWSServices().recuperaSubUtenteLoggato();
    UtenteDto? cliente = await UtenteService.recuperaUtenteBySub(sub!);

    return _creaOffertaCliente(cliente, annuncio, prezzo);
  }

  static Future<int> _creaOffertaCliente(UtenteDto cliente, AnnuncioDto annuncio, String prezzo) async {
    OffertaDto offerta = OffertaDto(annuncio: annuncio, cliente: cliente, prezzo: double.parse(prezzo));
    try{
      http.Response response = await _chiamataHTTPcreaOffertaCliente(offerta);
      
      if(response.statusCode == 201){
        return response.statusCode;        
      }else{
        throw Exception("Errore nell'aggiornamento della cronologia");
      }

    } on TimeoutException {
      throw TimeoutException("Errore nell'aggiornamento della cronologia (i server potrebbero non essere raggiungibili).");
    }
  }

  static Future<http.Response> _chiamataHTTPcreaOffertaCliente(OffertaDto offerta) async {
    final url = Urlbuilder.createUrl(
      Urlbuilder.LOCALHOST_ANDROID, 
      Urlbuilder.PORTA_SPRINGBOOT, 
      Urlbuilder.ENDPOINT_POST_OFFERTE,
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

  static Future<List<OffertaDto>> recuperaOfferteByAnnuncio(AnnuncioDto annuncio) async {
    try{
      http.Response response = await _chiamataHTTPrecuperaOfferteByAnnuncio(annuncio);
      
      if(response.statusCode == 200){
        List<dynamic> data = json.decode(response.body);

        List<OffertaDto> offerte = data.map((item) => OffertaDto.fromJson(item)).toList();
        return offerte;
      }else{
        throw Exception("Errore nel recupero delle offerte");
      }
    } on TimeoutException {
      throw TimeoutException("Errore nel recupero delle offerte (i server potrebbero non essere raggiungibili).");
    }
  }

  static Future<http.Response> _chiamataHTTPrecuperaOfferteByAnnuncio(AnnuncioDto annuncio) async {
    print(annuncio.idAnnuncio);
    final url = Urlbuilder.createUrl(
      Urlbuilder.LOCALHOST_ANDROID, 
      Urlbuilder.PORTA_SPRINGBOOT, 
      Urlbuilder.ENDPOINT_GET_OFFERTE, 
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
}