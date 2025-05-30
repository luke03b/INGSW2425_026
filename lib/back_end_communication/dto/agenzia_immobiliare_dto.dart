import 'package:domus_app/back_end_communication/dto/dto.dart';

class AgenziaImmobiliareDto implements DTO {
  final String? id;
  final String nome;
  final String partitaIva;

  AgenziaImmobiliareDto({
    this.id,
    required this.nome,
    required this.partitaIva,
  });

  static AgenziaImmobiliareDto fromJson(Map<String, dynamic> json) {
    return AgenziaImmobiliareDto(
      id: json['id'],
      nome: json['nome'],
      partitaIva: json['partitaiva'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'partitaiva': partitaIva,
    };
  }
}
