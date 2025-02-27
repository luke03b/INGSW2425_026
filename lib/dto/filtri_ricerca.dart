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

  Map<String, dynamic> toJson(FiltriRicerca filtri) {
    return _filterQueryParams({
      'tipo_annuncio' : tipoAnnuncio.toString().toUpperCase(),
      'latitudine': latitudine.toString(),
      'longitudine': longitudine.toString(),
      'raggioKm' : raggioRicerca.toString(),
      'prezzoMinimo' : prezzoMin.toString(),
      'prezzoMassimo' :prezzoMax.toString(),
      'superficieMinima' :superficieMin.toString(),
      'superficieMassima' : superficieMax.toString(),
      'numStanzeMinime' :nStanzeMin.toString(),
      'numStanzeMassime' : nStanzeMax.toString(),
      'garage' : garage.toString(),
      'ascensore' : ascensore.toString(),
      'arredo' : arredato.toString(),
      'giardino' : giardino.toString(),
      'piscina' : piscina.toString(),
      'balcone' : balcone.toString(),
      'vicino_scuole' : vicinoScuole.toString(),
      'vicino_parchi' : vicinoParchi.toString(),
      'vicino_trasporti' : vicinoMezzi.toString(),
      'piano' : piano.toString().toUpperCase(),
      'classeEnergetica' : classeEnergetica.toString().toUpperCase(),
    });
  }

  Map<String, String> _filterQueryParams(Map<String, String> params) {
    // Rimuove i parametri o nulli o vuoti o false
    params.removeWhere((key, value) {
      return value == "false" || value.isEmpty || value == "null" || value == "NULL";
    });
    return params;
  }
}