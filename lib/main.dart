import 'package:domus_app/pages/home_page.dart';
import 'package:domus_app/pages/registration_page.dart';
import 'package:domus_app/pages/risultati_cerca_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      title: 'House Hunters',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        //colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 39, 76, 119))),
        colorScheme: const ColorScheme(
          brightness: Brightness.light, 
          // primary: Color.fromARGB(255, 71, 148, 214),
          primary:  Color.fromARGB(255, 8, 79, 161), 
          onPrimary:  Color.fromARGB(255, 231, 236, 239), 
          secondary:  Color.fromARGB(255, 155, 178, 194),
          onSecondary:  Color.fromARGB(255, 8, 79, 161), 
          tertiary:  Color.fromARGB(255, 233, 135, 7),
          onTertiary:  Color.fromARGB(255, 8, 79, 161),
          error:  Color.fromARGB(255, 218, 41, 28), 
          onError:  Color.fromARGB(255, 231, 236, 239), 
          surface:  Color.fromARGB(255, 231, 236, 239), 
          onSurface:  Color.fromARGB(255, 8, 79, 161))
          ),
      home: LoginPage(),
      routes: {
        '/LoginPage': (context) => LoginPage(),
        '/RegistrationPage': (context) => RegistrationPage(),
        '/HomePage' : (context) => HomePage(),
        '/RisultatiCercaPage' : (context) => RisultatiCercaPage(),
      },
    );
  }
}