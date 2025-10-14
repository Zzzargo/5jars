import 'package:flutter/material.dart';
import '../app_screen.dart';
import 'login_mobile.dart';
import 'login_desktop.dart';

class LoginScreen extends AppScreen {
  const LoginScreen({super.key});

  @override
  Widget buildMobile(BuildContext context) => const LoginMobile();

  @override
  Widget buildDesktop(BuildContext context) => const LoginDesktop();

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends AppScreenState<LoginScreen> {}
