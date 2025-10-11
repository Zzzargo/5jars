import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/api.dart';

class LoginForm extends StatefulWidget {
  // Constructor
  const LoginForm({super.key, required this.isDesktop});

  // Indicates if the layout is for desktop
  final bool isDesktop;

  // Stateful widget => define how the state is created
  @override
  State<LoginForm> createState() => _LoginFormState();
}

// Private state class for LoginForm (available only within this file)
class _LoginFormState extends State<LoginForm> {
  // Controllers to catch form text input
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  // Dispose controllers when the widget is removed from the widget tree
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Async function to send a login request and update the state accordingly
  ///
  /// Private method of the login screen state class
  Future<void> _handleLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() => isLoading = true); // Set placeholders
    final response = await BackendAPI.loginUser(
      username: username,
      password: password,
    );
    if (!mounted) return; // Safety check
    setState(() => isLoading = false); // Replace placeholders with real data

    if (response['success'] == true) {
      context.go('/dashboard');
    } else {
      final errorMsg = response['error'] ?? 'Login failed';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMsg)));
    }
  }

  // Build method
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _usernameController,
          decoration: const InputDecoration(labelText: 'Username'),
        ),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(labelText: 'Password'),
          obscureText: true,
          obscuringCharacter: '*',
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: isLoading ? null : _handleLogin,
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('Login'),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () => context.go('/register'),
          child: const Text('Go to Register'),
        ),
      ],
    );
  }
}
