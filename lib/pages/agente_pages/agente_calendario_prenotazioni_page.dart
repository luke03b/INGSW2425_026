import 'package:flutter/material.dart';

class AgenteCalendarioPrenotazioniPage extends StatefulWidget {
  const AgenteCalendarioPrenotazioniPage({super.key});

  @override
  State<AgenteCalendarioPrenotazioniPage> createState() => _AgenteCalendarioPrenotazioniPageState();
}

class _AgenteCalendarioPrenotazioniPageState extends State<AgenteCalendarioPrenotazioniPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.surface,
        ),
        title: Text("Calendario prenotazioni", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 5,
        shadowColor: Colors.black,
      ),
      body: Placeholder());
  }
}