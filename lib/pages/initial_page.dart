import 'package:domus_app/pages/controllore_pagine.dart';
import 'package:domus_app/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  Future<bool> isUserLoggedIn() async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');

    //il token esiste e non è scaduto
    if (token != null && !JwtDecoder.isExpired(token)){
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isUserLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()), // Schermata di caricamento
          );
        } else if (snapshot.hasError || snapshot.data == false) {
          return LoginPage(); // Mostra la pagina di login
        } else {
          return ControllorePagine(); // Mostra la pagina successiva
        }
      },
    );
  }
}