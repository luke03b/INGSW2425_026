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

  static String formattaDataGGMMAAAAeHHMM(DateTime input) {
    return DateFormat("dd/MM/yyyy HH:mm").format(input);
  }

  static String formattaDataGGMMAAAA(DateTime input) {
    return DateFormat("dd/MM/yyyy").format(input);
  }

  static String formattaOrario(String input) {
    return input.substring(0, input.length - 3);
  }

  static String mappaStatoOfferta(String input) {
    if(input == "ACCETTATA") {
        return "Accettata";
      } else if(input == "RIFIUTATA") {
        return "Rifiutata";
      } else if(input == "IN_ATTESA") {
        return "In Attesa";
      } else if(input == "CONTROPROPOSTA") {
        return "Controproposta";
      }
      return "";
  }
}