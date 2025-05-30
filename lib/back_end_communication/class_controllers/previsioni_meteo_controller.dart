import 'dart:async';

import 'package:domus_app/back_end_communication/communication_utils/url_builder.dart';
import 'package:http/http.dart' as http;

class PrevisioniMeteoController {
  static Future<http.Response> chiamataHTTPrecuperaPrevisioniMeteo(double latitudine, double longitudine) async {

    final Uri url = UrlBuilder.createUrl(
      UrlBuilder.PROTOCOL_HTTP, 
      UrlBuilder.INDIRIZZO_IN_USO, 
      UrlBuilder.ENDPOINT_METEO,
      port: UrlBuilder.PORTA_SPRINGBOOT,
      queryParams: {
        'latitudine' : latitudine.toString(),
        'longitudine' : longitudine.toString(),
      }
    );

    print("\n\n\n\n\n\n\n\n\n\n\n");
    print(url);
    print("\n\n\n\n\n\n\n\n\n\n\n");

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    ).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw TimeoutException("Il server non risponde.");
      },
    );

    return response;
  }
}