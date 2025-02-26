import 'package:domus_app/pages/cliente_pages/cliente_prenotazioni_page.dart';
import 'package:domus_app/pages/shared_pages/profilo_page.dart';
import 'package:domus_app/pages/cliente_pages/cliente_risultati_cerca_page.dart';
import 'package:domus_app/theme/ui_constants.dart';
import 'package:flutter/material.dart';
import 'cliente_offerte_page.dart';

class ControllorePagine2 extends StatefulWidget {
  const ControllorePagine2({super.key});

  @override
  State<ControllorePagine2> createState() => _ControllorePagine2State();
}

class _ControllorePagine2State extends State<ControllorePagine2> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final List<Widget> pages = [
      RisultatiCercaPage(
        latitudine: args?['latitudine'] ?? 0.0,
        longitudine: args?['longitudine'] ?? 0.0,
        tipoAnnuncio: args?['tipoAnnuncio'] ?? "",
        raggioRicerca: args?['raggioRicerca'] ?? 0.0,
        prezzoMin: args?['prezzoMin'],
        prezzoMax: args?['prezzoMax'],
        superficieMin: args?['superficieMin'],
        superficieMax: args?['superficieMax'],
        nStanzeMin: args?['nStanzeMin'],
        nStanzeMax: args?['nStanzeMax'],
        garage: args?['garage'] ?? false,
        ascensore: args?['ascensore'] ?? false,
        arredato: args?['arredato'] ?? false,
        giardino: args?['giardino'] ?? false,
        piscina: args?['piscina'] ?? false,
        balcone: args?['balcone'] ?? false,
        vicinoScuole: args?['vicinoScuole'] ?? false,
        vicinoParchi: args?['vicinoParchi'] ?? false,
        vicinoMezzi: args?['vicinoMezzi'] ?? false,
        piano: args?['piano'] ?? "",
        classeEnergetica: args?['classeEnergetica'] ?? "",
      ),
      OffertePage(),
      ClientePrenotazioniPage(),
      ProfiloPage(),
    ];


    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: pages[_selectedIndex],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 0.3,
            color: context.outline,
          ),
          BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _navigateBottomBar,
            type: BottomNavigationBarType.fixed,
            backgroundColor: context.primary,
            selectedItemColor: context.onPrimary,
            unselectedItemColor: context.outline,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.search), activeIcon: Icon(Icons.search, color: context.onSecondary,), label: 'Cerca'),
              BottomNavigationBarItem(icon: Icon(Icons.payments), activeIcon: Icon(Icons.payments, color: context.onSecondary,), label: 'Offerte'),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_month), activeIcon: Icon(Icons.calendar_month, color: context.onSecondary,), label: 'Prenotazioni'),
              BottomNavigationBarItem(icon: Icon(Icons.account_circle), activeIcon: Icon(Icons.account_circle, color: context.onSecondary,), label: 'Profilo'),
            ],
          ),
        ]
      )
    );
  }
}