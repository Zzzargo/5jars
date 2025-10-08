import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../api.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String cobolResult = 'Loading...';

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
            ElevatedButton(
              child: const Text('Go to Register'),
              onPressed: () {
                context.go('/register');
              },
            ),
            ElevatedButton(
              child: const Text('Go to Dashboard'),
              onPressed: () {
                context.go('/dashboard');
              },
            ),
            Text('COBOL Result: $cobolResult'),
          ],
        ),
      ),
    );
  }
}
