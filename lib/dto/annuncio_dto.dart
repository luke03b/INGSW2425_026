//manca il tipo dell'annuncio (in vendita o in affitto) 
class AnnuncioDto {
  double prezzo = 0;
  int superficie = 0;
  int numStanze = 0;
  bool garage = false;
  bool ascensore = false;
  bool piscina = false;
  bool arredo = false;
  bool balcone = false;
  bool giardino = false;
  bool vicino_scuole = false;
  bool vicino_parchi = false;
  bool vicino_trasporti = false;
  String classe_energetica = "Tutte";
  String piano = "Tutti";
  int numeropiano = 0;
  String data_creazione = "";
  String agente = "";
  String indirizzo = "";
  double coordinatex = 0;
  double coordinatey = 0;
  String descrizione = "";

   AnnuncioDto({
    this.prezzo = 0,
    this.superficie = 0,
    this.numStanze = 0,
    this.garage = false,
    this.ascensore = false,
    this.piscina = false,
    this.arredo = false,
    this.balcone = false,
    this.giardino = false,
    this.vicino_scuole = false,
    this.vicino_parchi = false,
    this.vicino_trasporti = false,
    this.classe_energetica = "Tutte",
    this.piano = "Tutti",
    this.numeropiano = 0,
    this.data_creazione = "",
    this.agente = "",
    this.indirizzo = "",
    this.coordinatex = 0.0,
    this.coordinatey = 0.0,
    this.descrizione = "",
  });

  Map<String, dynamic> toJson() {
    return {
      'prezzo': prezzo,
      'superficie': superficie,
      'numStanze': numStanze,
      'garage': garage,
      'ascensore': ascensore,
      'piscina': piscina,
      'arredo': arredo,
      'balcone': balcone,
      'giardino': giardino,
      'vicino_scuole': vicino_scuole,
      'vicino_parchi': vicino_parchi,
      'vicino_trasporti': vicino_trasporti,
      'classe_energetica': classe_energetica,
      'piano': piano,
      'numeropiano': numeropiano,
      'data_creazione': data_creazione,
      'agente': agente,
      'indirizzo': indirizzo,
      'coordinatex': coordinatex,
      'coordinatey': coordinatey,
      'descrizione': descrizione,
    };
  }
}