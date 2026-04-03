import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/router/app_router.dart';
import '../../core/storage/prefs_storage.dart';
import '../../core/storage/secure_storage.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateAfterDelay();
    });
  }

  Future<void> _navigateAfterDelay() async {
    try {
      // Wait for splash screen
      await Future.delayed(const Duration(milliseconds: 3000));
      
      if (!mounted) return;

      // Navigate to language screen (first time user)
      // This is the safest default - users can proceed from there
      if (mounted) {
        context.go(AppRoutes.language);
      }
    } catch (e) {
      print('Splash navigation error: $e');
      if (mounted) {
        context.go(AppRoutes.language);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),

            // ── Lottie animation (with fallback) ────────────────────────────
            SizedBox(
              width: 280,
              height: 280,
              child: Lottie.asset(
                'assets/animations/splash_drawing.json',
                controller: _controller,
                fit: BoxFit.contain,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..forward();
                },
                errorBuilder: (context, error, stackTrace) {
                  // Fallback if animation file is missing
                  return Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.draw_rounded,
                      size: 60,
                      color: AppColors.primary,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // ── App nomi ──────────────────────────────────────────────────
            Text(
              'E-Qo\'llanma',
              style: AppTextStyles.h1.copyWith(
                color: AppColors.primary,
                fontSize: 32,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Chizmachilik o\'quv platformasi',
              style: AppTextStyles.body.copyWith(
                color: isDark
                    ? AppColors.darkTextSub
                    : AppColors.lightTextSub,
              ),
            ),

            const Spacer(),

            // ── Loading indicator ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(bottom: 48),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.primary.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}