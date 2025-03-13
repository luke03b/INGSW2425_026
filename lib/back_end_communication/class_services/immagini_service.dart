import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:domus_app/amazon_services/aws_s3.dart';
import 'package:domus_app/back_end_communication/class_controllers/immagini_controller.dart';
import 'package:domus_app/back_end_communication/class_controllers/offerta_controller.dart';
import 'package:domus_app/back_end_communication/class_services/utente_service.dart';
import 'package:domus_app/back_end_communication/dto/annuncio/annuncio_dto.dart';
import 'package:domus_app/back_end_communication/dto/immagini_dto.dart';
import 'package:domus_app/back_end_communication/dto/offerta_dto.dart';
import 'package:domus_app/back_end_communication/dto/utente_dto.dart';
import 'package:domus_app/amazon_services/aws_cognito.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImmaginiService {
  static Future<List<ImmaginiDto>> recuperaTutteImmaginiByAnnuncio(AnnuncioDto annuncio) async {
    try{
      http.Response response = await ImmaginiController.chiamataHTTPrecuperaTutteImmaginiByAnnuncio(annuncio);
      
      if(response.statusCode == 200){
        List<dynamic> data = json.decode(response.body);

        List<ImmaginiDto> immagini = data.map((item) => ImmaginiDto.fromJson(item)).toList();
        return immagini;
      }else{
        throw Exception("Errore nel recupero delle immagini");
      }
    } on TimeoutException {
      throw TimeoutException("Errore nel recupero delle immagini (i server potrebbero non essere raggiungibili).");
    }
  }

  static Future<Uint8List> recuperaFileImmagine(String fileName) async{
    try{
      http.Response response = await ImmaginiController.chiamataHTTPrecuperaS3UrlImmagineByNome(fileName);
      
      if(response.statusCode == 200){
        Uri dat = Uri.parse(response.body);

        http.Response response2 = await S3Services.chiamataHTTPrecuperaImmaginiByUrl(dat);

        if (response2.statusCode == 200) {
          return response2.bodyBytes;
        }else{
          throw Exception("Errore nel recupero del file immagine");
        }
      }else{
        throw Exception("Errore nel recupero del link immagine");
      }
    } on TimeoutException {
      throw TimeoutException("Errore nel recupero dell'immagine (i server potrebbero non essere raggiungibili).");
    }
  }
}