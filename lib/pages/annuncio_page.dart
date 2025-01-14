import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AnnuncioPage extends StatefulWidget {
  final Map<String, dynamic> casaSelezionata;

  const AnnuncioPage({super.key, required this.casaSelezionata});

  @override
  State<AnnuncioPage> createState() => _AnnuncioPageState();
}

class _AnnuncioPageState extends State<AnnuncioPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    final List<Widget> listaImmagini = [
      Image.asset(widget.casaSelezionata['image1']),
      Image.asset(widget.casaSelezionata['image2']),
      Image.asset(widget.casaSelezionata['image3']),
    ];

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            myCarouselSlider(context, listaImmagini),
            AnimatedSmoothIndicator(
              activeIndex: _currentIndex,
              count: listaImmagini.length,
              effect: ScrollingDotsEffect(
                dotHeight: 8.0,
                dotWidth: 8.0,
                activeDotColor: Theme.of(context).colorScheme.primary
              )
            ),
            SizedBox(height: 7.0),
            Card(
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 10.0),
                      Icon(Icons.euro, size: 35, color: Theme.of(context).colorScheme.outline,),
                      Text(widget.casaSelezionata['prezzo'], style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.outline),),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: 10.0),
                      Text(widget.casaSelezionata['indirizzo'], style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.outline),),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 10.0),
                          Text("Descrizione", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.outline),),
                        ],
                      ),
                    ],
                  ),
                  Card(
                    color: Theme.of(context).colorScheme.onPrimary,
                    child: Text("ciao a tutti sono una descrizione gay e sono alessio, ora provo a fare una descrizione goofy come lui, sono omosessuale e ho i capelli lunghi", ),
                  )
                  
                ],
              ),
            ),
          ],
        )
      )
    );
  }

  CarouselSlider myCarouselSlider(BuildContext context, List<Widget> listaImmagini) {
    return CarouselSlider(
      items: listaImmagini,
      options: CarouselOptions(
        viewportFraction: 0.96,
        height: 220,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        onPageChanged: (index, reason) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}