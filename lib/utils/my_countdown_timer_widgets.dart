import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final int totalTime;
  final VoidCallback onPressed;
  const CountdownTimer({
    super.key,
    required this.totalTime,
    required this.onPressed
    });

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  int remainingTime = 0;
  double progress = 1.0;
  Timer? timer;
  bool isRunning = false;

  @override
  void initState(){
    super.initState();
    remainingTime = widget.totalTime;
  }

  void startTimer() {
    if (isRunning) return;

    widget.onPressed();

    setState(() {
      isRunning = true;
      remainingTime = widget.totalTime;
      progress = 1.0;
    });

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
          progress = remainingTime / widget.totalTime;
        });
      } else {
        timer.cancel();
        setState(() {
          isRunning = false;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: isRunning ? null : startTimer,
          child: Visibility(
            visible: !isRunning,
            child: Row(
              children: [
                Icon(Icons.refresh_rounded),
                SizedBox(width: MediaQuery.sizeOf(context).width * 0.01,),
                Text("Reinvia codice", style: TextStyle(color: Colors.black, decoration: TextDecoration.underline,),),
            ],),
          )
        ),
        Visibility(
          visible: isRunning,
          child: Row(
            children: [
              Text("Richiedi nuovamente codice tra: ", style: TextStyle(color: Colors.black,))
          ])
        ),
        SizedBox(width: MediaQuery.sizeOf(context).width * 0.02,),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 3,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.outline),
              ),
            ),
            // Testo al centro
            Text(
              "$remainingTime s",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
