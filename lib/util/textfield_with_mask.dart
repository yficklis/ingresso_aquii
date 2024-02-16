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
          errorText: checkError ? messageError : null,
        ),
      ),
    );
  }
}
