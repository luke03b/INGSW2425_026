import 'package:domus_app/pages/agente_pages/agente_calendario_prenotazioni_page.dart';
import 'package:domus_app/pages/agente_pages/agente_home_page.dart';
import 'package:domus_app/pages/shared_pages/profilo_page.dart';
import 'package:domus_app/theme/ui_constants.dart';
import 'package:flutter/material.dart';

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
    AgenteCalendarioPrenotazioniPage(),
    ProfiloPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _pages[_selectedIndex],
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
              BottomNavigationBarItem(icon: Icon(Icons.home), activeIcon: Icon(Icons.home, color: context.onSecondary,), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_month), activeIcon: Icon(Icons.calendar_month, color: context.onSecondary,), label: 'Prenotazioni'),
              BottomNavigationBarItem(icon: Icon(Icons.account_circle), activeIcon: Icon(Icons.account_circle, color: context.onSecondary,), label: 'Profilo'),
            ]
          ),
        ],
      ),
    );
  }
}