// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final Function(String) onSaved;
  // regular Experession for validation
  final String regEx;
  final String hintText;
  final bool obscuredText;

  CustomTextFormField({
    required this.onSaved,
    required this.regEx,
    required this.hintText,
    required this.obscuredText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: (value) => onSaved(value!),
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      obscureText: obscuredText,
      validator: (value) {
        return RegExp(regEx).hasMatch(value!) ? null : 'Enter a valid value !';
      },
      decoration: InputDecoration(
        fillColor: Color.fromRGBO(30, 29, 37, 1.0),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white54),
      ),
    );
  }
}
