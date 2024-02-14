import 'package:flutter/material.dart';

class DefaultTextfield extends StatelessWidget {
  final dynamic controller;
  final String labelText;
  final String hintText;
  final bool obscureText;

  const DefaultTextfield({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff260145),
            ),
          ),
          fillColor: Colors.grey.shade200,
          filled: false,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
          ),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }
}
