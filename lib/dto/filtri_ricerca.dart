class FiltriRicerca {
  final String tipoAnnuncio;
  final double latitudine;
  final double longitudine;
  final double? raggioRicerca;
  final String? prezzoMin;
  final String? prezzoMax;
  final String? superficieMin;
  final String? superficieMax;
  final String? nStanzeMin;
  final String? nStanzeMax;
  final bool? garage;
  final bool? ascensore;
  final bool? arredato;
  final bool? giardino;
  final bool? piscina;
  final bool? balcone;
  final bool? vicinoScuole;
  final bool? vicinoParchi;
  final bool? vicinoMezzi;
  final String? piano;
  final String? classeEnergetica;

  const FiltriRicerca({
    required this.latitudine,
    required this.longitudine,
    required this.tipoAnnuncio,
    this.raggioRicerca,
    this.prezzoMin,
    this.prezzoMax,
    this.superficieMin,
    this.superficieMax,
    this.nStanzeMin,
    this.nStanzeMax,
    this.garage,
    this.ascensore,
    this.arredato,
    this.giardino,
    this.piscina,
    this.balcone,
    this.vicinoScuole,
    this.vicinoParchi,
    this.vicinoMezzi,
    this.piano,
    this.classeEnergetica,
  });
}