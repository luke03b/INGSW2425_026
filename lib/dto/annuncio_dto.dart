//manca il tipo dell'annuncio (in vendita o in affitto) 
class AnnuncioDto {
  String tipo_annuncio;
  double prezzo;
  int superficie;
  int numStanze;
  bool garage;
  bool ascensore;
  bool piscina;
  bool arredo;
  bool balcone;
  bool giardino;
  // bool vicino_scuole = false;
  // bool vicino_parchi = false;
  // bool vicino_trasporti = false;
  String classe_energetica;
  String piano;
  int? numero_piano;
  // String data_creazione = "";
  String agente;
  String indirizzo;
  double latitudine;
  double longitudine;
  String descrizione;

   AnnuncioDto({
    required this.tipo_annuncio,
    required this.prezzo,
    required this.superficie,
    required this.numStanze,
    required this.garage,
    required this.ascensore,
    required this.piscina,
    required this.arredo,
    required this.balcone,
    required this.giardino,
    required this.classe_energetica,
    required this.piano,
    required this.numero_piano,
    required this.agente,
    required this.indirizzo,
    required this.latitudine,
    required this.longitudine,
    required this.descrizione,
  });

  Map<String, dynamic> toJson() {
    return {
      "tipo_annuncio": tipo_annuncio,
      "prezzo": prezzo,
      "superficie": superficie,
      "numStanze": numStanze,
      "garage": garage,
      "ascensore": ascensore,
      "piscina": piscina,
      "arredo": arredo,
      "balcone": balcone,
      "giardino": giardino,
      "classe_energetica": classe_energetica,
      "piano": piano,
      "numero_piano": numero_piano,
      "agente": {
        "id": agente
      },
      "indirizzo": indirizzo,
      "latitudine": latitudine,
      "longitudine": longitudine,
      "descrizione": descrizione
    };
  }
}