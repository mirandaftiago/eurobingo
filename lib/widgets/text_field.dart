import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?) validator;

  const FormTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(70, 0, 70, 20),
      child: TextFormField(
        validator: validator,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
          hintText: hintText,
        ),
      ),
    );
  }
}