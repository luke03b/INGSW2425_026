import 'package:flutter/material.dart';

class MyTextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final Icon icon;

  const MyTextFieldWidget({super.key,
  required this.controller,
  required this.text,
  required this.icon,
  });

  @override
  State<MyTextFieldWidget> createState() => _MyTextFieldWidgetState();
}

class _MyTextFieldWidgetState extends State<MyTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      style: TextStyle(
        fontSize: 18.0, 
      ),
      decoration: InputDecoration(
        hintText: widget.text,
        icon: widget.icon,
      ),
    );
  }
}

class MyPasswordFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final Icon icon;

  const MyPasswordFieldWidget({super.key,
  required this.controller,
  required this.text,
  required this.icon
  });

  @override
  State<MyPasswordFieldWidget> createState() => _MyPasswordFieldWidgetState();
}

class _MyPasswordFieldWidgetState extends State<MyPasswordFieldWidget> {
  bool _isPasswordObscured = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
              controller: widget.controller,
              style: TextStyle(fontSize: 18.0),
              obscureText: _isPasswordObscured,
              decoration: InputDecoration(
                hintText: widget.text,
                icon: widget.icon,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isPasswordObscured = !_isPasswordObscured;
                    });
                  }, 
                  icon: _isPasswordObscured ? Icon(Icons.visibility) : Icon(Icons.visibility_off))
              ),
            );
  }
}