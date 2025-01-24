import 'package:domus_app/pages/controllore_pagine.dart';
import 'package:domus_app/pages/controllore_pagine_agente.dart';
import 'package:domus_app/pages/login_page.dart';
import 'package:domus_app/services/aws_cognito.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  String? userGroup;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AWSServices().isUserLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()), // Schermata di caricamento
          );
        } else if (snapshot.hasError || snapshot.data == false) {          
          return LoginPage(); // Mostra la pagina di login
        } else {
          return FutureBuilder(
            future: scegliPaginaDaCaricare(),
            builder: (context, adminSnapshot){
              if (adminSnapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(child: CircularProgressIndicator(),),
                );
              } else if (adminSnapshot.hasError){
                return Scaffold(body: Center(child: Text('Errore durante il caricamento della pagina'),),);
              } else {
                if (userGroup == 'admin') {
                  return ControllorePagineAgente();
                }
                return ControllorePagine();
              }
            }
          );
        }
      },
    );
  }

  Future<void> scegliPaginaDaCaricare() async {
    userGroup = await AWSServices().recuperaGruppoUtenteLoggato();
  }
}