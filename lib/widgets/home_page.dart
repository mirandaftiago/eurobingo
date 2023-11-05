import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
        actions: const [
        /*  ElevatedButton(
            onPressed: () {
              authService.signOut();
              Navigator.of(context).pop();
            },
            child: const Text('Logout'),
          ) */
        ],
      ),
    );
  }
}
