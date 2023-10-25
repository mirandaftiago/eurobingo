import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:eurobingo/widgets/login_form.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const EurobingoApp());
}

class EurobingoApp extends StatelessWidget {
  const EurobingoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginForm(),
      // Add other MaterialApp configuration here
    );
  }
}
