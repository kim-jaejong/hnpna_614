import 'package:flutter/material.dart';
import 'custom_form.dart';
import 'login_title.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            const LoginTitle(),
            const SizedBox(height: 20),
            CustomForm(),
          ],
        ),
      ),
    );
  }
}
