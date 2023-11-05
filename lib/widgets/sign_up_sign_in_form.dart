import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eurobingo/services/auth.dart';

import 'package:eurobingo/widgets/home_page.dart';
import 'package:eurobingo/widgets/login_button.dart';
import 'package:eurobingo/widgets/text_field.dart';
import 'package:eurobingo/widgets/logo_image.dart';

class SignUpSignInForm extends StatefulWidget {
  const SignUpSignInForm({super.key});

  @override
  State<SignUpSignInForm> createState() => _SignUpSignInFormState();
}

class _SignUpSignInFormState extends State<SignUpSignInForm> {
  late FirebaseAuthService auth;
  final formKey = GlobalKey<FormState>();
  final nameFocusNode = FocusNode(); // Create a FocusNode for name field
  final emailFocusNode = FocusNode(); // Create a FocusNode for email field
  final passwordFocusNode =
      FocusNode(); // Create a FocusNode for password field
  final confirmPasswordFocusNode =
      FocusNode(); // Create a FocusNode for confirm password field
  bool isRegistration = false;
  bool isKeyboardVisible = false;
  String name = '';
  String email = '';
  String password = '';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    _initializeListeners();
    _startListeningForKeyboard();
  }

  // Method to set up listeners for input fields
  void _initializeListeners() {
    _nameController.addListener(() {
      setState(() {
        name = _nameController.text;
      });
    });

    _emailController.addListener(() {
      setState(() {
        email = _emailController.text;
      });
    });

    _passwordController.addListener(() {
      setState(() {
        password = _passwordController.text;
      });
    });
  }

  // Method to start listening for keyboard visibility changes
  void _startListeningForKeyboard() {
    nameFocusNode.addListener(updateKeyboardVisibility);
    emailFocusNode.addListener(updateKeyboardVisibility);
    passwordFocusNode.addListener(updateKeyboardVisibility);
    confirmPasswordFocusNode.addListener(updateKeyboardVisibility);
    // Start listening for keyboard visibility changes
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  void updateKeyboardVisibility() {
    setState(() {
      isKeyboardVisible = emailFocusNode.hasFocus || passwordFocusNode.hasFocus;
    });
  }

  String? validateFields(String? value, {String? passwordValue}) {
    if (value == null || value.isEmpty) {
      return 'Please fill the field correctly';
    } else if (passwordValue != null && value != passwordValue) {
      return 'Passwords do not match';
    }
    return null;
  }

  void redirectAfterLogin(BuildContext context) {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      // Validation passed, navigate to the next page
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => const HomePage(),
      ));
    }
  }

  // Method to toggle between registration and sign-in
  void toggleFormMode() {
    setState(() {
      isRegistration = !isRegistration;
    });

    formKey.currentState?.reset();
  }

  @override
  void dispose() {
    // Stop listening for keyboard visibility changes
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    // Dispose of the focus nodes
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
        child: Padding(
          padding: const EdgeInsets.only(top: 150),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const LogoImage(),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (isRegistration)
                      FormTextField(
                        label: 'Name',
                        hintText: 'Enter your name',
                        keyboardType: TextInputType.name,
                        controller: _nameController,
                        focusNode: nameFocusNode,
                        validator: validateFields,
                      ),
                    FormTextField(
                      label: 'Email',
                      hintText: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      focusNode: emailFocusNode,
                      validator: validateFields,
                    ),
                    FormTextField(
                      label: 'Password',
                      hintText: 'Enter your password',
                      obscureText: true,
                      controller: _passwordController,
                      focusNode: passwordFocusNode,
                      validator: validateFields,
                    ),
                    if (isRegistration)
                      FormTextField(
                        label: 'Confirm password',
                        hintText: 'Re-enter your password',
                        obscureText: true,
                        controller: _confirmPasswordController,
                        focusNode: confirmPasswordFocusNode,
                        validator: (value) => validateFields(value,
                            passwordValue: _passwordController.text),
                      ),
                    LoginRegisterButton(
                      label: isRegistration ? 'Create account' : 'Sign in',
                      onPressed: () {
                        redirectAfterLogin(context);
                      },
                      onRegister: () {
                        _signUpAndSaveUser();
                        redirectAfterLogin(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: !isKeyboardVisible, // Hide when the keyboard is visible
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: toggleFormMode,
              child: Text(
                isRegistration ? 'Sign in' : 'Create an account',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Forgot Password',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signUpAndSaveUser() async {
    try {
      // Step 1: Create the user with Firebase Authentication
      UserCredential authResult =
          await auth.signUpWithEmailAndPassword(email, password);
      User? user = authResult.user;

      if (user != null) {
        // Step 2: Save user information to Firestore
        await firestore.collection('users').doc(user.uid).set({
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
  }
}
