import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/router/app_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/locale_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark     = Theme.of(context).brightness == Brightness.dark;
    final authState  = ref.watch(authProvider);
    final themeMode  = ref.watch(themeModeProvider);
    final user       = authState.user;

    return Scaffold(
      backgroundColor:
      isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: Text('profile_title'.tr()),
        backgroundColor:
        isDark ? AppColors.darkSurface : AppColors.lightSurface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ── Avatar + ism ───────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurface
                    : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark
                      ? AppColors.darkBorder
                      : AppColors.lightBorder,
                ),
              ),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        user?.fullName.isNotEmpty == true
                            ? user!.fullName[0].toUpperCase()
                            : 'U',
                        style: AppTextStyles.h1.copyWith(
                          color: AppColors.primaryDark,
                          fontSize: 34,
                        ),
                      ),
                    ),
                  ),

                  const Gap(16),

                  Text(
                    user?.fullName ?? '—',
                    style: AppTextStyles.h3.copyWith(
                      color: isDark
                          ? AppColors.darkText
                          : AppColors.lightText,
                    ),
                  ),

                  const Gap(4),

                  Text(
                    user?.phone != null
                        ? '+${user!.phone}'
                        : '—',
                    style: AppTextStyles.body.copyWith(
                      color: isDark
                          ? AppColors.darkTextSub
                          : AppColors.lightTextSub,
                    ),
                  ),
                ],
              ),
            ),

            const Gap(20),

            // ── Sozlamalar ─────────────────────────────────────────────────
            _SectionTitle(
                label: 'Sozlamalar', isDark: isDark),

            const Gap(12),

            // Dark mode toggle
            _SettingsTile(
              icon:   Iconsax.moon,
              label:  'profile_theme'.tr(),
              isDark: isDark,
              trailing: Switch(
                value: themeMode == ThemeMode.dark,
                activeThumbColor: AppColors.primary,
                onChanged: (_) =>
                    ref.read(themeModeProvider.notifier).toggle(),
              ),
            ),

            const Gap(10),

            // Til tanlash
            _SettingsTile(
              icon:   Iconsax.language_square,
              label:  'profile_language'.tr(),
              isDark: isDark,
              trailing: _LangDropdown(isDark: isDark),
            ),

            const Gap(20),

            // ── Mening natijalarim ─────────────────────────────────────────
            _SectionTitle(
                label: 'profile_my_results'.tr(), isDark: isDark),

            const Gap(12),

            _SettingsTile(
              icon:   Iconsax.task_square,
              label:  'profile_my_results'.tr(),
              isDark: isDark,
              trailing: Icon(
                Iconsax.arrow_right_3,
                color: isDark
                    ? AppColors.darkIcon
                    : AppColors.lightIcon,
                size: 18,
              ),
              onTap: () {
                // TODO: my results sahifasiga o'tish
              },
            ),

            const Gap(20),

            // ── Chiqish ────────────────────────────────────────────────────
            _SectionTitle(
                label: 'profile_logout'.tr(), isDark: isDark),

            const Gap(12),

            _SettingsTile(
              icon:   Iconsax.logout,
              label:  'profile_logout'.tr(),
              isDark: isDark,
              iconColor: AppColors.error,
              labelColor: AppColors.error,
              trailing: const SizedBox.shrink(),
              onTap: () => _confirmLogout(context, ref),
            ),

            const Gap(32),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('profile_logout'.tr()),
        content: Text('profile_logout_confirm'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('btn_cancel'.tr()),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go(AppRoutes.login);
            },
            child: Text(
              'profile_logout'.tr(),
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section sarlavha ──────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String label;
  final bool isDark;
  const _SectionTitle({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: AppTextStyles.label.copyWith(
          color: isDark ? AppColors.darkTextSub : AppColors.lightTextSub,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── Sozlamalar qatori ─────────────────────────────────────────────────────────
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final Widget trailing;
  final Color? iconColor;
  final Color? labelColor;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.isDark,
    required this.trailing,
    this.iconColor,
    this.labelColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkSurface
              : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark
                ? AppColors.darkBorder
                : AppColors.lightBorder,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor ??
                  (isDark
                      ? AppColors.darkIcon
                      : AppColors.lightIcon),
              size: 22,
            ),
            const Gap(14),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body.copyWith(
                  color: labelColor ??
                      (isDark
                          ? AppColors.darkText
                          : AppColors.lightText),
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

// ── Til dropdown ──────────────────────────────────────────────────────────────
class _LangDropdown extends ConsumerWidget {
  final bool isDark;
  const _LangDropdown({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentCode =
        ref.watch(localeProvider).languageCode;

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: currentCode,
        isDense: true,
        dropdownColor: isDark
            ? AppColors.darkSurface2
            : AppColors.lightSurface,
        style: AppTextStyles.body.copyWith(
          color:
          isDark ? AppColors.darkText : AppColors.lightText,
        ),
        items: const [
          DropdownMenuItem(value: 'uz', child: Text("O'zbek")),
          DropdownMenuItem(value: 'ru', child: Text('Русский')),
          DropdownMenuItem(value: 'en', child: Text('English')),
        ],
        onChanged: (code) {
          if (code != null) {
            ref
                .read(localeProvider.notifier)
                .setLocale(context, code);
          }
        },
      ),
    );
  }
}