import 'package:domus_app/dto/annuncio_dto.dart';
import 'package:domus_app/dto/dto.dart';
import 'package:domus_app/dto/utente_dto.dart';

class OffertaDto implements DTO {

  final AnnuncioDto? annuncio;
  final UtenteDto? cliente;
  final double prezzo;
  final DateTime? data;

  OffertaDto({
    this.annuncio,
    this.cliente,
    required this.prezzo,
    this.data
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'annuncio' : annuncio,
      'cliente' : cliente,
      'prezzo' : prezzo,
    };
  }

  static OffertaDto fromJson(Map<String, dynamic> json) {
    return OffertaDto(
      prezzo: json["prezzo"],
      data: DateTime.parse(json["data"])
    );
  }
}