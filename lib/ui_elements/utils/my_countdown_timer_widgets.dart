import 'dart:async';
import 'package:domus_app/ui_elements/theme/ui_constants.dart';
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
  bool firstTime = true;

  @override
  void initState(){
    super.initState();
    remainingTime = widget.totalTime;
    startTimer();
  }

  void startTimer() {
    if (isRunning) return;

    if(!firstTime) {
      widget.onPressed();
    }

    setState(() {
      if(firstTime) {
        firstTime = false;
      }
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
                Text("Reinvia codice", style: TextStyle(color: context.outline, decoration: TextDecoration.underline, decorationColor: context.outline),),
            ],),
          )
        ),
        Visibility(
          visible: isRunning,
          child: Row(
            children: [
              Text("Richiedi nuovamente codice tra: ", style: TextStyle(color: context.outline,))
          ])
        ),
        SizedBox(width: MediaQuery.sizeOf(context).width * 0.02,),
        Stack(
          alignment: Alignment.center,
          children: [
            // Testo al centro
            Text(
              "$remainingTime s",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.outline),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
