import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/router/app_router.dart';

class AuthorsScreen extends StatelessWidget {
  const AuthorsScreen({super.key});

  static const _authors = [
    _Author(
      name:    'Abdullayev Ravshan',
      role:    'Chizmachilik muallifi',
      desc:    '20 yillik tajribaga ega o\'qituvchi. 5 ta darslik muallifi.',
      initials: 'AR',
    ),
    _Author(
      name:    'Karimova Nilufar',
      role:    'Texnik chizmachilik',
      desc:    'Texnik universitetining katta o\'qituvchisi.',
      initials: 'KN',
    ),
    _Author(
      name:    'Toshmatov Bobur',
      role:    'Muhandislik grafika',
      desc:    'Muhandislik chizmachilik bo\'yicha metodist.',
      initials: 'TB',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: Text('intro_title_2'.tr()),
        backgroundColor:
        isDark ? AppColors.darkSurface : AppColors.lightSurface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.go(AppRoutes.intro),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _authors.length,
              itemBuilder: (_, i) => _AuthorCard(
                author: _authors[i],
                isDark: isDark,
              ),
            ),
          ),

          // ── Dasturga kirish tugmasi ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            child: ElevatedButton(
              onPressed: () => context.go(AppRoutes.login),
              child: Text('intro_title_3'.tr()),
            ),
          ),
        ],
      ),
    );
  }
}

class _Author {
  final String name;
  final String role;
  final String desc;
  final String initials;
  const _Author({
    required this.name,
    required this.role,
    required this.desc,
    required this.initials,
  });
}

class _AuthorCard extends StatelessWidget {
  final _Author author;
  final bool isDark;
  const _AuthorCard({required this.author, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                author.initials,
                style: AppTextStyles.h4.copyWith(
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ),

          const Gap(14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  author.name,
                  style: AppTextStyles.h4.copyWith(
                    color: isDark
                        ? AppColors.darkText
                        : AppColors.lightText,
                  ),
                ),
                const Gap(2),
                Text(
                  author.role,
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(6),
                Text(
                  author.desc,
                  style: AppTextStyles.small.copyWith(
                    color: isDark
                        ? AppColors.darkTextSub
                        : AppColors.lightTextSub,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}