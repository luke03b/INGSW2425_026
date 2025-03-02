import 'package:domus_app/ui_elements/theme/ui_constants.dart';
import 'package:flutter/material.dart';

class MyElevatedButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  const MyElevatedButtonWidget({super.key,
  required this.text,
  required this.onPressed,
  required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        fixedSize: Size(MediaQuery.sizeOf(context).width/2, MediaQuery.sizeOf(context).height/18),
      ),
      child: Text(text,
        style: TextStyle(
          color: context.onError,
          fontSize: 18.0),
      ),
    );
  }
}

class MyTextButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color colore;

  const MyTextButtonWidget({super.key,
  required this.text,
  required this.onPressed,
  required this.colore
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed, 
      child: Text(
        text,
        style: TextStyle(
          decoration: TextDecoration.underline,
          decorationColor: colore,
          color: colore),
        ),
    );
  }
}

class MyElevatedButtonRectWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  const MyElevatedButtonRectWidget({super.key,
  required this.text,
  required this.onPressed,
  required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: color,
        fixedSize: Size(MediaQuery.sizeOf(context).width/2, MediaQuery.sizeOf(context).height/18),
      ),
      child: Text(text,
        style: TextStyle(
          color: context.onError,
          fontSize: 18.0),
      ),
    );
  }
}

class MyAddButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;

  const MyAddButtonWidget({super.key,
  required this.onPressed,
  required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(eccentricity: 0),
        backgroundColor: color,
        fixedSize: Size(MediaQuery.sizeOf(context).width/7, MediaQuery.sizeOf(context).width/7),
      ),
      child: Icon(Icons.add, color: context.tertiaryFixed, size: 40,),
      );
  }
}