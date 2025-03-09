class Caratteristiche {
  final bool? garage;
  final bool? ascensore;
  final bool? piscina;
  final bool? arredo;
  final bool? balcone;
  final bool? giardino;

  Caratteristiche({
    this.garage,
    this.ascensore,
    this.piscina,
    this.arredo,
    this.balcone,
    this.giardino,
  });

  Map<String, dynamic> toJson() {
    return {
      'garage' : garage,
      'ascensore' : ascensore,
      'piscina' : piscina,
      'arredo' : arredo,
      'balcone' : balcone,
      'giardino' : giardino,
    };
  }
}