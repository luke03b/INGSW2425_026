import 'dart:async';

import 'package:domus_app/back_end_communication/communication_utils/url_builder.dart';
import 'package:http/http.dart' as http;

class PrevisioniMeteoController {
  static Future<http.Response> chiamataHTTPrecuperaPrevisioniMeteo(double latitudine, double longitudine) async {

    final Uri url = UrlBuilder.createUrl(
      UrlBuilder.PROTOCOL_HTTPS, 
      UrlBuilder.HOSTNAME_OPEN_METEO, 
      UrlBuilder.ENDPOINT_OPEN_METEO,
      queryParams: {
        'latitude' : latitudine.toString(),
        'longitude' : longitudine.toString(),
        'daily' : "temperature_2m_max,temperature_2m_min,weathercode",
        'hourly' : "temperature_2m,weathercode",
        'timezone' : "Europe/Rome",
        'forecast_days' : "15",
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