import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class TextfieldWithMask extends StatelessWidget {
  final dynamic controller;
  final String maskInput;
  final String labelText;
  final String hintText;
  final bool obscureText;
  final bool checkError;
  final String messageError;

  const TextfieldWithMask({
    super.key,
    required this.controller,
    required this.maskInput,
    required this.labelText,
    required this.hintText,
    required this.obscureText,
    required this.checkError,
    required this.messageError,
  });

  @override
  Widget build(BuildContext context) {
    final maskFormatter = MaskTextInputFormatter(mask: maskInput);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: TextField(
        controller: controller,
        inputFormatters: [maskFormatter],
        obscureText: obscureText,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        decoration: InputDecoration(
          constraints: BoxConstraints(maxWidth: 334),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.onBackground),
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
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          errorText: checkError ? messageError : null,
        ),
      ),
    );
  }
}
