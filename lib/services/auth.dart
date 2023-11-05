import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // sign up a user with email and password
  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  // sign in with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // Handle the case where the email is not registered.
        print('User not found.');
      } else if (e.code == 'wrong-password') {
        // Handle the case where the password is incorrect.
        print('Wrong password.');
      } else {
        // Handle other errors.
        print('An error occurred on sign in: ${e.code}');
      }
      return null;
    }
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
