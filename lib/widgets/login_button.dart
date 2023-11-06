import 'package:flutter/material.dart';

class LoginRegisterButton extends StatelessWidget {
  final String label;
  final void Function() onPressed;
  final void Function()? onRegister;

  const LoginRegisterButton({
    super.key, 
    required this.label,
    required this.onPressed,
    this.onRegister,
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
        onPressed: () {
          if (onRegister != null && label == 'Create account') {
            onRegister!(); // call onRegister if it's provided and the label is Register.
          } else {
            onPressed(); // call the regular onPressed function
          }
        },
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
    );
  }
}