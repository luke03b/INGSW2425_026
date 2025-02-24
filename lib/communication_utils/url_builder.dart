class Urlbuilder {
  static final String _url = "http://";

  static Uri createUrl(String hostName, String port, String path, {Map<String, String>? queryParams}) {
    Uri uri = Uri.parse("$_url$hostName:$port/$path");

    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }

    return uri;
  }
}