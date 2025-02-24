import 'package:domus_app/dto/dto.dart';

class AnnuncioDto implements DTO{
  String tipoAnnuncio;
  double prezzo;
  int superficie;
  int numStanze;
  bool garage;
  bool ascensore;
  bool piscina;
  bool arredo;
  bool balcone;
  bool giardino;
  String classeEnergetica;
  String piano;
  int? numeroPiano;
  String agente;
  String indirizzo;
  double latitudine;
  double longitudine;
  String descrizione;

   AnnuncioDto({
    required this.tipoAnnuncio,
    required this.prezzo,
    required this.superficie,
    required this.numStanze,
    required this.garage,
    required this.ascensore,
    required this.piscina,
    required this.arredo,
    required this.balcone,
    required this.giardino,
    required this.classeEnergetica,
    required this.piano,
    required this.numeroPiano,
    required this.agente,
    required this.indirizzo,
    required this.latitudine,
    required this.longitudine,
    required this.descrizione,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "tipo_annuncio": tipoAnnuncio,
      "prezzo": prezzo,
      "superficie": superficie,
      "numStanze": numStanze,
      "garage": garage,
      "ascensore": ascensore,
      "piscina": piscina,
      "arredo": arredo,
      "balcone": balcone,
      "giardino": giardino,
      "classe_energetica": classeEnergetica,
      "piano": piano,
      "numero_piano": numeroPiano,
      "agente": {
        "id": agente
      },
      "indirizzo": indirizzo,
      "latitudine": latitudine,
      "longitudine": longitudine,
      "descrizione": descrizione
    };
  }

  @override
  AnnuncioDto fromJson(Map<String, dynamic> json) {
    return AnnuncioDto(
      tipoAnnuncio: json['tipo_annuncio'],
      prezzo: json['prezzo'],
      superficie: json['superficie'],
      numStanze: json['numStanze'],
      garage: json['garage'],
      ascensore: json['ascensore'],
      piscina: json['piscina'],
      arredo: json['arredo'],
      balcone: json['balcone'],
      giardino: json['giardino'],
      classeEnergetica: json['classe_energetica'],
      piano: json['piano'],
      numeroPiano: json['numero_piano'],
      agente: json['agente']['id'],
      indirizzo: json['indirizzo'],
      latitudine: json['latitudine'],
      longitudine: json['longitudine'],
      descrizione: json['descrizione'],
    );
  }
}