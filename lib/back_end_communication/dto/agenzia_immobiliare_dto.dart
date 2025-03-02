import 'package:domus_app/back_end_communication/dto/dto.dart';

class AgenziaImmobiliareDto implements DTO {
  final String id;
  final String nome;
  final String partitaIva;

  AgenziaImmobiliareDto({
    required this.id,
    required this.nome,
    required this.partitaIva,
  });

  // Metodo per creare un'istanza di AgenziaDto da una mappa (ad esempio, JSON)
  static AgenziaImmobiliareDto fromJson(Map<String, dynamic> json) {
    return AgenziaImmobiliareDto(
      id: json['id'] as String,
      nome: json['nome'] as String,
      partitaIva: json['partitaiva'] as String,
    );
  }

  // Metodo per convertire un'istanza di AgenziaDto in una mappa (ad esempio, per inviare un JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'partitaiva': partitaIva,
    };
  }
}
