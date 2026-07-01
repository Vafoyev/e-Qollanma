import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/router/app_router.dart';
import '../../core/storage/prefs_storage.dart';
import '../../providers/locale_provider.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  static const _languages = [
    {'code': 'uz', 'label': "O'zbek", 'flag': '🇺🇿', 'sub': 'O\'zbek tili'},
    {'code': 'ru', 'label': 'Русский', 'flag': '🇷🇺', 'sub': 'Русский язык'},
    {'code': 'en', 'label': 'English', 'flag': '🇬🇧', 'sub': 'English language'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentCode = ref.watch(localeProvider).languageCode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: Column(
          children: [
            const Gap(60),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Iconsax.language_square, color: AppColors.primary),
                  ),
                  const Gap(24),
                  Text(
                    'Tilni tanlang',
                    style: AppTextStyles.h1.copyWith(fontSize: 32),
                  ),
                  const Gap(8),
                  Text(
                    'Dasturdan foydalanish uchun qulay tilni tanlang',
                    style: AppTextStyles.body.copyWith(color: isDark ? Colors.white54 : Colors.black54),
                  ),
                ],
              ),
            ),
            const Gap(48),
            // List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _languages.length,
                itemBuilder: (context, i) {
                  final lang = _languages[i];
                  final code = lang['code']!;
                  final isSelected = code == currentCode;

                  return GestureDetector(
                    onTap: () => ref.read(localeProvider.notifier).setLocale(context, code),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isSelected 
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : (isDark ? AppColors.darkSurface : Colors.white),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          width: 2,
                        ),
                        boxShadow: isSelected ? [
                          BoxShadow(color: AppColors.primary.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))
                        ] : [],
                      ),
                      child: Row(
                        children: [
                          Text(lang['flag']!, style: const TextStyle(fontSize: 32)),
                          const Gap(20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lang['label']!,
                                  style: AppTextStyles.h4.copyWith(
                                    color: isSelected ? AppColors.primary : (isDark ? Colors.white : Colors.black),
                                  ),
                                ),
                                Text(
                                  lang['sub']!,
                                  style: AppTextStyles.small,
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 28),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: () async {
                  await PrefsStorage.saveLocale(currentCode);
                  if (context.mounted) context.go(AppRoutes.intro);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Davom etish"),
                    Gap(10),
                    Icon(Icons.arrow_forward_rounded),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
