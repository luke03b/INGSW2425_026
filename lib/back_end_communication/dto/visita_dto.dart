import 'package:domus_app/back_end_communication/dto/annuncio/annuncio_dto.dart';
import 'package:domus_app/back_end_communication/dto/dto.dart';
import 'package:domus_app/back_end_communication/dto/utente_dto.dart';

class VisitaDto implements DTO {
  String? id;
  AnnuncioDto annuncio;
  UtenteDto cliente;
  DateTime data;
  String orarioInizio;
  String? orarioFine;
  String? stato;

  VisitaDto({
    required this.annuncio,
    required this.cliente,
    required this.data,
    required this.orarioInizio,
    this.orarioFine,
    this.stato,
    this.id,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'annuncio' : annuncio.toJson(),
      'cliente' : cliente.toJson(),
      'data' : data.toIso8601String(),
      'orarioInizio' : orarioInizio,
      'orarioFine' : orarioFine,
      'stato' : stato
    };
  }

  static VisitaDto fromJson(Map<String, dynamic> json) {
    return VisitaDto(
      id : json["id"],
      annuncio: AnnuncioDto.fromJson(json["annuncio"]),
      cliente: UtenteDto.fromJson(json["cliente"]),
      data: DateTime.parse(json["data"]),
      orarioInizio: json["orarioInizio"],
      orarioFine: json["orarioFine"],
      stato: json["stato"]
    );
  }
}