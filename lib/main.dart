import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:domus_app/pages/agente_home_page.dart';
import 'package:domus_app/pages/controllore_pagine_agente.dart';
import 'package:domus_app/pages/initial_page.dart';
import 'package:domus_app/pages/password_dimenticata_page.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'amplifyconfiguration.dart';

import 'package:domus_app/pages/cliente_annuncio_page.dart';
import 'package:domus_app/pages/controllore_pagine.dart';
import 'package:domus_app/pages/controllore_pagine2.dart';
import 'package:domus_app/pages/registration_page.dart';
import 'package:domus_app/pages/risultati_cerca_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    // Add any Amplify plugins you want to use
    final authPlugin = AmplifyAuthCognito();
    await Amplify.addPlugin(authPlugin);

    // You can use addPlugins if you are going to be adding multiple plugins
    // await Amplify.addPlugins([authPlugin, analyticsPlugin]);

    // Once Plugins are added, configure Amplify
    // Note: Amplify can only be configured once.
    try {
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      safePrint("Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
    }
  }



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
          onSurface:  Color.fromARGB(255, 8, 79, 161),
          // outline: Colors.black,
          outline: Colors.black,

          )
        ),
      // home: LoginPage(),
      home: InitialPage(),
      routes: {
        '/LoginPage': (context) => LoginPage(),
        '/RegistrationPage': (context) => RegistrationPage(),
        '/HomePage' : (context) => ControllorePagine(),
        '/RisultatiCercaPage' : (context) => RisultatiCercaPage(),
        '/ControllorePagine2': (context) => ControllorePagine2(),
        '/PasswordDimenticataPage' : (context) => PasswordDimenticataPage(),
        '/ControllorePagineAgente' : (context) => ControllorePagineAgente(),
      },
    );
  }
}