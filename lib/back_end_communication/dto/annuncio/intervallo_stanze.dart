class IntervalloStanze {
  final int? numStanzeMinime;
  final int? numStanzeMassime;

  IntervalloStanze({
    this.numStanzeMinime,
    this.numStanzeMassime,
  });

  Map<String, dynamic> toJson() {
    return {
      'numStanzeMinime' : numStanzeMinime,
      'numStanzeMassime' : numStanzeMassime,
    };
  }

  static IntervalloStanze fromJson(Map<String, dynamic> json) {
    return IntervalloStanze(
      numStanzeMinime: json['numStanzeMinime'],
      numStanzeMassime: json['numStanzeMassime'],
    );
  }
}