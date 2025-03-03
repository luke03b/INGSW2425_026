import 'package:domus_app/back_end_communication/dto/dto.dart';
import 'package:domus_app/back_end_communication/dto/utente_dto.dart';

class AnnuncioDto implements DTO{
  String? idAnnuncio;
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
  UtenteDto agente;
  String indirizzo;
  double latitudine;
  double longitudine;
  String descrizione;
  bool? vicinoParchi;
  bool? vicinoScuole;
  bool? vicinoTrasporti;

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
    this.vicinoScuole,
    this.vicinoParchi,
    this.vicinoTrasporti,
    this.idAnnuncio,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id' : idAnnuncio,
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
      "agente": agente.toJson(),
      "indirizzo": indirizzo,
      "latitudine": latitudine,
      "longitudine": longitudine,
      "descrizione": descrizione,
      "vicino_scuole": vicinoScuole,
      "vicino_parchi": vicinoParchi,
      "vicino_trasporti": vicinoTrasporti,
    };
  }

  static AnnuncioDto fromJson(Map<String, dynamic> json) {
    return AnnuncioDto(
      idAnnuncio: json['id'],
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
      agente: UtenteDto.fromJson(json['agente']),
      indirizzo: json['indirizzo'],
      latitudine: json['latitudine'],
      longitudine: json['longitudine'],
      descrizione: json['descrizione'],
      vicinoScuole: json['vicino_scuole'],
      vicinoParchi: json['vicino_parchi'],
      vicinoTrasporti: json['vicino_trasporti'],
    );
  }
}