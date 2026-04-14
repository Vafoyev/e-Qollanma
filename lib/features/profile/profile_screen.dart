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
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: Text('profile_title'.tr(), style: AppTextStyles.h3),
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ── Premium Profile Header ─────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: isDark ? AppColors.darkBgGradient : null,
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))
                          ],
                        ),
                        child: Center(
                          child: Text(
                            user?.fullName.isNotEmpty == true ? user!.fullName[0].toUpperCase() : 'U',
                            style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                          child: const Icon(Iconsax.edit_2, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                  const Gap(20),
                  Text(
                    user?.fullName ?? 'Mehmon foydalanuvchi',
                    style: AppTextStyles.h2.copyWith(fontSize: 22, color: isDark ? AppColors.darkText : AppColors.lightText),
                  ),
                  const Gap(4),
                  Text(
                    user?.phone != null ? '+${user!.phone}' : 'Tizimga kirmagan',
                    style: AppTextStyles.body.copyWith(color: AppColors.lightIcon),
                  ),
                ],
              ),
            ),

            const Gap(32),

            // ── Settings Groups ────────────────────────────────────────────
            _buildGroupTitle('Sozlamalar', isDark),
            const Gap(12),
            _SettingsGroup(
              isDark: isDark,
              children: [
                _SettingsTile(
                  icon: Iconsax.moon,
                  label: 'profile_theme'.tr(),
                  isDark: isDark,
                  trailing: Switch.adaptive(
                    value: themeMode == ThemeMode.dark,
                    activeColor: AppColors.primary,
                    onChanged: (_) => ref.read(themeModeProvider.notifier).toggle(),
                  ),
                ),
                _SettingsTile(
                  icon: Iconsax.language_square,
                  label: 'profile_language'.tr(),
                  isDark: isDark,
                  trailing: _LangDropdown(isDark: isDark),
                ),
              ],
            ),

            const Gap(24),
            _buildGroupTitle('Mening natijalarim', isDark),
            const Gap(12),
            _SettingsGroup(
              isDark: isDark,
              children: [
                _SettingsTile(
                  icon: Iconsax.task_square,
                  label: 'Test natijalari',
                  isDark: isDark,
                  onTap: () {},
                  trailing: const Icon(Iconsax.arrow_right_3, size: 18, color: AppColors.lightIcon),
                ),
                _SettingsTile(
                  icon: Iconsax.folder_2,
                  label: 'Yuklangan fayllar',
                  isDark: isDark,
                  onTap: () {},
                  trailing: const Icon(Iconsax.arrow_right_3, size: 18, color: AppColors.lightIcon),
                ),
              ],
            ),

            const Gap(24),
            _buildGroupTitle('Boshqa', isDark),
            const Gap(12),
            _SettingsGroup(
              isDark: isDark,
              children: [
                _SettingsTile(
                  icon: Iconsax.info_circle,
                  label: 'Ilova haqida',
                  isDark: isDark,
                  onTap: () => context.push(AppRoutes.about),
                ),
                _SettingsTile(
                  icon: Iconsax.logout,
                  label: 'profile_logout'.tr(),
                  isDark: isDark,
                  labelColor: AppColors.error,
                  iconColor: AppColors.error,
                  onTap: () => _confirmLogout(context, ref),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupTitle(String title, bool isDark) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Text(
          title,
          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('profile_logout'.tr()),
        content: Text('profile_logout_confirm'.tr()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('btn_cancel'.tr())),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go(AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, minimumSize: const Size(100, 40)),
            child: Text('profile_logout'.tr()),
          ),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;
  final bool isDark;
  const _SettingsGroup({required this.children, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final Widget? trailing;
  final Color? iconColor;
  final Color? labelColor;
  final VoidCallback? onTap;

  const _SettingsTile({required this.icon, required this.label, required this.isDark, this.trailing, this.iconColor, this.labelColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor ?? AppColors.primary, size: 20),
            ),
            const Gap(16),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(color: labelColor ?? (isDark ? AppColors.darkText : AppColors.lightText)),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class _LangDropdown extends ConsumerWidget {
  final bool isDark;
  const _LangDropdown({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentCode = ref.watch(localeProvider).languageCode;
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: currentCode,
        isDense: true,
        dropdownColor: isDark ? AppColors.darkSurface2 : Colors.white,
        style: AppTextStyles.body.copyWith(color: isDark ? AppColors.darkText : AppColors.lightText),
        items: const [
          DropdownMenuItem(value: 'uz', child: Text("O'zbek")),
          DropdownMenuItem(value: 'ru', child: Text('Русский')),
          DropdownMenuItem(value: 'en', child: Text('English')),
        ],
        onChanged: (code) {
          if (code != null) ref.read(localeProvider.notifier).setLocale(context, code);
        },
      ),
    );
  }
}
