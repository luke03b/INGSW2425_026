import 'package:domus_app/dto/annuncio_dto.dart';
import 'package:domus_app/dto/dto.dart';
import 'package:domus_app/dto/utente_dto.dart';

class CronologiaDto implements DTO {

  final UtenteDto cliente;
  final AnnuncioDto annuncio;

  const CronologiaDto({
    required this.cliente,
    required this.annuncio,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "cliente": cliente,
      "annuncio": annuncio,
    };
  }

  static CronologiaDto fromJson(Map<String, dynamic> json) {
    return CronologiaDto(
      annuncio: json["annuncio"],
      cliente: json["cliente"]
    );
  }
}