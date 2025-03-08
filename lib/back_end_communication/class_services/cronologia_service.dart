import 'dart:async';

import 'package:domus_app/back_end_communication/class_controllers/cronologia_controller.dart';
import 'package:domus_app/back_end_communication/class_services/utente_service.dart';
import 'package:domus_app/back_end_communication/dto/annuncio_dto.dart';
import 'package:domus_app/back_end_communication/dto/cronologia_dto.dart';
import 'package:domus_app/back_end_communication/dto/utente_dto.dart';
import 'package:domus_app/amazon_services/aws_cognito.dart';
import 'package:http/http.dart' as http;

class CronologiaService {
  static Future<int> aggiornaCronologiaUtente(AnnuncioDto? annuncio) async {
    String? sub = await AWSServices().recuperaSubUtenteLoggato();
    UtenteDto? cliente = await UtenteService.recuperaUtenteBySub(sub!);

    return aggiornaCronologiaCliente(cliente, annuncio!);
  }
  
  static Future<int> aggiornaCronologiaCliente(UtenteDto cliente, AnnuncioDto annuncio) async {
    CronologiaDto cronologia = CronologiaDto(cliente: cliente, annuncio: annuncio);
    try{
      http.Response response = await CronologiaController.chiamataHTTPaggiornaCronologiaCliente(cronologia);
      
      if(response.statusCode == 201){
        return response.statusCode;        
      }else{
        throw Exception("Errore nell'aggiornamento della cronologia");
      }

    } on TimeoutException {
      throw TimeoutException("Errore nell'aggiornamento della cronologia (i server potrebbero non essere raggiungibili).");
    }
  }
}