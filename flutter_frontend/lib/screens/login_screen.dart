import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/api.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String cobolResult = 'Loading...';
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCobolTest();
  }

  void _loadCobolTest() async {
    try {
      final result = await ApiService.fetchCobolTest();
      setState(() {
        cobolResult = result?.toString() ?? 'No data';
      });
    } catch (e) {
      setState(() {
        cobolResult = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              child: const Text('Login'),
              onPressed: () async {
                final username = usernameController.text.trim();
                final password = passwordController.text;

                if (username.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }

                final response = await ApiService.loginUser(
                  username: username,
                  password: password,
                );

                if (response['success'] == true) {
                  // Navigate to home screen on successful login
                  context.go('/dashboard');
                } else {
                  final errorMsg = response['error'] ?? 'Login failed';
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(errorMsg)));
                }
              },
            ),
            ElevatedButton(
              child: const Text('Go to Register'),
              onPressed: () {
                context.go('/register');
              },
            ),
            Text('COBOL Result: $cobolResult'),
          ],
        ),
      ),
    );
  }
}
