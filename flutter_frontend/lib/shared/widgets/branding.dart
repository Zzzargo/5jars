import 'package:flutter/material.dart';

class Branding extends StatelessWidget {
  const Branding({super.key});

  // TODO: Separate background

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.purpleAccent.shade700, Colors.pink.shade600],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Column(
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
          ),
        ),
      ),
    );
  }
}
