class Coordinate {
  final double latitudine;
  final double longitudine;

  Coordinate({
    required this.latitudine,
    required this.longitudine,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitudine' : latitudine,
      'longitudine' : longitudine,
    };
  }

  static Coordinate fromJson(Map<String, dynamic> json) {
    return Coordinate(
      latitudine: json['latitudine'],
      longitudine: json['longitudine'],
    );
  }

}