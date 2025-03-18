class PrevisioniMeteoDto {
  final double latitude;
  final double longitude;
  final String timezone;
  final double elevation;
  final PrevisioniMeteoOrarieDto hourly;
  final PrevisioniMeteoGiornaliereDto daily;

  PrevisioniMeteoDto({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.elevation,
    required this.hourly,
    required this.daily,
  });

  static PrevisioniMeteoDto fromJson(Map<String, dynamic> json) {
    return PrevisioniMeteoDto(
      latitude: json['latitude'],
      longitude: json['longitude'],
      timezone: json['timezone'],
      elevation: json['elevation'],
      hourly: PrevisioniMeteoOrarieDto.fromJson(json['hourly']),
      daily: PrevisioniMeteoGiornaliereDto.fromJson(json['daily']),
    );
  }
}

class PrevisioniMeteoGiornaliereDto {
  final List<String> time;
  final List<double> temperaturaMax;
  final List<double> temperaturaMin;
  final List<int> weatherCode;

  PrevisioniMeteoGiornaliereDto({
    required this.time,
    required this.temperaturaMax,
    required this.temperaturaMin,
    required this.weatherCode,
  });

  static PrevisioniMeteoGiornaliereDto fromJson(Map<String, dynamic> json) {
    return PrevisioniMeteoGiornaliereDto(
      time: List<String>.from(json['time']),
      temperaturaMax: List<double>.from(json['temperature_2m_max']),
      temperaturaMin: List<double>.from(json['temperature_2m_min']),
      weatherCode: List<int>.from(json['weathercode']),
    );
  }
}

class PrevisioniMeteoOrarieDto {
  final List<String> time;
  final List<double> temperatura2m;
  final List<int> weatherCode;

  PrevisioniMeteoOrarieDto({
    required this.time,
    required this.temperatura2m,
    required this.weatherCode,
  });

  static PrevisioniMeteoOrarieDto fromJson(Map<String, dynamic> json) {
    return PrevisioniMeteoOrarieDto(
      time: List<String>.from(json['time']),
      temperatura2m: List<double>.from(json['temperature_2m']),
      weatherCode: List<int>.from(json['weathercode']),
    );
  }
}