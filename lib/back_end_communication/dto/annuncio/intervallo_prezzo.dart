class IntervalloPrezzo {
  final double? prezzoMinimo;
  final double? prezzoMassimo;

  IntervalloPrezzo({
    this.prezzoMinimo,
    this.prezzoMassimo,
  });

  Map<String, dynamic> toJson() {
    return {
      'prezzoMinimo' : prezzoMinimo,
      'prezzoMassimo' : prezzoMassimo,
    };
  }

  static IntervalloPrezzo fromJson(Map<String, dynamic> json) {
    return IntervalloPrezzo(
      prezzoMinimo: json['prezzoMinimo'],
      prezzoMassimo: json['prezzoMassimo'],
    );
  }
}