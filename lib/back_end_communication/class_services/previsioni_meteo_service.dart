import 'dart:async';
import 'dart:convert';

import 'package:domus_app/back_end_communication/class_controllers/previsioni_meteo_controller.dart';
import 'package:domus_app/back_end_communication/dto/previsioni_meteo_dto.dart';
import 'package:http/http.dart' as http;

class PrevisioniMeteoService {
  static Future<PrevisioniMeteoDto> recuperaPrevisioniMeteo(double latitudine, double longitudine) async {
    try{
      http.Response response = await PrevisioniMeteoController.chiamataHTTPrecuperaPrevisioniMeteo(latitudine, longitudine);
      
      if(response.statusCode == 200){
        PrevisioniMeteoDto previsioniMeteo = PrevisioniMeteoDto.fromJson(json.decode(response.body));

        return previsioniMeteo;
      }else{
        throw Exception("Errore nel recupero degli annunci (non timeout)");
      }

    } on TimeoutException {
      throw TimeoutException("Errore nel recupero degli annunci. Timeout");
    }
  }
}