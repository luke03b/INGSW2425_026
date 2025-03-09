class IntervalloSuperficie {
  final int? superficieMinima;
  final int? superficieMassima;

  IntervalloSuperficie({
    this.superficieMinima,
    this.superficieMassima,
  });

  Map<String, dynamic> toJson() {
    return {
      'superficieMinima' : superficieMinima,
      'superficieMassima' : superficieMassima,
    };
  }

  static IntervalloSuperficie fromJson(Map<String, dynamic> json) {
    return IntervalloSuperficie(
      superficieMinima: json['superficieMinima'],
      superficieMassima: json['superficieMassima'],
    );
  }

}