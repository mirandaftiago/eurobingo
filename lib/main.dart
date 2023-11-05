import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:eurobingo/widgets/sign_up_sign_in_form.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: kIsWeb
          ? const FirebaseOptions(
              apiKey: "AIzaSyAYravhgkwa5tbCYwcLNnppuXBlLoqUpS0",
              authDomain: "eurobingo-89864.firebaseapp.com",
              projectId: "eurobingo-89864",
              storageBucket: "eurobingo-89864.appspot.com",
              messagingSenderId: "464488566350",
              appId: "1:464488566350:web:267101aa9d83ae1ac0bd1f",
              measurementId: "G-KY0KJF9321")
          : DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(const EurobingoApp());
}

class EurobingoApp extends StatelessWidget {
  const EurobingoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SignUpSignInForm(),
      debugShowCheckedModeBanner: false,
      // Add other MaterialApp configuration here
    );
  }
}
