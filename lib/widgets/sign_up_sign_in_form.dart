import 'package:eurobingo/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eurobingo/services/authentication_state.dart';

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
  AuthenticationState auth = AuthenticationState();
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
  String confirmPassword = '';
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

    _confirmPasswordController.addListener(() {
      setState(() {
        confirmPassword = _confirmPasswordController.text;
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

  void redirectToLoginPage(BuildContext context) {
    // Unfocus any active text fields to hide the keyboard
    FocusScope.of(context).unfocus();

    // Navigate to the LoginScreen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
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
                      ),
                    FormTextField(
                      label: 'Email',
                      hintText: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      focusNode: emailFocusNode,
                    ),
                    FormTextField(
                      label: 'Password',
                      hintText: 'Enter your password',
                      obscureText: true,
                      controller: _passwordController,
                      focusNode: passwordFocusNode,
                    ),
                    if (isRegistration)
                      FormTextField(
                        label: 'Confirm password',
                        hintText: 'Re-enter your password',
                        obscureText: true,
                        controller: _confirmPasswordController,
                        focusNode: confirmPasswordFocusNode,
                      ),
                    LoginRegisterButton(
                      label: isRegistration ? 'Create account' : 'Sign in',
                      onPressed: () async {
                        List<String> errorMessages = await auth
                            .signInWithEmailAndPassword(email, password);
                        if (errorMessages.isEmpty) {
                          // Navigate to the authenticated screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        } else {
                          /// Show error messages to the user
                          for (String errorMessage in errorMessages) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(errorMessage),
                            ));
                          }
                        }
                      },
                      onRegister: () async {
                        List<String> errorMessages =
                            await auth.signUpAndSaveUser(context, name, email,
                                password, confirmPassword);
                        if (errorMessages.isEmpty) {
                          // Registration was successful, navigate to the authenticated screen
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                        } else {
                          // Show error messages to the user
                          for (String errorMessage in errorMessages) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(errorMessage),
                            ));
                          }
                        }
                        //redirectAfterLogin(context);
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
}
