import 'dart:async';
import 'dart:convert';
import 'package:domus_app/communication_utils/url_builder.dart';
import 'package:domus_app/dto/annuncio_dto.dart';
import 'package:http/http.dart' as http;

class AnnuncioService {
  static Future<int> creaAnnuncio(String tipoAnnuncio, String prezzo, String superficie, String indirizzo,
    String descrizione, bool isGarageSelected, bool isAscensoreSelected, bool isPiscinaSelected,
    bool isArredatoSelected, bool isBalconeSelected, bool isGiardinoSelected, String stanze, String numeroPiano,
    String sceltaClasseEnergetica, String sceltaPiano, double latitudine, double longitudine) async {

    AnnuncioDto nuovoAnnuncio = creaAnnuncioDto(tipoAnnuncio, prezzo, superficie, indirizzo, descrizione, isGarageSelected,
      isAscensoreSelected, isPiscinaSelected, isArredatoSelected, isBalconeSelected, isGiardinoSelected, stanze, numeroPiano,
      sceltaClasseEnergetica, sceltaPiano, latitudine, longitudine);

      try {
        return await inviaAnnuncio(nuovoAnnuncio);
      } on TimeoutException {
        throw TimeoutException("Il server non risponde.");
      }
  }

  static Future<int> inviaAnnuncio(AnnuncioDto annuncio) async {
    final url = Urlbuilder.createUrl("10.0.2.2", "8080", "api/annunci");
    
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(annuncio),
    ).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw TimeoutException("Il server non risponde.");
      },
    );
    
    return response.statusCode;
  }

  static AnnuncioDto creaAnnuncioDto(String tipoAnnuncio, String prezzo, String superficie, String indirizzo,
    String descrizione, bool isGarageSelected, bool isAscensoreSelected, bool isPiscinaSelected,
    bool isArredatoSelected, bool isBalconeSelected, bool isGiardinoSelected, String stanze, String numeroPiano,
    String sceltaClasseEnergetica, String sceltaPiano, double latitudine, double longitudine){

    String prezzoStringa = prezzo;
    double prezzoDouble = double.parse(prezzoStringa);

    String superficieStringa = superficie;
    int superficieInt = int.parse(superficieStringa);

    String nStanzeStringa = stanze;
    int nStanzeInt = int.parse(nStanzeStringa);

    int? nPianoInt;

    if(sceltaPiano == "Intermedio") {
      String nPianoStringa = numeroPiano;
      nPianoInt = int.parse(nPianoStringa);
    }

    return AnnuncioDto(
      tipoAnnuncio: tipoAnnuncio.toUpperCase(),
      prezzo: prezzoDouble, 
      superficie: superficieInt, 
      numStanze: nStanzeInt, 
      garage: isGarageSelected, 
      ascensore: isAscensoreSelected, 
      piscina: isPiscinaSelected, 
      arredo: isArredatoSelected,
      balcone: isBalconeSelected,
      giardino: isGiardinoSelected,
      classeEnergetica: sceltaClasseEnergetica.toUpperCase(),
      piano: sceltaPiano.toUpperCase(),
      numeroPiano: nPianoInt,
      agente: "159cb08f-351f-4d63-8330-822bd55f8721",
      indirizzo: indirizzo,
      latitudine: latitudine,
      longitudine: longitudine,
      descrizione: descrizione,
    );
  }
}