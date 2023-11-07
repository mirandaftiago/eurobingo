import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/login_screen.dart';

class AuthenticationState extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;

  User? get user => _user;

  // handle user state for log out purposes
  AuthenticationState() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // sign up a user with email and password
  Future<List<String>> signInWithEmailAndPassword(
      String email, String password) async {
    // Validate the email and password fields
    List<String> errorMessages = validateCredentials(email, password);

    if (errorMessages.isNotEmpty) return errorMessages;

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return [];
    } on FirebaseAuthException catch (e) {
      return _handleAuthException(e);
    }
  }

  // sign in a user
  Future<List<String>> signUpAndSaveUser(BuildContext context, String name, String email, String password, String confirmPassword) async {
    final errorMessages = validateSignUpFields(name, email, password, confirmPassword);

    if (errorMessages.isNotEmpty) return errorMessages;
    
    try {
      // Step 1: Create the user with Firebase Authentication
      final authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final user = authResult.user;

      if (user != null) {
        // Step 2: Save user information to Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
        });
        print('User is successfully created and saved to Firestore');
      } else {
        print('Some error happened during user creation');
      }
      return [];
    } catch (e) {
      print('Error during sign up and user creation: $e');
      return ['Sign-up failed'];
    }
  }


  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();;
    } catch (e) {
      print('Error during logout: $e');
    }

    // Unfocus any active text fields to hide the keyboard
    FocusScope.of(context).unfocus();

    // Navigate to the LoginScreen or perform any other actions
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  List<String> validateCredentials(String email, String password) {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    final emailError = validateField(email, 'E-mail address', emailRegExp);
    final passwordError = validatePassword(password);
    return [if (emailError != null) emailError, if (passwordError != null) passwordError];
  }

  List<String> validateSignUpFields(String name, String email, String password, String confirmPassword) {
    return [
      if (name.isEmpty) 'Name is required',
      if (email.isEmpty) 'Email is required',
      if (password.isEmpty) 'Password is required',
      if (confirmPassword.isEmpty) 'Confirm password is required',
      if (password != confirmPassword) 'Passwords do not match',
      ...validateCredentials(email, password),
    ];
  }

  List<String> _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'auth/invalid-email':
        return ['Invalid email address'];
      case 'wrong-password':
        return ['Incorrect password'];
      case 'user-not-found':
        return ['User does not exist'];
      default:
        return ['Sign-in failed!'];
    }
  }

  String? validateField(String? value, String fieldName, RegExp pattern) {
    if (value == null || value.isEmpty) return '$fieldName is required';
    if (!pattern.hasMatch(value)) return 'Invalid $fieldName format';
    return null;
  }

  String? validatePassword(String? password) {
    return validateField(
        password,
        'Password',
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'),
    );
  }
}
