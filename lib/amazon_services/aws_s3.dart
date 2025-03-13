import 'dart:async';

import 'package:domus_app/back_end_communication/communication_utils/url_builder.dart';
import 'package:http/http.dart' as http;

class S3Services{
  static Future<http.Response> chiamataHTTPrecuperaImmaginiByUrl(Uri url) async{

    final response = await http.get(url).timeout(const Duration(seconds: 60), onTimeout: () {throw TimeoutException("Il server non risponde.");},);

    return response;
  }
}