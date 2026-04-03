import 'package:flutter/material.dart';

// ── String extensions ─────────────────────────────────────────────────────────
extension StringExt on String {
  // "ali valiyev" → "Ali Valiyev"
  String get toTitleCase {
    return split(' ')
        .map((w) => w.isNotEmpty
        ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}'
        : '')
        .join(' ');
  }

  // Telefon raqamni formatlash: "998901234567" → "+998 90 123 45 67"
  String get formatPhone {
    final clean = replaceAll(RegExp(r'\D'), '');
    if (clean.length == 12) {
      return '+${clean.substring(0, 3)} '
          '${clean.substring(3, 5)} '
          '${clean.substring(5, 8)} '
          '${clean.substring(8, 10)} '
          '${clean.substring(10, 12)}';
    }
    return this;
  }

  // Bo'sh yoki null tekshirish
  bool get isNullOrEmpty => trim().isEmpty;

  // Matnni qisqartirish
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }
}

// ── Nullable String ───────────────────────────────────────────────────────────
extension NullableStringExt on String? {
  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;
  String get orEmpty     => this ?? '';
}

// ── BuildContext extensions ───────────────────────────────────────────────────
extension ContextExt on BuildContext {
  // Screen o'lchamlari
  double get screenWidth  => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  // Tema
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;

  // Keyboard yopish
  void hideKeyboard() => FocusScope.of(this).unfocus();

  // SnackBar
  void showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// ── int / double extensions ───────────────────────────────────────────────────
extension NumExt on num {
  // 75.333 → "75%"
  String get toPercent => '${toStringAsFixed(0)}%';

  // 3600 → "01:00:00"
  String get toTimeString {
    final h = (this ~/ 3600).toString().padLeft(2, '0');
    final m = ((this % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (this % 60).toStringAsFixed(0).padLeft(2, '0');
    return '$h:$m:$s';
  }
}

// ── DateTime extensions ───────────────────────────────────────────────────────
extension DateTimeExt on DateTime {
  // "2024-01-15T10:30:00" → "15.01.2024"
  String get formatted =>
      '${day.toString().padLeft(2, '0')}.'
          '${month.toString().padLeft(2, '0')}.'
          '$year';
}

// ── List extensions ───────────────────────────────────────────────────────────
extension ListExt<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
  T? get lastOrNull  => isEmpty ? null : last;
}