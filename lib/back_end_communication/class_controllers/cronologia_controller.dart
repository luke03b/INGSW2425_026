import 'dart:async';
import 'dart:convert';

import 'package:domus_app/back_end_communication/communication_utils/url_builder.dart';
import 'package:domus_app/back_end_communication/dto/cronologia_dto.dart';
import 'package:http/http.dart' as http;

class CronologiaController {
  static Future<http.Response> chiamataHTTPaggiornaCronologiaCliente(CronologiaDto cronologia) async {
    final url = UrlBuilder.createUrl(
      UrlBuilder.PROTOCOL_HTTP, 
      UrlBuilder.INDIRIZZO_IN_USO, 
      port: UrlBuilder.PORTA_SPRINGBOOT, 
      UrlBuilder.ENDPOINT_POST_ANNUNCI_RECENTI,
    );

    print("\n\n\n\n\n\n\n");
    print(url);
    print("\n\n\n\n\n\n\n");
    print(json.encode(cronologia));

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(cronologia),
    ).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw TimeoutException("Il server non risponde.");
      },
    );
    
    return response;
  }
}