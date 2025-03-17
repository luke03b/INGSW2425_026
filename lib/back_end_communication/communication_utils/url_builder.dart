import 'package:flutter_dotenv/flutter_dotenv.dart';

class UrlBuilder {
  static String get S3_BUCKET_NAME => dotenv.env['S3_BUCKET_NAME'] ?? '';
  static String get S3_BUCKET_REGION => dotenv.env['S3_BUCKET_REGION'] ?? '';
  static final String PROTOCOL_HTTP = "http";
  static final String PROTOCOL_HTTPS = "https";
  static final String HOSTNAME_OPEN_METEO = "api.open-meteo.com";
  static final String LOCALHOST_ANDROID = "10.0.2.2";
  static final String LOCALHOST_WINDOWS = "localhost";
  static final String INDIRIZZO_IN_USO = LOCALHOST_ANDROID;
  static final String PORTA_SPRINGBOOT = "8080";
  static final String ENDPOINT_OPEN_METEO = "/v1/forecast";
  static final String ENDPOINT_ANNUNCI = "api/annunci";
  static final String ENDPOINT_UTENTI = "api/users";
  static final String ENDPOINT_ANNUNCI_AGENTE = "api/annunci/agente";
  static final String ENDPOINT_POST_ANNUNCI_RECENTI = "api/cronologia";
  static final String ENDPOINT_GET_ANNUNCI_RECENTI = "api/annunci/cliente/cronologia";
  static final String ENDPOINT_POST_OFFERTE = "api/offerte";
  static final String ENDPOINT_GET_OFFERTE = "api/offerte";
  static final String ENDPOINT_GET_OFFERTE_STATO = "api/offerte/stato";
  static final String ENDPOINT_GET_ANNUNCI_OFFERTE = "api/offerte/cliente";
  static final String ENDPOINT_POST_VISITE = "api/visite";
  static final String ENDPOINT_GET_VISITE_ANNUNCIO = "api/visite";
  static final String ENDPOINT_GET_VISITE_CLIENTE = "api/visite/cliente";
  static final String ENDPOINT_GET_ANNUNCI_CON_OFFERTE_PRENOTAZIONI = "api/annunci/agente/offerte-prenotazioni";
  static final String ENDPOINT_GET_VISITE_STATO = "api/visite/stato";
  static final String ENDPOINT_GET_VISITE_AGENTE_STATO = "api/visite/agente/stato";
  static final String ENDPOINT_GET_ANNUNCI_BY_ID = "api/annunci/id";
  static final String ENDPOINT_ANNUNCI_FILTRI_RICERCA = "api/annunci/filtriRicerca";
  static final String ENDPOINT_IMMAGINI_S3_PRESIGNED_URL = "api/immagini/upload-presigned-url";
  static final String ENDPOINT_IMMAGINI_S3_SAVE = "api/immagini/save";
  static final String ENDPOINT_GET_IMMAGINI = "api/immagini";
  static final String ENDPOINT_IMMAGINI_S3_DOWNLOAD_PRESIGNED_URL = "api/immagini/download-presigned-url";



  static Uri createUrl(String protocol, String hostName, String path, {String? port,  Map<String, dynamic>? queryParams}) {
    Uri uri;
    if(port != null){
      uri = Uri.parse("$protocol://$hostName:$port/$path");
    } else {
      uri = Uri.parse("$protocol://$hostName/$path");
    }

    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }

    return uri;
  }

  static Uri createS3Url(String nomeImmagine){
    return Uri.parse("$PROTOCOL_HTTPS://$S3_BUCKET_NAME.s3.$S3_BUCKET_REGION.amazonaws.com/$nomeImmagine");
  }
}