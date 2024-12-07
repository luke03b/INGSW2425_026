import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextFieldPrefixIcon extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final Icon icon;

  const MyTextFieldPrefixIcon({super.key,
  required this.controller,
  required this.text,
  required this.icon,
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

class MyTextFieldSuffixIcon extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final Icon icon;

  const MyTextFieldSuffixIcon({super.key,
  required this.controller,
  required this.text,
  required this.icon,
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
      ),
      decoration: InputDecoration(
        hintText: widget.text,
        suffixIcon: widget.icon,
      ),
    );
  }
}

class MyTextFieldOnlyPositiveNumbers extends StatefulWidget {
  final TextEditingController controller;
  final String text;

  const MyTextFieldOnlyPositiveNumbers({super.key,
  required this.controller,
  required this.text,
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
      ),
      decoration: InputDecoration(
        hintText: widget.text,
      ),
    );
  }
}