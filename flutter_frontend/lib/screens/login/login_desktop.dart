import 'package:flutter/material.dart';
import 'login_common.dart';

class LoginDesktop extends StatelessWidget {
  const LoginDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(40),
          child: SizedBox(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: const LoginForm(isDesktop: true),
            ),
          ),
        ),
      ),
    );
  }
}
