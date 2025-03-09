class Vicinanze {
  final bool? vicinoScuole;
  final bool? vicinoParchi;
  final bool? vicinoTrasporti;

  Vicinanze({
    this.vicinoScuole,
    this.vicinoParchi,
    this.vicinoTrasporti,
  });

  Map<String, dynamic> toJson() {
    return {
      'vicinoScuole' : vicinoScuole,
      'vicinoParchi' : vicinoParchi,
      'vicinoTrasporti' : vicinoTrasporti,
    };
  }

  static Vicinanze fromJson(Map<String, dynamic> json) {
    return Vicinanze(
      vicinoScuole : json['vicinoScuole'],
      vicinoParchi: json['vicinoParchi'],
      vicinoTrasporti : json['vicinoTrasporti'],
    );
  }
}