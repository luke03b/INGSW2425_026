import 'package:domus_app/back_end_communication/dto/annuncio_dto.dart';
import 'package:domus_app/back_end_communication/dto/dto.dart';
import 'package:domus_app/back_end_communication/dto/utente_dto.dart';

class VisitaDto implements DTO {
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
  });

  @override
  Map<String, dynamic> toJson() {
    return {
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
      annuncio: AnnuncioDto.fromJson(json["annuncio"]),
      cliente: UtenteDto.fromJson(json["cliente"]),
      data: DateTime.parse(json["data"]),
      orarioInizio: json["orarioInizio"],
      orarioFine: json["orarioFine"],
      stato: json["stato"]
    );
  }
}