import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand ────────────────────────────────────────────────────────────────
  static const Color primary       = Color(0xFF2ECC71);   // Yashil (asosiy)
  static const Color primaryDark   = Color(0xFF27AE60);   // Yashil to'q
  static const Color primaryLight  = Color(0xFFD5F5E3);   // Yashil och

  static const Color accent        = Color(0xFF1ABC9C);   // Teal accent
  static const Color accentLight   = Color(0xFFD1F2EB);

  // ── Neutral ───────────────────────────────────────────────────────────────
  static const Color white         = Color(0xFFFFFFFF);
  static const Color black         = Color(0xFF000000);

  // ── Light mode ────────────────────────────────────────────────────────────
  static const Color lightBg           = Color(0xFFF4F6F9);
  static const Color lightSurface      = Color(0xFFFFFFFF);
  static const Color lightSurface2     = Color(0xFFEFF2F6);
  static const Color lightText         = Color(0xFF1A1D23);
  static const Color lightTextSub      = Color(0xFF6B7280);
  static const Color lightBorder       = Color(0xFFE2E8F0);
  static const Color lightIcon         = Color(0xFF9CA3AF);

  // ── Dark mode ─────────────────────────────────────────────────────────────
  static const Color darkBg            = Color(0xFF0F1117);
  static const Color darkSurface       = Color(0xFF1A1D27);
  static const Color darkSurface2      = Color(0xFF252836);
  static const Color darkText          = Color(0xFFF1F5F9);
  static const Color darkTextSub       = Color(0xFF94A3B8);
  static const Color darkBorder        = Color(0xFF2D3148);
  static const Color darkIcon          = Color(0xFF64748B);

  // ── Semantic ──────────────────────────────────────────────────────────────
  static const Color error             = Color(0xFFE74C3C);
  static const Color errorLight        = Color(0xFFFDECEB);
  static const Color warning           = Color(0xFFF39C12);
  static const Color warningLight      = Color(0xFFFEF9E7);
  static const Color success           = Color(0xFF27AE60);
  static const Color successLight      = Color(0xFFEAFAF1);
  static const Color info              = Color(0xFF2980B9);
  static const Color infoLight         = Color(0xFFEBF5FB);

  // ── Quiz ──────────────────────────────────────────────────────────────────
  static const Color quizCorrect       = Color(0xFF2ECC71);
  static const Color quizWrong        = Color(0xFFE74C3C);
  static const Color quizOption        = Color(0xFF3B4263);

  // ── Gradient ──────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2ECC71), Color(0xFF1ABC9C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkBgGradient = LinearGradient(
    colors: [Color(0xFF0F1117), Color(0xFF1A1D27)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}