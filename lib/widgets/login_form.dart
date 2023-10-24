import 'package:eurobingo/widgets/home_page.dart';
import 'package:eurobingo/widgets/login_button.dart';
import 'package:eurobingo/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:eurobingo/widgets/logo_image.dart';

class LoginForm extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  LoginForm({super.key});

  String? validateFields(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please fill the field correctly';
    }
    return null;
  }

  void redirectAfterLogin(BuildContext context) {
    if (formKey.currentState!.validate()) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const LogoImage(),
                      FormTextField(
                        label: 'Username',
                        hintText: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        validator: validateFields,
                      ),
                      FormTextField(
                        label: 'Password',
                        hintText: 'Enter your password',
                        obscureText: true,
                        validator: validateFields,
                      ),
                      LoginButton(
                          label: 'Login',
                          onPressed: () => redirectAfterLogin(context)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 200),
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Forgot Password',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}