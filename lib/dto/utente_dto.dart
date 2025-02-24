import 'package:domus_app/dto/dto.dart';

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
      "sub": sub,
      "tipo": tipo,
      "agenzia" : agenziaImmobiliare
      };
    }

    return {
      "sub": sub,
      "tipo": tipo,
      "agenzia" : {
        "id": agenziaImmobiliare
      }
    };
  }

  static UtenteDto fromJson(Map<String, dynamic> json) {
    return UtenteDto(
      id: json['id'],
      sub: json['sub'],
      tipo: json['tipo'],
      agenziaImmobiliare: json['agenzia']['id']
    );
  }
}