import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../videos/videos_screen.dart';
import '../library/library_screen.dart';
import '../quiz/quiz_list_screen.dart';
import '../profile/profile_screen.dart';

// Aktiv tab index provider
final navIndexProvider = StateProvider<int>((ref) => 0);

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  static const _screens = [
    VideosScreen(),
    LibraryScreen(),
    QuizListScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark      = Theme.of(context).brightness == Brightness.dark;
    final currentIndex = ref.watch(navIndexProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon:      Iconsax.video_play,
                  iconActive: Iconsax.video_play5,
                  label:     'nav_videos'.tr(),
                  index:     0,
                  current:   currentIndex,
                  isDark:    isDark,
                  onTap: () =>
                  ref.read(navIndexProvider.notifier).state = 0,
                ),
                _NavItem(
                  icon:      Iconsax.book,
                  iconActive: Iconsax.book5,
                  label:     'nav_library'.tr(),
                  index:     1,
                  current:   currentIndex,
                  isDark:    isDark,
                  onTap: () =>
                  ref.read(navIndexProvider.notifier).state = 1,
                ),
                _NavItem(
                  icon:      Iconsax.task_square,
                  iconActive: Iconsax.task_square5,
                  label:     'nav_quiz'.tr(),
                  index:     2,
                  current:   currentIndex,
                  isDark:    isDark,
                  onTap: () =>
                  ref.read(navIndexProvider.notifier).state = 2,
                ),
                _NavItem(
                  icon:      Iconsax.user,
                  iconActive: Iconsax.user5,
                  label:     'nav_profile'.tr(),
                  index:     3,
                  current:   currentIndex,
                  isDark:    isDark,
                  onTap: () =>
                  ref.read(navIndexProvider.notifier).state = 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData iconActive;
  final String label;
  final int index;
  final int current;
  final bool isDark;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.iconActive,
    required this.label,
    required this.index,
    required this.current,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == current;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primaryLight
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? iconActive : icon,
              color: isActive
                  ? AppColors.primary
                  : (isDark ? AppColors.darkIcon : AppColors.lightIcon),
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: isActive
                    ? AppColors.primary
                    : (isDark ? AppColors.darkIcon : AppColors.lightIcon),
                fontWeight:
                isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}