import 'package:flutter/material.dart';

class LogoImage extends StatelessWidget {
  const LogoImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      height: 150.0,
      width: 190.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
      ),
      child: Image.asset('assets/images/logo.png'),
    );
  }
}
