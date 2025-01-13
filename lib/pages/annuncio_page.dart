import 'package:flutter/material.dart';

class AnnuncioPage extends StatefulWidget {
  final Map<String, dynamic> casaSelezionata;

  const AnnuncioPage({super.key, required this.casaSelezionata});

  @override
  State<AnnuncioPage> createState() => _AnnuncioPageState();
}

class _AnnuncioPageState extends State<AnnuncioPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.surface,
        ),
        title: Text("House Hunters", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 5,
        shadowColor: Colors.black,
      ),
      body: Text(widget.casaSelezionata['indirizzo']));
  }
}