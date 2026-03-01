import 'package:flutter/material.dart';

class Branding extends StatelessWidget {
  const Branding({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.account_balance_wallet_outlined,
          size: 120,
          color: Colors.white,
        ),
        const SizedBox(height: 28),
        const Text(
          '5 Jars',
          style: TextStyle(
            fontSize: 56,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Smart Money Management',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white.withAlpha(220),
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
