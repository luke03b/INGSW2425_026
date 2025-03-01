import 'dart:async';
import 'dart:convert';

import 'package:domus_app/back_end_communication/class_controllers/offerta_controller.dart';
import 'package:domus_app/back_end_communication/class_services/utente_service.dart';
import 'package:domus_app/back_end_communication/dto/annuncio_dto.dart';
import 'package:domus_app/back_end_communication/dto/offerta_dto.dart';
import 'package:domus_app/back_end_communication/dto/utente_dto.dart';
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
      http.Response response = await OffertaController.chiamataHTTPcreaOffertaCliente(offerta);
      
      if(response.statusCode == 201){
        return response.statusCode;        
      }else{
        throw Exception("Errore nell'aggiornamento della cronologia");
      }

    } on TimeoutException {
      throw TimeoutException("Errore nell'aggiornamento della cronologia (i server potrebbero non essere raggiungibili).");
    }
  }

  static Future<List<OffertaDto>> recuperaOfferteByAnnuncio(AnnuncioDto annuncio) async {
    try{
      http.Response response = await OffertaController.chiamataHTTPrecuperaOfferteByAnnuncio(annuncio);
      
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
}