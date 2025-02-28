class Urlbuilder {
  static final String _url = "http://";
  static final String LOCALHOST_ANDROID = "10.0.2.2";
  static final String LOCALHOST_WINDOWS = "localhost";
  static final String PORTA_SPRINGBOOT = "8080";
  static final String ENDPOINT_ANNUNCI = "api/annunci";
  static final String ENDOPOINT_UTENTI = "api/users";
  static final String ENDOPOINT_ANNUNCI_AGENTE = "api/annunci/agente";
  static final String ENDPOINT_POST_ANNUNCI_RECENTI = "api/cronologia";
  static final String ENDPOINT_GET_ANNUNCI_RECENTI = "api/annunci/cliente/cronologia";
  static final String ENDPOINT_POST_OFFERTE = "api/offerte";

  static Uri createUrl(String hostName, String port, String path, {Map<String, dynamic>? queryParams}) {
    Uri uri = Uri.parse("$_url$hostName:$port/$path");

    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }

    return uri;
  }
}