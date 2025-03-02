import 'package:domus_app/back_end_communication/dto/agenzia_immobiliare_dto.dart';
import 'package:domus_app/back_end_communication/dto/dto.dart';

class UtenteDto implements DTO{
  String? id;
  String sub;
  String nome;
  String cognome;
  String email;
  String tipo;
  AgenziaImmobiliareDto? agenziaImmobiliare;

  UtenteDto({
    this.id,
    required this.sub,
    required this.nome,
    required this.cognome,
    required this.email,
    required this.tipo,
    this.agenziaImmobiliare
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "sub": sub,
      "nome": nome,
      "cognome": cognome,
      "email": email,
      "tipo": tipo,
      "agenzia": agenziaImmobiliare?.toJson(),
    };
  }

  static UtenteDto fromJson(Map<String, dynamic> json) {
    if(json["agenzia"] != null){
      return UtenteDto(
        id: json['id'],
        sub: json['sub'],
        nome: json['nome'],
        cognome: json['cognome'],
        email: json['email'],
        tipo: json['tipo'],
        agenziaImmobiliare: AgenziaImmobiliareDto.fromJson(json['agenzia'])
      );
    } else {
      return UtenteDto(
        id: json['id'],
        sub: json['sub'],
        nome: json['nome'],
        cognome: json['cognome'],
        email: json['email'],
        tipo: json['tipo']
      );
    }
  }
}