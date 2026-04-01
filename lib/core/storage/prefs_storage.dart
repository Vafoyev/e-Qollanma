import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsStorage {
  PrefsStorage._();

  static late SharedPreferences _prefs;

  static const String _themeKey  = 'theme_mode';
  static const String _localeKey = 'locale';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ── Theme ─────────────────────────────────────────────────────────────────

  static Future<void> saveThemeMode(ThemeMode mode) async {
    await _prefs.setString(_themeKey, mode.name);
  }

  static ThemeMode getSavedThemeMode() {
    final value = _prefs.getString(_themeKey);
    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  // ── Locale ────────────────────────────────────────────────────────────────

  static Future<void> saveLocale(String langCode) async {
    await _prefs.setString(_localeKey, langCode);
  }

  static Locale? getSavedLocale() {
    final code = _prefs.getString(_localeKey);
    if (code == null) return null;
    return Locale(code);
  }

  // ── Onboarding ────────────────────────────────────────────────────────────

  static const String _onboardKey = 'onboard_done';

  static Future<void> setOnboardDone() async {
    await _prefs.setBool(_onboardKey, true);
  }

  static bool isOnboardDone() {
    return _prefs.getBool(_onboardKey) ?? false;
  }
}