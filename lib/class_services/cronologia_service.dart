import 'dart:async';
import 'dart:convert';

import 'package:domus_app/class_services/utente_service.dart';
import 'package:domus_app/communication_utils/url_builder.dart';
import 'package:domus_app/dto/annuncio_dto.dart';
import 'package:domus_app/dto/cronologia_dto.dart';
import 'package:domus_app/dto/utente_dto.dart';
import 'package:domus_app/services/aws_cognito.dart';
import 'package:http/http.dart' as http;

class CronologiaService {
  static Future<int> aggiornaCronologiaUtente(AnnuncioDto? annuncio) async {
    String? sub = await AWSServices().recuperaSubUtenteLoggato();
    UtenteDto? cliente = await UtenteService.recuperaUtenteBySub(sub!);

    return _aggiornaCronologiaByClienteSub(cliente!, annuncio!);
  }
  
  static Future<int> _aggiornaCronologiaByClienteSub(UtenteDto cliente, AnnuncioDto annuncio) async {
    CronologiaDto cronologia = CronologiaDto(cliente: cliente, annuncio: annuncio);
    try{
      http.Response response = await _chiamataHTTPaggiornaCronologiaByCliente(cronologia);
      
      if(response.statusCode == 201){
        return response.statusCode;        
      }else{
        throw Exception("Errore nell'aggiornamento della cronologia");
      }

    } on TimeoutException {
      throw TimeoutException("Errore nell'aggiornamento della cronologia (i server potrebbero non essere raggiungibili).");
    }
  }

  static Future<http.Response> _chiamataHTTPaggiornaCronologiaByCliente(CronologiaDto cronologia) async {
    final url = Urlbuilder.createUrl(
      Urlbuilder.LOCALHOST_ANDROID, 
      Urlbuilder.PORTA_SPRINGBOOT, 
      Urlbuilder.ENDPOINT_POST_ANNUNCI_RECENTI,
    );

    print("\n\n\n\n\n\n\n");
    print(url);
    print("\n\n\n\n\n\n\n");
    print(json.encode(cronologia));

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(cronologia),
    ).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw TimeoutException("Il server non risponde.");
      },
    );
    
    return response;
  }
}