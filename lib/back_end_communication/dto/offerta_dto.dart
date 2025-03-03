import 'package:domus_app/back_end_communication/dto/annuncio_dto.dart';
import 'package:domus_app/back_end_communication/dto/dto.dart';
import 'package:domus_app/back_end_communication/dto/utente_dto.dart';

class OffertaDto implements DTO {

  final String? id;
  final AnnuncioDto annuncio;
  final UtenteDto cliente;
  final double prezzo;
  final DateTime? data;
  final String? stato;
  final double? controproposta;

  OffertaDto({
    this.id,
    required this.annuncio,
    required this.cliente,
    required this.prezzo,
    this.data,
    this.stato,
    this.controproposta,
  });

  @override
  Map<String, dynamic> toJson() {
   return {
      'id': id,
      'annuncio': annuncio.toJson(),
      'cliente': cliente.toJson(),
      'prezzo': prezzo,
      'controProposta' : controproposta,
    };
  }

  static OffertaDto fromJson(Map<String, dynamic> json) {
    return OffertaDto(
      id : json["id"],
      annuncio: AnnuncioDto.fromJson(json["annuncio"]),
      prezzo: json["prezzo"],
      data: DateTime.parse(json["data"]),
      stato: json["stato"],
      cliente: UtenteDto.fromJson(json["cliente"]),
      controproposta: json["controProposta"],
    );
  }
}