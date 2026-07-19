import 'package:five_jars_ultra/shared/palette.dart';
import 'package:flutter/material.dart';
import 'package:five_jars_ultra/core/config/injection_container.dart';

class NotificationService {
  void showSuccess(String message) {
    _show(message, Palette.success, Icons.check_circle);
  }

  void showError(String message) {
    _show(message, Palette.error, Icons.error_outline);
  }

  void showWarning(String message) {
    _show(message, Palette.warning, Icons.warning_amber_rounded);
  }

  void _show(String message, Color color, IconData icon) {
    snackbarKey.currentState?.showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Palette.darkOnPrimary, size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Palette.darkOnPrimary),
              ),
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 40),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
