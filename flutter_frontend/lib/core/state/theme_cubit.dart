import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef ThemeState = ThemeMode;

// ── Cubit ────────────────────────────────────
class ThemeCubit extends Cubit<ThemeState> {
  static const _key = 'theme_mode';

  final SharedPreferences _prefs;

  ThemeCubit(this._prefs) : super(_load(_prefs));

  // Called once on startup to read the persisted value
  static ThemeMode _load(SharedPreferences prefs) {
    final saved = prefs.getString(_key);
    return switch (saved) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system, // null or unknown → follow system
    };
  }

  void setLight() => _set(ThemeMode.light);
  void setDark() => _set(ThemeMode.dark);
  void setSystem() => _set(ThemeMode.system);

  void toggle(BuildContext context) {
    // If currently system, resolve the actual brightness first
    final current = state == ThemeMode.system
        ? MediaQuery.platformBrightnessOf(context) == Brightness.dark
              ? ThemeMode.dark
              : ThemeMode.light
        : state;

    _set(current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }

  void _set(ThemeMode mode) {
    // Notify listeners
    emit(mode);
    // Save the choice
    _prefs.setString(_key, switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    });
  }
}
