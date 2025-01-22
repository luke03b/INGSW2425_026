import 'package:domus_app/pages/agente_home_page.dart';
import 'package:domus_app/pages/agente_offerte_page.dart';
import 'package:domus_app/pages/prenotazioni_page.dart';
import 'package:domus_app/pages/profilo_page.dart';
import 'package:flutter/material.dart';
import 'cerca_page.dart';
import 'offerte_page.dart';

class ControllorePagineAgente extends StatefulWidget {
  const ControllorePagineAgente({super.key});

  @override
  State<ControllorePagineAgente> createState() => _ControllorePagineAgenteState();
}

class _ControllorePagineAgenteState extends State<ControllorePagineAgente> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    AgenteHomePage(),
    AgenteOffertePage(),
    PrenotazioniPage(),
    ProfiloPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.primary,
        selectedItemColor: Theme.of(context).colorScheme.onPrimary,
        unselectedItemColor: Colors.black87,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.payments), label: 'Offerte'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Prenotazioni'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profilo'),
        ]
      ),
    );
  }
}