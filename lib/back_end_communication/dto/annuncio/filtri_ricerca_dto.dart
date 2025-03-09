import 'package:domus_app/back_end_communication/dto/annuncio/caratteristiche.dart';
import 'package:domus_app/back_end_communication/dto/annuncio/coordinate.dart';
import 'package:domus_app/back_end_communication/dto/annuncio/intervallo_prezzo.dart';
import 'package:domus_app/back_end_communication/dto/annuncio/intervallo_stanze.dart';
import 'package:domus_app/back_end_communication/dto/annuncio/intervallo_superficie.dart';
import 'package:domus_app/back_end_communication/dto/annuncio/vicinanze.dart';
import 'package:domus_app/back_end_communication/dto/dto.dart';

class FiltriRicercaDto implements DTO {
  final String tipoAnnuncio;
  final Coordinate coordinate;
  final double? raggioRicerca;
  final IntervalloPrezzo? intervalloPrezzo;
  final IntervalloSuperficie? intervalloSuperficie;
  final IntervalloStanze? intervalloStanze;
  final Caratteristiche? caratteristiche;
  final Vicinanze? vicinanze;
  final String? piano;
  final String? classeEnergetica;

  const FiltriRicercaDto({
    required this.tipoAnnuncio,
    required this.coordinate,
    this.raggioRicerca,
    this.intervalloPrezzo,
    this.intervalloSuperficie,
    this.intervalloStanze,
    this.caratteristiche,
    this.vicinanze,
    this.piano,
    this.classeEnergetica,
  });

  @override
  Map<String, dynamic> toJson() {
    return rimuoviValoriNull({
      'tipoAnnuncio' : tipoAnnuncio.toString().toUpperCase(),
      'coordinate' : coordinate.toJson(),
      'raggioKm' : raggioRicerca.toString(),
      'intervalloPrezzo' : intervalloPrezzo?.toJson(),
      'intervalloSuperficie' : intervalloSuperficie?.toJson(),
      'intervalloStanze' : intervalloStanze?.toJson(),
      'caratteristiche' : caratteristiche?.toJson(),
      'vicinanze' : vicinanze?.toJson(),
      'piano' : piano.toString().toUpperCase(),
      'classeEnergetica' : classeEnergetica.toString().toUpperCase(),
    });
  }

  Map<String, dynamic> rimuoviValoriNull(Map<String, dynamic> json) {
    final chiaviDaRimuovere = <String>[];

    json.forEach((key, value) {
      if (value == null || value == "NULL") {
        chiaviDaRimuovere.add(key);
      } else if (value is Map<String, dynamic>) {
        json[key] = rimuoviValoriNull(value);
        if (json[key].isEmpty) {
          chiaviDaRimuovere.add(key);
        }
      }
    });

    for (var key in chiaviDaRimuovere) {
      json.remove(key);
    }

    return json;
  }

}