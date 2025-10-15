import 'package:flutter/material.dart';
import 'app_screen.dart';
import '../services/api.dart';
import 'package:go_router/go_router.dart';
import 'widgets.dart';

class RegisterScreen extends AppScreen {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends AppScreenState<RegisterScreen> {
  // Text controllers for the input fields
  @protected
  final nicknameController = TextEditingController();
  @protected
  final usernameController = TextEditingController();
  @protected
  final passwordController = TextEditingController();

  // Dispose of the controllers when the widget is removed from the widget tree
  @override
  void dispose() {
    nicknameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// Async function to send a register request and update the state accordingly
  Future<void> handleRegister() async {
    final nickname = nicknameController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text;
    if (nickname.isEmpty || username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() => isLoading = true); // Set placeholders and prevent bugs
    final response = await BackendAPI.registerUser(
      username: username,
      nickname: nickname,
      password: password,
    );
    if (!mounted) return; // Safety check
    setState(() => isLoading = false); // Replace placeholders with real data

    if (response['success'] == true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Registration successful!')));
      context.go('/login');
    } else {
      final errorMsg = response['error'] ?? 'Registration failed';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMsg)));
    }
  }

  /// Build method for the mobile register screen
  @override
  Widget buildMobile(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: CommonWidgets.registerForm(
            context: context,
            nicknameController: nicknameController,
            usernameController: usernameController,
            passwordController: passwordController,
            isLoading: isLoading,
            handleRegister: handleRegister,
          ),
        ),
      ),
    );
  }

  /// Build method for the desktop register screen
  @override
  Widget buildDesktop(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              color: Colors.pink,
              child: const Center(
                child: Text(
                  '5 Jars Animation',
                  style: TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Center(
              child: FractionallySizedBox(
                widthFactor: 0.8,
                heightFactor: 0.5,
                child: CommonWidgets.registerForm(
                  context: context,
                  nicknameController: nicknameController,
                  usernameController: usernameController,
                  passwordController: passwordController,
                  isLoading: isLoading,
                  handleRegister: handleRegister,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
