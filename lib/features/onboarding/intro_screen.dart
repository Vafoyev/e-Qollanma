import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/router/app_router.dart';
import '../../core/storage/prefs_storage.dart';

class IntroScreen extends ConsumerStatefulWidget {
  const IntroScreen({super.key});

  @override
  ConsumerState<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends ConsumerState<IntroScreen> {
  final PageController _pageCtrl = PageController();
  int _currentPage = 0;

  static const _pages = [
    _IntroPage(
      lottie:   'assets/animations/splash_drawing.json',
      titleKey: 'intro_title_1',
      descKey:  'intro_desc_1',
    ),
    _IntroPage(
      lottie:   'assets/animations/splash_drawing.json',
      titleKey: 'intro_title_2',
      descKey:  'intro_desc_2',
    ),
    _IntroPage(
      lottie:   'assets/animations/splash_drawing.json',
      titleKey: 'intro_title_3',
      descKey:  'intro_desc_3',
    ),
  ];

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _finish() async {
    await PrefsStorage.setOnboardDone();
    if (mounted) context.go(AppRoutes.login);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLast = _currentPage == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Skip ──────────────────────────────────────────────────────
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 16, right: 24),
                child: TextButton(
                  onPressed: _finish,
                  child: Text(
                    'O\'tkazib yuborish',
                    style: AppTextStyles.body.copyWith(
                      color: isDark
                          ? AppColors.darkTextSub
                          : AppColors.lightTextSub,
                    ),
                  ),
                ),
              ),
            ),

            // ── PageView ──────────────────────────────────────────────────
            Expanded(
              child: PageView.builder(
                controller: _pageCtrl,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (context, i) =>
                    _IntroPageView(page: _pages[i], isDark: isDark),
              ),
            ),

            // ── Dots ──────────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (i) {
                final active = i == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width:  active ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active
                        ? AppColors.primary
                        : (isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),

            const Gap(32),

            // ── Tugmalar ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // O'quv dasturlari
                  OutlinedButton(
                    onPressed: () => context.go(AppRoutes.curriculum),
                    child: Text('intro_title_1'.tr()),
                  ),

                  const Gap(12),

                  // Mualliflar
                  OutlinedButton(
                    onPressed: () => context.go(AppRoutes.authors),
                    child: Text('intro_title_2'.tr()),
                  ),

                  const Gap(12),

                  // Dasturga kirish — yashil
                  ElevatedButton(
                    onPressed: _finish,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: Text('intro_title_3'.tr()),
                  ),
                ],
              ),
            ),

            const Gap(32),
          ],
        ),
      ),
    );
  }
}

// ── Intro page model ──────────────────────────────────────────────────────────
class _IntroPage {
  final String lottie;
  final String titleKey;
  final String descKey;

  const _IntroPage({
    required this.lottie,
    required this.titleKey,
    required this.descKey,
  });
}

// ── Bitta slide ko'rinishi ────────────────────────────────────────────────────
class _IntroPageView extends StatelessWidget {
  final _IntroPage page;
  final bool isDark;

  const _IntroPageView({required this.page, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            page.lottie,
            width: 260,
            height: 260,
            fit: BoxFit.contain,
          ),

          const Gap(32),

          Text(
            page.titleKey.tr(),
            style: AppTextStyles.h2.copyWith(
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
            textAlign: TextAlign.center,
          ),

          const Gap(16),

          Text(
            page.descKey.tr(),
            style: AppTextStyles.body.copyWith(
              color: isDark
                  ? AppColors.darkTextSub
                  : AppColors.lightTextSub,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}