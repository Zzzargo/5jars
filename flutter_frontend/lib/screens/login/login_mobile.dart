import 'package:flutter/material.dart';
import 'login_common.dart';

class LoginMobile extends StatelessWidget {
  // Constructor
  const LoginMobile({super.key});

  // Build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(child: LoginForm(isDesktop: false)),
      ),
    );
  }
}
