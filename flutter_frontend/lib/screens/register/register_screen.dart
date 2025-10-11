import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/api.dart';

class RegisterScreen extends StatefulWidget {
  // Constructor
  const RegisterScreen({super.key});

  // Stateful widget => define how the state is created
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

// Private state class for RegisterScreen (available only within this file)
class _RegisterScreenState extends State<RegisterScreen> {
  // TextField controllers to catch input
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Dispose controllers when the widget is removed from the widget tree
  @override
  void dispose() {
    _usernameController.dispose();
    _nicknameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nicknameController,
                decoration: const InputDecoration(labelText: 'Nickname'),
              ),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text("Register"),
                onPressed: () async {
                  // Get text from controllers
                  final username = _usernameController.text.trim();
                  final nickname = _nicknameController.text.trim();
                  final password = _passwordController.text;

                  // Input validation
                  if (username.isEmpty ||
                      nickname.isEmpty ||
                      password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all fields')),
                    );
                    return;
                  }

                  try {
                    final result = await BackendAPI.registerUser(
                      username: username,
                      nickname: nickname,
                      password: password,
                    );
                    if (!mounted) return; // Safety check

                    if (result['success']) {
                      // Handle successful registration
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Registration successful!'),
                        ),
                      );
                      context.go('/login');
                    } else {
                      // Handle registration error
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${result['error']}')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Network error: $e')),
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              TextButton(
                child: const Text('Back to Login'),
                onPressed: () {
                  context.go('/login');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
