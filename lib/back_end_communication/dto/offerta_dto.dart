import 'package:domus_app/back_end_communication/dto/annuncio_dto.dart';
import 'package:domus_app/back_end_communication/dto/dto.dart';
import 'package:domus_app/back_end_communication/dto/utente_dto.dart';

class OffertaDto implements DTO {

  final String? id;
  final AnnuncioDto annuncio;
  final UtenteDto? cliente;
  final double prezzo;
  final DateTime? data;
  final String? stato;
  final double? controproposta;
  final String? nomeOfferente;
  final String? cognomeOfferente;
  final String? emailOfferente;

  OffertaDto({
    this.id,
    required this.annuncio,
    this.cliente,
    required this.prezzo,
    this.data,
    this.stato,
    this.controproposta,
    this.nomeOfferente,
    this.cognomeOfferente,
    this.emailOfferente
  });

  @override
  Map<String, dynamic> toJson() {
   return {
      'id': id,
      'annuncio': annuncio.toJson(),
      'cliente': cliente?.toJson(),
      'prezzo': prezzo,
      'controProposta' : controproposta,
      'nomeOfferente' : nomeOfferente,
      'cognomeOfferente' : cognomeOfferente,
      'emailOfferente' : emailOfferente,
    };
  }

  static OffertaDto fromJson(Map<String, dynamic> json) {
    return OffertaDto(
      id : json["id"],
      annuncio: AnnuncioDto.fromJson(json["annuncio"]),
      prezzo: json["prezzo"],
      data: json["data"] != null ? DateTime.parse(json["data"]) : null,
      stato: json["stato"],
      cliente: json["cliente"] != null ? UtenteDto.fromJson(json["cliente"]) : null,
      controproposta: json["controProposta"],
      nomeOfferente: json["nomeOfferente"],
      cognomeOfferente: json["cognomeOfferente"],
      emailOfferente: json["emailOfferente"],
    );
  }
}