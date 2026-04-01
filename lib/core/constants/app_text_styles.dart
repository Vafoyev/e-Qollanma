import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ── Light mode text styles ─────────────────────────────────────────────────

  static const TextStyle h1 = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.lightText,
    height: 1.3,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.lightText,
    height: 1.3,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.lightText,
    height: 1.4,
  );

  static const TextStyle h4 = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.lightText,
    height: 1.4,
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.lightText,
    height: 1.6,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.lightText,
    height: 1.6,
  );

  static const TextStyle small = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.lightTextSub,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.lightTextSub,
    letterSpacing: 0.4,
  );

  static const TextStyle button = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 1,
  );

  static const TextStyle label = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.lightTextSub,
    height: 1.4,
  );

  // ── Dark mode variants ─────────────────────────────────────────────────────

  static TextStyle get h1Dark       => h1.copyWith(color: AppColors.darkText);
  static TextStyle get h2Dark       => h2.copyWith(color: AppColors.darkText);
  static TextStyle get h3Dark       => h3.copyWith(color: AppColors.darkText);
  static TextStyle get h4Dark       => h4.copyWith(color: AppColors.darkText);
  static TextStyle get bodyDark     => body.copyWith(color: AppColors.darkText);
  static TextStyle get smallDark    => small.copyWith(color: AppColors.darkTextSub);
  static TextStyle get labelDark    => label.copyWith(color: AppColors.darkTextSub);
}