import 'package:domus_app/theme/ui_constants.dart';
import 'package:flutter/material.dart';

class LoadingHelper {
  static void showLoadingDialogNotDissmissible(BuildContext context, {Color color = Colors.blue}) {
    showDialog(
      context: context,
      barrierDismissible: false, // Impedisce la chiusura del dialogo cliccando fuori
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // Sfondo trasparente
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(color), // Colore personalizzato per la rotellina
            ),
          ),
        );
      },
    );
  }

  static CircularProgressIndicator showLoadingDialog(BuildContext context) {
     return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(context.secondary),
    );
  }
}
