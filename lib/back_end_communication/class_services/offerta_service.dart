import 'dart:async';
import 'dart:convert';

import 'package:domus_app/back_end_communication/class_controllers/offerta_controller.dart';
import 'package:domus_app/back_end_communication/class_services/utente_service.dart';
import 'package:domus_app/back_end_communication/dto/annuncio_dto.dart';
import 'package:domus_app/back_end_communication/dto/offerta_dto.dart';
import 'package:domus_app/back_end_communication/dto/utente_dto.dart';
import 'package:domus_app/amazon_services/aws_cognito.dart';
import 'package:http/http.dart' as http;

class OffertaService {

  static Future<int> creaOfferta(AnnuncioDto annuncio, String prezzo, {String? nomeOfferente, String? cognomeOfferente, String? emailOfferente}) async {
    try {
      if(nomeOfferente != null && cognomeOfferente != null && emailOfferente != null){
        return _creaOffertaCliente(annuncio, prezzo, nomeOfferente: nomeOfferente, cognomeOfferente: cognomeOfferente, emailOfferente: emailOfferente);
      } else {
        String? sub = await AWSServices().recuperaSubUtenteLoggato();
        UtenteDto? cliente = await UtenteService.recuperaUtenteBySub(sub!);
        return _creaOffertaCliente(cliente: cliente, annuncio, prezzo);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<int> _creaOffertaCliente(AnnuncioDto annuncio, String prezzo, {UtenteDto? cliente, String? nomeOfferente, String? cognomeOfferente, String? emailOfferente}) async {
    OffertaDto offerta;
    if(cliente != null) {
      offerta = OffertaDto(annuncio: annuncio, cliente: cliente, prezzo: double.parse(prezzo));
    } else {
      offerta = OffertaDto(annuncio: annuncio, prezzo: double.parse(prezzo), nomeOfferente: nomeOfferente, cognomeOfferente: cognomeOfferente, emailOfferente: emailOfferente);
    }
    print(offerta.toString());
    try{
      http.Response response = await OffertaController.chiamataHTTPcreaOfferta(offerta);
      
      if(response.statusCode == 201){
        return response.statusCode;        
      } else if (response.statusCode == 400) {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        throw Exception(errorBody["error"]);
      } else {
        throw Exception("Errore sconosciuto: ${response.statusCode} ${response.body}");
      }
    } on TimeoutException {
      throw TimeoutException("Errore nell'aggiornamento della cronologia (i server potrebbero non essere raggiungibili).");
    }
  }

  static Future<List<OffertaDto>> recuperaTutteOfferteByAnnuncio(AnnuncioDto annuncio) async {
    try{
      http.Response response = await OffertaController.chiamataHTTPrecuperaTutteOfferteByAnnuncio(annuncio);
      
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

  static Future<List<OffertaDto>> recuperaOfferteConStatoByAnnuncio(AnnuncioDto annuncio, String stato) async {
    try{
      http.Response response = await OffertaController.chiamataHTTPrecuperaOfferteConStatoByAnnuncio(annuncio, stato);
      
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

  static Future<List<OffertaDto>> _recuperaAnnunciConOfferteCliente(UtenteDto cliente) async {
    try{
      http.Response response = await OffertaController.chiamataHTTPrecuperaAnnunciConOfferteCliente(cliente);
      
      if(response.statusCode == 200){
        List<dynamic> data = json.decode(response.body);

        List<OffertaDto> offerte = data.map((item) => OffertaDto.fromJson(item)).toList();
        return offerte;        
      }else{
        throw Exception("Errore nel recupero degli annunci (non timeout)");
      }

    } on TimeoutException {
      throw TimeoutException("Errore nel recupero degli annunci. Timeout");
    }
  }

  static Future<List<OffertaDto>> recuperaAnnunciConOfferteByClienteLoggato() async {
    String? sub = await AWSServices().recuperaSubUtenteLoggato();
    UtenteDto cliente = await UtenteService.recuperaUtenteBySub(sub!);
    return _recuperaAnnunciConOfferteCliente(cliente);
  }

  static Future<int> aggiornaStatoOfferta(OffertaDto offerta, String stato, {double? controproposta}) async {
    try{
      http.Response response = await OffertaController.chiamataHTTPaggiornaStatoOfferta(offerta, stato, controproposta: controproposta);
      
      if(response.statusCode == 200){
        return response.statusCode;        
      }else{
        throw Exception("Errore nell'aggiornamento dello stato dell'offerta");
      }

    } on TimeoutException {
      throw TimeoutException("Errore nell'aggiornamento dello stato dell'offerta (i server potrebbero non essere raggiungibili).");
    }
  }

}