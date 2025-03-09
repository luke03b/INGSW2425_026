import 'package:domus_app/back_end_communication/dto/annuncio/annuncio_dto.dart';
import 'package:domus_app/back_end_communication/dto/dto.dart';
import 'package:domus_app/back_end_communication/dto/utente_dto.dart';

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
      "cliente": cliente.toJson(),
      "annuncio": annuncio.toJson(),
    };
  }

  static CronologiaDto fromJson(Map<String, dynamic> json) {
    return CronologiaDto(
      annuncio: AnnuncioDto.fromJson(json["annuncio"]),
      cliente: UtenteDto.fromJson(json["cliente"])
    );
  }
}