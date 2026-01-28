import 'package:flutter/material.dart';
import 'app_screen.dart';
import '../services/api.dart';
import 'package:go_router/go_router.dart';
import 'widgets.dart';

class LoginScreen extends AppScreen {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends AppScreenState<LoginScreen> {
  // Text controllers for the input fields
  @protected
  final usernameController = TextEditingController();
  @protected
  final passwordController = TextEditingController();

  // Dispose of the controllers when the widget is removed from the widget tree
  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// Async function to send a login request and update the state accordingly
  Future<void> handleLogin() async {
    final username = usernameController.text.trim();
    final password = passwordController.text;
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

  /// Build method for the mobile login screen
  @override
  Widget buildMobile(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isLoading ? null : handleLogin,
                child: isLoading
                    ? CircularProgressIndicator()
                    : const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build method for the desktop login screen
  @override
  Widget buildDesktop(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(color: Colors.blueGrey[50])),
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 450),
              child: Card(
                margin: const EdgeInsets.all(32),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: buildMobile(context), // Reuse same form
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
