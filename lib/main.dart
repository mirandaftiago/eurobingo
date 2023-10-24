import 'package:flutter/material.dart';
import 'package:eurobingo/widgets/login_form.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Eurobingo dos Pobres'),
        centerTitle: true,
        backgroundColor: Colors.green[800],
      ),
      body: Center(child: LoginForm()),
    ),
  ));
}