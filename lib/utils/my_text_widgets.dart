import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextFieldPrefixIcon extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final Icon icon;
  final Color color;

  const MyTextFieldPrefixIcon({super.key,
  required this.controller,
  required this.text,
  required this.icon,
  required this.color
  });

  @override
  State<MyTextFieldPrefixIcon> createState() => _MyTextFieldPrefixIconState();
}

class _MyTextFieldPrefixIconState extends State<MyTextFieldPrefixIcon> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      style: TextStyle(
        fontSize: 18.0, 
        color: widget.color,
      ),
      decoration: InputDecoration(
        hintStyle: TextStyle(color: widget.color),
        hintText: widget.text,
        iconColor: widget.color,
        icon: widget.icon,
      ),
    );
  }
}

class MyPasswordFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final Icon icon;
  final Color color;

  const MyPasswordFieldWidget({super.key,
  required this.controller,
  required this.text,
  required this.icon,
  required this.color
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
        hintStyle: TextStyle(color: widget.color),
        hintText: widget.text,
        icon: widget.icon,
        iconColor: widget.color,
        suffixIconColor: widget.color,
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

class MyTextFieldSuffixIcon extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final Icon icon;
  final Color colore;

  const MyTextFieldSuffixIcon({super.key,
  required this.controller,
  required this.text,
  required this.icon,
  required this.colore,
  });

  @override
  State<MyTextFieldSuffixIcon> createState() => _MyTextFieldSuffixIconState();
}

class _MyTextFieldSuffixIconState extends State<MyTextFieldSuffixIcon> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      style: TextStyle(
        fontSize: 18.0, 
        color: widget.colore,
      ),
      decoration: InputDecoration(
        hintStyle: TextStyle(color: widget.colore),
        hintText: widget.text,
        suffixIcon: widget.icon,
        suffixIconColor: widget.colore
      ),
    );
  }
}

class MyTextFieldOnlyPositiveNumbers extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final Color colore;

  const MyTextFieldOnlyPositiveNumbers({super.key,
  required this.controller,
  required this.text,
  required this.colore,
  });

  @override
  State<MyTextFieldOnlyPositiveNumbers> createState() => _MyTextFieldOnlyPositiveNumbersState();
}

class _MyTextFieldOnlyPositiveNumbersState extends State<MyTextFieldOnlyPositiveNumbers> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("^(0|[1-9][0-9]*)"))],
      controller: widget.controller,
      style: TextStyle(
        fontSize: 18.0,
        color: widget.colore, 
      ),
      decoration: InputDecoration(
        hintText: widget.text,
        hintStyle: TextStyle(color: widget.colore)
      ),
    );
  }
}