import 'package:domus_app/pages/prova_page.dart';
import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Domus360',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        //colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 39, 76, 119))),
        colorScheme: const ColorScheme(
          brightness: Brightness.light, 
          // primary: Color.fromARGB(255, 71, 148, 214),
          primary:  Color.fromARGB(255, 39, 76, 119), 
          onPrimary:  Color.fromARGB(255, 231, 236, 239), 
          secondary:  Color.fromARGB(255, 96, 150, 186),
          onSecondary:  Color.fromARGB(255, 39, 76, 119), 
          tertiary:  Color.fromARGB(255, 255, 192, 117),
          onTertiary:  Color.fromARGB(255, 39, 76, 119),
          error:  Color.fromARGB(255, 218, 41, 28), 
          onError:  Color.fromARGB(255, 231, 236, 239), 
          surface:  Color.fromARGB(255, 231, 236, 239), 
          onSurface:  Color.fromARGB(255, 39, 76, 119))
          ),
      home: LoginPage(),
      routes: {
        '/LoginPage': (context) => LoginPage(),
        '/ProvaPage': (context) => ProvaPage(),
      },
    );
  }
}