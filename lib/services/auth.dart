import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // sign up a user with email and password
  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<List<String>> signInWithEmailAndPassword(String email, String password) async {
    // Validate the email and password fields
    List<String> errorMessages = [];
    if (email.isEmpty) {
      errorMessages.add('Email is required');
    }

    if (password.isEmpty) {
      errorMessages.add('Password is required');
    }

    if (errorMessages.isNotEmpty) {
      return errorMessages;
    }

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return []; // Sign-in successful
    } catch (e) {
      print("Error: $e");
      return ['Sign-in failed']; // Sign-in failed
    }
  }

  Future<List<String>> signUpAndSaveUser(BuildContext context, String name,
      String email, String password, String confirmPassword) async {
    List<String> errorMessages = [];
    if (name.isEmpty) {
      errorMessages.add('Name is required');
    }

    if (email.isEmpty) {
      errorMessages.add('Email is required');
    }

    if (password.isEmpty) {
      errorMessages.add('Password is required');
    }

    if (confirmPassword.isEmpty) {
      errorMessages.add('Confirm password is required');
    }

    if (password != confirmPassword) {
      errorMessages.add('Passwords do not match');
    }

    // Validate the email, password, and name fields
    if (errorMessages.isNotEmpty) {
      return errorMessages;
    }

    try {
      // Step 1: Create the user with Firebase Authentication
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = authResult.user;

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
    } catch (e) {
      print('Error during sign up and user creation: $e');
    }
    return [];
  }

  // handle sign out action
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error during logout: $e');
    }
  }
  // register with email & password
}
