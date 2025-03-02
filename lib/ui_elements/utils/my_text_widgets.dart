import 'package:domus_app/ui_elements/theme/ui_constants.dart';
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
  required this.color,
  });

  @override
  State<MyTextFieldPrefixIcon> createState() => _MyTextFieldPrefixIconState();
}

class _MyTextFieldPrefixIconState extends State<MyTextFieldPrefixIcon> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: context.onSecondary,
      controller: widget.controller,
      style: TextStyle(
        fontSize: 18.0, 
        color: widget.color,
      ),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: context.outline), // Colore della linea quando non è in focus
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: context.onSecondary, width: 2.0), // Colore della linea quando scrivi
        ),
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
      cursorColor: context.onSecondary,
      controller: widget.controller,
      style: TextStyle(fontSize: 18.0, color: widget.color),
      obscureText: _isPasswordObscured,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: context.outline), // Colore della linea quando non è in focus
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: context.onSecondary, width: 2.0), // Colore della linea quando scrivi
        ),
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
      cursorColor: context.onSecondary,
      controller: widget.controller,
      style: TextStyle(
        fontSize: 18.0, 
        color: widget.colore,
      ),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: context.outline), // Colore della linea quando non è in focus
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: context.onSecondary, width: 2.0), // Colore della linea quando scrivi
        ),
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
  final Color? coloreLinea;

  const MyTextFieldOnlyPositiveNumbers({super.key,
  required this.controller,
  required this.text,
  required this.colore,
  this.coloreLinea
  });

  @override
  State<MyTextFieldOnlyPositiveNumbers> createState() => _MyTextFieldOnlyPositiveNumbersState();
}

class _MyTextFieldOnlyPositiveNumbersState extends State<MyTextFieldOnlyPositiveNumbers> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: context.onSecondary,
      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("^(0|[1-9][0-9]*)"))],
      controller: widget.controller,
      style: TextStyle(
        fontSize: 18.0,
        color: widget.colore, 
        fontWeight: FontWeight.normal
      ),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: widget.coloreLinea ?? context.outline), // Colore della linea quando non è in focus
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: context.onSecondary, width: 2.0), // Colore della linea quando scrivi
        ),
        hintText: widget.text,
        hintStyle: TextStyle(color: widget.colore)
      ),
    );
  }
}

class MyTextFieldOnlyPositiveNumbersWithValidation extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final Color colore;
  final Function(String) onChanged;

  const MyTextFieldOnlyPositiveNumbersWithValidation({super.key,
  required this.controller,
  required this.text,
  required this.colore,
  required this.onChanged
  });

  @override
  State<MyTextFieldOnlyPositiveNumbersWithValidation> createState() => MyTextFieldOnlyPositiveNumbersWithValidationState();
}

class MyTextFieldOnlyPositiveNumbersWithValidationState extends State<MyTextFieldOnlyPositiveNumbersWithValidation> {

  bool _hasError = false;

  void setError(bool value) {
    setState(() {
      _hasError = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {
        if (_hasError) {
          setState(() {
            _hasError = false;
          });
        }
        widget.onChanged(value);
      },
      cursorColor: context.onSecondary,
      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("^(0|[1-9][0-9]*)"))],
      controller: widget.controller,
      style: TextStyle(
        fontSize: 18.0,
        color: widget.colore, 
        fontWeight: FontWeight.normal
      ),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _hasError ? context.error : context.outline), // Colore della linea quando non è in focus
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _hasError ? context.error : context.onSecondary, width: 2.0), // Colore della linea quando scrivi
        ),
        hintText: widget.text,
        hintStyle: TextStyle(color: widget.colore)
      ),
    );
  }
}

class MyTextFieldWithValidation extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final String hintText;
  final Color colore;
  final Function(String) onChanged;


  const MyTextFieldWithValidation({super.key,
  required this.controller,
  required this.text,
  required this.hintText,
  required this.colore,
  required this.onChanged
  });

  @override
  State<MyTextFieldWithValidation> createState() => MyTextFieldWithValidationState();
}

class MyTextFieldWithValidationState extends State<MyTextFieldWithValidation> {
  bool _hasError = false;

  void setError(bool value) {
    setState(() {
      _hasError = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged:  (value) {
        if (_hasError) {
          setState(() {
            _hasError = false;
          });
        }
        widget.onChanged(value);
      },
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: context.outline),),
        labelText: widget.text,  // Testo del label
        labelStyle: TextStyle(color: _hasError ? context.error : context.onSecondary),
        hintText: widget.hintText,  // Testo di suggerimento
        hintStyle: TextStyle(color: widget.colore),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.5),
        )
      ),
      style: TextStyle(color: widget.colore,),
      maxLines: null,
      controller: widget.controller
    );
  }
}