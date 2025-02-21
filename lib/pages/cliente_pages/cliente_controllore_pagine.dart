import 'package:domus_app/pages/cliente_pages/cliente_prenotazioni_page.dart';
import 'package:domus_app/pages/shared_pages/profilo_page.dart';
import 'package:domus_app/theme/ui_constants.dart';
import 'package:flutter/material.dart';
import 'cliente_cerca_page.dart';
import 'cliente_offerte_page.dart';

class ControllorePagine extends StatefulWidget {
  const ControllorePagine({super.key});

  @override
  State<ControllorePagine> createState() => _ControllorePagineState();
}

class _ControllorePagineState extends State<ControllorePagine> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    CercaPage(),
    OffertePage(),
    ClientePrenotazioniPage(),
    ProfiloPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Aggiungi qui la linea separatrice
          Container(
            height: 0.3,
            color: context.outline, // Colore della linea separatrice
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