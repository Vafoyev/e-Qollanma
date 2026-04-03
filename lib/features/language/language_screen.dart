import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';

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
    final currentCode =
        ref.watch(localeProvider).languageCode;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(56),

              // ── Sarlavha ───────────────────────────────────────────────
              Text(
                'Tilni tanlang',
                style: AppTextStyles.h1.copyWith(
                  color: isDark
                      ? AppColors.darkText
                      : AppColors.lightText,
                ),
              ),

              const Gap(8),

              Text(
                'Select your preferred language',
                style: AppTextStyles.body.copyWith(
                  color: isDark
                      ? AppColors.darkTextSub
                      : AppColors.lightTextSub,
                ),
              ),

              const Gap(48),

              // ── Til kartalari ──────────────────────────────────────────
              ...List.generate(_languages.length, (i) {
                final lang    = _languages[i];
                final code    = lang['code']!;
                final isSelected = code == currentCode;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _LanguageTile(
                    flag:       lang['flag']!,
                    label:      lang['label']!,
                    sub:        lang['sub']!,
                    isSelected: isSelected,
                    isDark:     isDark,
                    onTap: () async {
                      await ref
                          .read(localeProvider.notifier)
                          .setLocale(context, code);
                    },
                  ),
                );
              }),

              const Spacer(),

              // ── Davom etish tugmasi ───────────────────────────────────
              ElevatedButton(
                onPressed: () async {
                  await PrefsStorage.saveLocale(currentCode);
                  if (context.mounted) context.go(AppRoutes.intro);
                },
                child: Text('btn_next'.tr()),
              ),

              const Gap(32),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String flag;
  final String label;
  final String sub;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.flag,
    required this.label,
    required this.sub,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryLight
              : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Flag
            Text(flag, style: const TextStyle(fontSize: 32)),

            const Gap(16),

            // Label
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.h4.copyWith(
                      color: isSelected
                          ? AppColors.primaryDark
                          : (isDark
                          ? AppColors.darkText
                          : AppColors.lightText),
                    ),
                  ),
                  const Gap(2),
                  Text(
                    sub,
                    style: AppTextStyles.small.copyWith(
                      color: isSelected
                          ? AppColors.primary
                          : (isDark
                          ? AppColors.darkTextSub
                          : AppColors.lightTextSub),
                    ),
                  ),
                ],
              ),
            ),

            // Check icon
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isSelected ? 1 : 0,
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}