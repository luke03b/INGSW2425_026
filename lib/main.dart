import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:domus_app/pages/agente_pages/agente_controllore_pagine.dart';
import 'package:domus_app/pages/auth_pages/initial_page.dart';
import 'package:domus_app/pages/auth_pages/password_dimenticata_page.dart';
import 'package:domus_app/ui_elements/theme/theme_provider.dart';
import 'package:domus_app/ui_elements/theme/ui_constants.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'amplifyconfiguration.dart';
import 'package:domus_app/pages/cliente_pages/cliente_controllore_pagine.dart';
import 'package:domus_app/pages/cliente_pages/cliente_controllore_pagine2.dart';
import 'package:domus_app/pages/auth_pages/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/auth_pages/login_page.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
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
    return Selector<ThemeProvider, ThemeMode>(
      selector: (_, provider) => provider.themeMode, // Ascolta solo il tema
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