import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:eurobingo/widgets/home_page.dart';
import 'package:eurobingo/widgets/login_button.dart';
import 'package:eurobingo/widgets/text_field.dart';
import 'package:eurobingo/widgets/logo_image.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final emailFocusNode = FocusNode(); // Create a FocusNode for email field
  final passwordFocusNode =
      FocusNode(); // Create a FocusNode for password field
  final confirmPasswordFocusNode =
      FocusNode(); // Create a FocusNode for confirm password field
  bool isRegistration = false;
  bool isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();

    // Add listeners to observe keyboard visibility changes for email and password fields
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
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  void toggleFormMode() {
    setState(() {
      isRegistration = !isRegistration;
    });

    // reset the form when toggling between login and registration
    formKey.currentState?.reset();
  }

  @override
  void dispose() {
    // Stop listening for keyboard visibility changes
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    passwordController.dispose();
    // Dispose of the focus nodes
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
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
                    FormTextField(
                      label: 'Username',
                      hintText: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      focusNode: emailFocusNode,
                      validator: validateFields,
                    ),
                    FormTextField(
                      label: 'Password',
                      hintText: 'Enter your password',
                      obscureText: true,
                      controller: passwordController,
                      focusNode: passwordFocusNode,
                      validator: validateFields,
                    ),
                    if (isRegistration) // Conditionally render registration fields
                      FormTextField(
                        label: 'Confirm password',
                        hintText: 'Re-enter your password',
                        obscureText: true,
                        focusNode: confirmPasswordFocusNode,
                        validator: (value) => validateFields(value,
                            passwordValue: passwordController.text),
                      ),
                    LoginRegisterButton(
                      label: isRegistration ? 'Register' : 'Login',
                      onPressed: () => redirectAfterLogin(context),
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
                isRegistration ? 'Back to Login' : 'Register',
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
