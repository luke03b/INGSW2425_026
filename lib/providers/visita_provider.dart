import 'dart:async';
import 'package:flutter/material.dart';
import 'package:domus_app/back_end_communication/class_services/previsioni_meteo_service.dart';
import 'package:domus_app/back_end_communication/class_services/visita_service.dart';
import 'package:domus_app/back_end_communication/dto/annuncio/annuncio_dto.dart';
import 'package:domus_app/back_end_communication/dto/previsioni_meteo_dto.dart';
import 'package:domus_app/back_end_communication/dto/visita_dto.dart';

class VisitaProvider with ChangeNotifier {
  bool areOursServersAvailable = false;
  bool areOpenMeteoServersAvailable = false;
  bool areVisiteRetrieved = false;
  bool arePrevisioniMeteoRetrieved = false;
  List<VisitaDto> listaVisite = [];
  PrevisioniMeteoDto? previsioniMeteo;

  Future<void> getVisiteAnnuncio(AnnuncioDto annuncio) async {
    try {
      listaVisite = await VisitaService.recuperaVisiteAnnuncio(annuncio);
      areVisiteRetrieved = true;
      areOursServersAvailable = true;
    } on TimeoutException {
      areVisiteRetrieved = true;
      areOursServersAvailable = false;
    } catch (error) {
      areVisiteRetrieved = true;
      areOursServersAvailable = false;
      print('Errore nel recupero visite: $error');
    }
    notifyListeners();
  }

  Future<void> recuperaPrevisioniMeteo(double latitudine, double longitudine) async {
    try {
      previsioniMeteo = await PrevisioniMeteoService.recuperaPrevisioniMeteo(latitudine, longitudine);
      arePrevisioniMeteoRetrieved = true;
      areOpenMeteoServersAvailable = true;
    } on TimeoutException {
      arePrevisioniMeteoRetrieved = true;
      areOpenMeteoServersAvailable = false;
    } catch (error) {
      arePrevisioniMeteoRetrieved = true;
      areOpenMeteoServersAvailable = false;
      print('Errore nel recupero previsioni meteo: $error');
    }
    notifyListeners();
  }
}
