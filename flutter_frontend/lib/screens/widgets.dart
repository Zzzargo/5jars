import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class CommonWidgets {
  // Private constructor to prevent instantiation
  CommonWidgets._();

  static Widget registerForm({
    required BuildContext context,
    required TextEditingController nicknameController,
    required TextEditingController usernameController,
    required TextEditingController passwordController,
    required bool isLoading,
    required VoidCallback handleRegister,
  }) {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.all(16),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min, // As tall as the children need
            children: [
              Text(
                'Register',
                style: TextStyle(
                  fontSize: 34,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Column(
                  children: [
                    TextField(
                      controller: nicknameController,
                      decoration: InputDecoration(labelText: 'Nickname'),
                    ),
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(labelText: 'Username'),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      obscuringCharacter: '*',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              FractionallySizedBox(
                widthFactor: 0.4,
                child: PlatformElevatedButton(
                  onPressed: isLoading ? null : handleRegister,
                  child: isLoading
                      ? CircularProgressIndicator()
                      : const Text('Register'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
