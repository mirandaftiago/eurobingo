import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eurobingo/services/authentication_state.dart';
import 'package:eurobingo/screens/login_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService =
        Provider.of<AuthenticationState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
        actions: [
          ElevatedButton(
            onPressed: () {
              authService.signOut(context);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            child: const Text('Logout'),
          )
        ],
      ),
    );
  }
}
