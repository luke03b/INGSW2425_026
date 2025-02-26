import 'package:flutter/material.dart';

class AppTypography {
  static const double titolo = 23;
  static const double sottotitolo = 20.0;
  static const double corpo = 16.0;
  static const double scrittaPiccola = 12.0;
  static const double iconeGrandi = 25;
  static const double iconePiccole = 20;
}

class AppSpacing {
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
}

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    //colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 39, 76, 119))),
    colorScheme: const ColorScheme(
      brightness: Brightness.light, 
      //primary:  Color.fromARGB(255, 8, 79, 161),
      primary: Color.fromARGB(255, 231, 236, 239),
      onPrimary:  Color(0xFF373436),
      secondary:  Color.fromARGB(255, 138, 150, 156),
      onSecondary:  Color.fromARGB(255, 8, 79, 161),
      tertiary:  Color.fromARGB(255, 233, 135, 7),
      onTertiary:  Color.fromARGB(255, 8, 79, 161),
      error:  Color.fromARGB(255, 218, 41, 28),
      onError:  Color.fromARGB(255, 231, 236, 239),
      surface:  Color.fromARGB(255, 231, 236, 239),
      onSurface:  Color.fromARGB(255, 8, 79, 161),
      outline: Colors.black,
      shadow: Colors.black,
      primaryContainer: Colors.white,
      scrim: Colors.grey,
      tertiaryFixed: Colors.white,
      onPrimaryContainer: Color.fromARGB(255, 138, 150, 156),
    )
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    //colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 39, 76, 119))),
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      //primary: Color.fromARGB(255, 14, 28, 68),
      primary: Color(0xFF292629),
      onPrimary:  Colors.white,
      // primary:  Color.fromARGB(255, 9, 18, 44),
      secondary:  Color.fromARGB(255, 54, 54, 54),
      onSecondary:  Color.fromARGB(255, 63, 77, 148),
      tertiary:  Color.fromARGB(255, 63, 77, 148),
      onTertiary:  Color.fromARGB(255, 8, 79, 161),
      error:  Color.fromARGB(255, 128, 35, 31),
      onError:  Color.fromARGB(255, 231, 236, 239),
      // surface:  Color.fromARGB(255, 30, 35, 49),
      surface: Color(0xFF1D1B1B),
      onSurface:  Color(0xFF10121f),
      outline: Colors.white,
      shadow: Colors.black,
      primaryContainer: Color(0xFF28262B),
      scrim: Colors.grey,
      tertiaryFixed: Color(0xFF1D1B1B),
      onPrimaryContainer: Color(0xFF292629),
    )
  );
}

//Permette di chiamare i colori con context.primaryColor ad esempio al posto di Theme.of(context).colorScheme.primary
extension ThemeExtensions on BuildContext {
  Color get primary => Theme.of(this).colorScheme.primary;
  Color get onPrimary => Theme.of(this).colorScheme.onPrimary;
  Color get secondary => Theme.of(this).colorScheme.secondary;
  Color get onSecondary => Theme.of(this).colorScheme.onSecondary;
  Color get tertiary => Theme.of(this).colorScheme.tertiary;
  Color get onTertiary => Theme.of(this).colorScheme.onTertiary;
  Color get error => Theme.of(this).colorScheme.error;
  Color get onError => Theme.of(this).colorScheme.onError;
  Color get surface => Theme.of(this).colorScheme.surface;
  Color get onSurface => Theme.of(this).colorScheme.onSurface;
  Color get outline => Theme.of(this).colorScheme.outline;
  Color get shadow => Theme.of(this).colorScheme.shadow;
  Color get primaryContainer => Theme.of(this).colorScheme.primaryContainer;
  Color get scrim => Theme.of(this).colorScheme.scrim;
  Color get tertiaryFixed => Theme.of(this).colorScheme.tertiaryFixed;
  Color get onPrimaryContainer => Theme.of(this).colorScheme.onPrimaryContainer;
}