import 'dart:async';
import 'dart:convert';

import 'package:domus_app/back_end_communication/class_controllers/visita_controller.dart';
import 'package:domus_app/back_end_communication/class_services/utente_service.dart';
import 'package:domus_app/back_end_communication/dto/annuncio_dto.dart';
import 'package:domus_app/back_end_communication/dto/utente_dto.dart';
import 'package:domus_app/back_end_communication/dto/visita_dto.dart';
import 'package:domus_app/services/aws_cognito.dart';
import 'package:http/http.dart' as http;

class VisitaService {

  static Future<int> creaVisita(AnnuncioDto annuncio, String data, String orarioInizio) async {
    String? sub = await AWSServices().recuperaSubUtenteLoggato();
    UtenteDto? cliente = await UtenteService.recuperaUtenteBySub(sub!);

    return _creaVisitaCliente(cliente, annuncio, data, orarioInizio);
  }

  static Future<int> _creaVisitaCliente(UtenteDto cliente, AnnuncioDto annuncio, String data, String orarioInizio) async {
    VisitaDto offerta = VisitaDto(annuncio: annuncio, cliente: cliente, data: DateTime.parse(data), orarioInizio: orarioInizio);
    try{
      http.Response response = await VisitaController.chiamataHTTPcreaVisitaCliente(offerta);
      
      if(response.statusCode == 201){
        return response.statusCode;        
      }else{
        throw Exception("Errore nell'inserimento della visita");
      }

    } on TimeoutException {
      throw TimeoutException("Errore nell'inserimento della visita (i server potrebbero non essere raggiungibili).");
    }
  }

  static Future<List<VisitaDto>> recuperaVisiteAnnuncio(AnnuncioDto annuncio) async {
    try{
      http.Response response = await VisitaController.chiamataHTTPrecuperaVisiteAnnuncio(annuncio);
      
      if(response.statusCode == 200){
        List<dynamic> data = json.decode(response.body);

        List<VisitaDto> offerte = data.map((item) => VisitaDto.fromJson(item)).toList();
        return offerte;
      }else{
        throw Exception("Errore nel recupero delle visite");
      }
    } on TimeoutException {
      throw TimeoutException("Errore nel recupero delle visite (i server potrebbero non essere raggiungibili).");
    }
  }

  static Future<List<VisitaDto>> recuperaAnnunciConVisiteByClienteLoggato() async {
    String? sub = await AWSServices().recuperaSubUtenteLoggato();
    UtenteDto cliente = await UtenteService.recuperaUtenteBySub(sub!);
    return _recuperaAnnunciConVisiteCliente(cliente);
  }

  static Future<List<VisitaDto>> _recuperaAnnunciConVisiteCliente(UtenteDto cliente) async {
    try{
      http.Response response = await VisitaController.chiamataHTTPrecuperaVisiteByCliente(cliente);
      
      if(response.statusCode == 200){
        List<dynamic> data = json.decode(response.body);

        List<VisitaDto> offerte = data.map((item) => VisitaDto.fromJson(item)).toList();
        return offerte;
      }else{
        throw Exception("Errore nel recupero delle visite");
      }
    } on TimeoutException {
      throw TimeoutException("Errore nel recupero delle visite (i server potrebbero non essere raggiungibili).");
    }
  }

  static Future<List<VisitaDto>> recuperaTutteOfferteConStatoByAgenteLoggato(String stato) async {
    String? sub = await AWSServices().recuperaSubUtenteLoggato();
    try{
      http.Response response = await VisitaController.chiamataHTTPrecuperaTutteVisiteConStatoByAgente(stato, sub!);
      
      if(response.statusCode == 200){
        List<dynamic> data = json.decode(response.body);

        List<VisitaDto> offerte = data.map((item) => VisitaDto.fromJson(item)).toList();
        return offerte;
      }else{
        throw Exception("Errore nel recupero delle visite");
      }
    } on TimeoutException {
      throw TimeoutException("Errore nel recupero delle visite (i server potrebbero non essere raggiungibili).");
    }
  }

  static Future<List<VisitaDto>> recuperaVisiteConStatoByAnnuncio(AnnuncioDto annuncio, String stato) async {
    try{
      http.Response response = await VisitaController.chiamataHTTPrecuperaVisiteConStatoByAnnuncio(annuncio, stato);
      
      if(response.statusCode == 200){
        List<dynamic> data = json.decode(response.body);

        List<VisitaDto> offerte = data.map((item) => VisitaDto.fromJson(item)).toList();
        return offerte;
      }else{
        throw Exception("Errore nel recupero delle visite");
      }
    } on TimeoutException {
      throw TimeoutException("Errore nel recupero delle visite (i server potrebbero non essere raggiungibili).");
    }
  }

  static Future<int> aggiornaStatoVisita(VisitaDto visita, String stato) async {
    try{
      http.Response response = await VisitaController.chiamataHTTPaggiornaStatoVisita(visita, stato);
      
      if(response.statusCode == 200){
        return response.statusCode;        
      }else{
        throw Exception("Errore nell'aggiornamento dello stato della visita");
      }

    } on TimeoutException {
      throw TimeoutException("Errore nell'aggiornamento dello stato della visita (i server potrebbero non essere raggiungibili).");
    }
  }
}