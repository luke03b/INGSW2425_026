import 'package:domus_app/dto/annuncio_dto.dart';
import 'package:domus_app/dto/dto.dart';
import 'package:domus_app/dto/utente_dto.dart';

class OffertaDto implements DTO {

  final AnnuncioDto annuncio;
  final UtenteDto cliente;
  final double prezzo;

  OffertaDto({
    required this.annuncio,
    required this.cliente,
    required this.prezzo,
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
      annuncio: json["annuncio"],
      cliente: json["cliente"],
      prezzo: json["prezzo"],
    );
  }
}