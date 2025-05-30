import 'package:domus_app/costants/costants.dart';
import 'package:domus_app/pages/cliente_pages/cliente_controllore_pagine.dart';
import 'package:domus_app/pages/agente_pages/agente_controllore_pagine.dart';
import 'package:domus_app/pages/auth_pages/login_page.dart';
import 'package:domus_app/amazon_services/aws_cognito.dart';
import 'package:flutter/material.dart';

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
            body: Center(child: CircularProgressIndicator()), 
          );
        } else if (snapshot.hasError || snapshot.data == false) {          
          return LoginPage(); 
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
                if (userGroup == TipoRuolo.ADMIN || userGroup == TipoRuolo.AGENTE) {
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