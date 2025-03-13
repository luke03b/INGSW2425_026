import 'dart:typed_data';

import 'package:domus_app/back_end_communication/dto/annuncio/annuncio_dto.dart';
import 'package:domus_app/back_end_communication/dto/dto.dart';
import 'package:domus_app/back_end_communication/dto/utente_dto.dart';
import 'package:image_picker/image_picker.dart';

class ImmaginiDto implements DTO{
  final String? id;
  final AnnuncioDto annuncio;
  final String url;
  Uint8List? imageBytes;

  ImmaginiDto({
    this.id,
    required this.annuncio,
    required this.url,
    this.imageBytes
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'annuncio' : annuncio.toJson(),
      'url' : url
    };
  }

  static ImmaginiDto fromJson(Map<String, dynamic> json){
    return ImmaginiDto(
      id: json["id"],
      annuncio: AnnuncioDto.fromJson(json["annuncio"]), 
      url: json["url"]
    );
  }

  static void ordinaImmaginiPerNumero(List<ImmaginiDto> immaginiList) {
    immaginiList.sort((a, b) {
      int numeroA = int.parse(a.url.split("_").last);
      int numeroB = int.parse(b.url.split("_").last);
      return numeroA.compareTo(numeroB);
    });
  }

}