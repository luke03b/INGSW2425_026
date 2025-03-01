import 'package:domus_app/back_end_communication/dto/dto.dart';

class UtenteDto implements DTO{
  String? id;
  String sub;
  String tipo;
  String? agenziaImmobiliare;

  UtenteDto({
    this.id,
    required this.sub,
    required this.tipo,
    this.agenziaImmobiliare
  });

  @override
  Map<String, dynamic> toJson() {
    if (agenziaImmobiliare == null){
      return {
        "id" : id,
        "sub": sub,
        "tipo": tipo,
        "agenzia" : agenziaImmobiliare
      };
    }

    return {
      "id" : id,
      "sub": sub,
      "tipo": tipo,
      "agenzia" : {
        "id": agenziaImmobiliare
      }
    };
  }

  static UtenteDto fromJson(Map<String, dynamic> json) {
    if(json["agenzia"] != null){
      return UtenteDto(
        id: json['id'],
        sub: json['sub'],
        tipo: json['tipo'],
        agenziaImmobiliare: json['agenzia']['id']
      );
    } else {
      return UtenteDto(
        id: json['id'],
        sub: json['sub'],
        tipo: json['tipo'],
        agenziaImmobiliare: json['agenzia']
      );
    }
  }
}