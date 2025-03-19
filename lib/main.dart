import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:domus_app/api_utils/api_key_provider.dart';
import 'package:domus_app/pages/agente_pages/agente_controllore_pagine.dart';
import 'package:domus_app/pages/auth_pages/initial_page.dart';
import 'package:domus_app/pages/auth_pages/password_dimenticata_page.dart';
import 'package:domus_app/providers/theme_provider.dart';
import 'package:domus_app/ui_elements/theme/ui_constants.dart';
import 'amplifyconfiguration.dart';
import 'package:domus_app/pages/cliente_pages/cliente_controllore_pagine.dart';
import 'package:domus_app/pages/cliente_pages/cliente_controllore_pagine2.dart';
import 'package:domus_app/pages/auth_pages/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/auth_pages/login_page.dart';
import 'package:provider/provider.dart';
import 'package:domus_app/providers/visita_provider.dart';
import 'package:dcdg/dcdg.dart';



void main() async {
  await ApiKeyProvider.initializeDotEnv();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => VisitaProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
    
    final authPlugin = AmplifyAuthCognito();
    await Amplify.addPlugin(authPlugin);

    try {
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      safePrint("Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return Selector<ThemeProvider, ThemeMode>(
      selector: (_, provider) => provider.themeMode, 
      builder: (context, themeMode, child) {
        return MaterialApp(
          title: 'House Hunters',
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const InitialPage(),
          routes: {
            '/LoginPage': (context) => const LoginPage(),
            '/RegistrationPage': (context) => const RegistrationPage(),
            '/HomePage': (context) => const ControllorePagine(),
            '/ControllorePagine2': (context) => const ControllorePagine2(),
            '/PasswordDimenticataPage': (context) => const PasswordDimenticataPage(),
            '/ControllorePagineAgente': (context) => const ControllorePagineAgente(),
          },
        );
      },
    );
  }
}