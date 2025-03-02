import 'package:domus_app/ui_elements/theme/ui_constants.dart';
import 'package:flutter/material.dart';

class MyPrevisioniMeteoUiProvider {
  static IconData getWeatherIcon(int weatherCode) {
    switch (weatherCode) {
      case 0:
        return Icons.wb_sunny;
      case 1:
      case 2:
      case 3:
      case 45:
      case 48:
        return Icons.cloud;
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
      case 95:
      case 96:
      case 99:
        return Icons.water_drop;
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return Icons.ac_unit;
      default:
        return Icons.help_outline;
    }
  }

  static Color getWeatherColor(int weatherCode, BuildContext context) {
    switch (weatherCode) {
      case 0:
        return context.primaryFixed;
      case 1:
      case 2:
      case 3:
      case 45:
      case 48:
        return context.secondaryFixed;
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
      case 95:
      case 96:
      case 99:
        return context.tertiaryFixedDim;
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return context.surfaceBright;
      default:
        return context.secondaryFixedDim;
    }
  }
}