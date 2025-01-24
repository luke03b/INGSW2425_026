import 'package:flutter/material.dart';

class MyInfoDialog extends StatelessWidget {
  final String title;
  final String bodyText;
  final String buttonText;
  final VoidCallback onPressed;

  const MyInfoDialog({
    super.key,
    required this.title,
    required this.bodyText,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
            title: Text(title, style: TextStyle(fontSize: 25, color: Theme.of(context).colorScheme.outline),),
            content: Text(bodyText, style: TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.outline)),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary
                ),
                onPressed: (){
                  onPressed();
                }, 
                child: Text(buttonText, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary,),)
              ),
            ],
          );
  }
}

class MyOptionsDialog extends StatelessWidget {
  final String title;
  final String bodyText;
  final String leftButtonText;
  final Color leftButtonColor;
  final String rightButtonText;
  final Color rightButtonColor;
  final VoidCallback onPressLeftButton;
  final VoidCallback onPressRightButton;

  const MyOptionsDialog({
    super.key,
    required this.title,
    required this.bodyText,
    required this.leftButtonText,
    required this.leftButtonColor,
    required this.rightButtonText,
    required this.rightButtonColor,
    required this.onPressLeftButton,
    required this.onPressRightButton,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
            title: Text(title, style: TextStyle(fontSize: 25, color: Theme.of(context).colorScheme.outline),),
            content: Text(bodyText, style: TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.outline)),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: leftButtonColor,
                  fixedSize: Size(MediaQuery.sizeOf(context).width/5, MediaQuery.sizeOf(context).height/27),
                ),
                onPressed: (){
                  onPressLeftButton();
                }, 
                child: Text(leftButtonText, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary,),)
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: rightButtonColor,
                  fixedSize: Size(MediaQuery.sizeOf(context).width/5, MediaQuery.sizeOf(context).height/27),
                ),
                onPressed: (){
                  onPressRightButton();
                }, 
                child: Text(rightButtonText, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary,),)
              ),
            ],
          );
  }
}