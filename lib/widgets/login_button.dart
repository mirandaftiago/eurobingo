import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final String label;
  final void Function() onPressed;

  const LoginButton({
    super.key, 
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 250,
      decoration: BoxDecoration(
        color: Colors.green[800],
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
    );
  }
}