import 'package:intl/intl.dart';

class FormatStrings {
  static String formatNumber(double value) {
  // Crea un oggetto NumberFormat per formattare senza decimali e con separatori di migliaia
    final numberFormat = NumberFormat("#,###", "it_IT");
    return numberFormat.format(value);
  }

  static String trasformareInizialeMaiuscola(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }
}