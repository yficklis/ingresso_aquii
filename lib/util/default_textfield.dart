import 'package:flutter/material.dart';

class DefaultTextfield extends StatelessWidget {
  final dynamic controller;
  final String labelText;
  final String hintText;
  final bool obscureText;
  final bool checkError;
  final String messageError;
  final dynamic contentPadding;

  const DefaultTextfield({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.obscureText,
    required this.checkError,
    required this.messageError,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          fillColor: Theme.of(context).colorScheme.onBackground,
          filled: false,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
          ),
          labelText: labelText,
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          errorText: checkError ? messageError : null,
          contentPadding: contentPadding ?? null,
        ),
      ),
    );
  }
}
