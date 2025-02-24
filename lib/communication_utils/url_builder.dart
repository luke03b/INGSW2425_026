class Urlbuilder {
  static final String LOCALHOST_ANDROID = "10.0.2.2";
  static final String LOCALHOST_WINDOWS = "localhost";
  static final String PORTA_SPRINGBOOT = "8080";
  static final String ENDPOINT_ANNUNCI = "api/annunci";
  static final String _url = "http://";

  static Uri createUrl(String hostName, String port, String path, {Map<String, String>? queryParams}) {
    Uri uri = Uri.parse("$_url$hostName:$port/$path");

    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }

    return uri;
  }
}