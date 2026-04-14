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
import '../../providers/video_provider.dart';
import 'main_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(authProvider).user;
    final videosAsync = ref.watch(videoListProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Header Section ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 32),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            user?.fullName[0].toUpperCase() ?? 'U',
                            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const Gap(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'welcome'.tr(),
                              style: AppTextStyles.caption.copyWith(letterSpacing: 1),
                            ),
                            Text(
                              user?.fullName ?? 'Foydalanuvchi',
                              style: AppTextStyles.h2.copyWith(
                                fontSize: 20,
                                color: isDark ? AppColors.darkText : AppColors.lightText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _HeaderButton(
                        icon: Iconsax.notification,
                        isDark: isDark,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const Gap(28),
                  // Premium Search Bar
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      height: 56,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface2 : AppColors.lightSurface2,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(Iconsax.search_normal, color: AppColors.primary, size: 22),
                          const Gap(16),
                          Text(
                            'search'.tr(),
                            style: AppTextStyles.body.copyWith(color: AppColors.lightIcon),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Quick Actions ───────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tezkor buyruqlar', style: AppTextStyles.h3.copyWith(fontSize: 18)),
                  const Gap(20),
                  Row(
                    children: [
                      _QuickActionCard(
                        label: 'Video',
                        icon: Iconsax.video_play,
                        color: const Color(0xFF4F46E5),
                        onTap: () => ref.read(navIndexProvider.notifier).state = 1,
                      ),
                      const Gap(16),
                      _QuickActionCard(
                        label: 'Testlar',
                        icon: Iconsax.task_square,
                        color: const Color(0xFFF59E0B),
                        onTap: () => ref.read(navIndexProvider.notifier).state = 3,
                      ),
                    ],
                  ),
                  const Gap(16),
                  Row(
                    children: [
                      _QuickActionCard(
                        label: 'Kitoblar',
                        icon: Iconsax.book,
                        color: const Color(0xFF10B981),
                        onTap: () => ref.read(navIndexProvider.notifier).state = 2,
                      ),
                      const Gap(16),
                      _QuickActionCard(
                        label: 'AI Yordamchi',
                        icon: Iconsax.magic_star,
                        color: const Color(0xFF8B5CF6),
                        onTap: () => context.push(AppRoutes.aiChat),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Continue Learning ───────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('O\'rganishda davom eting', style: AppTextStyles.h3.copyWith(fontSize: 18)),
                      TextButton(
                        onPressed: () => ref.read(navIndexProvider.notifier).state = 1,
                        child: Text('Barchasi', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const Gap(8),
                  videosAsync.when(
                    data: (videos) {
                      if (videos.isEmpty) return const SizedBox();
                      final video = videos.first;
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 100,
                              height: 70,
                              decoration: BoxDecoration(
                                image: video.thumbnailUrl != null ? DecorationImage(
                                  image: NetworkImage(video.thumbnailUrl!),
                                  fit: BoxFit.cover,
                                ) : null,
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Icon(Icons.play_circle_fill, color: Colors.white.withValues(alpha: 0.9), size: 30),
                              ),
                            ),
                            const Gap(16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    video.title,
                                    style: AppTextStyles.h4.copyWith(fontSize: 16),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Gap(4),
                                  Text('2-dars • 15 daqiqa qoldi', style: AppTextStyles.caption),
                                  const Gap(8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: 0.6,
                                      minHeight: 4,
                                      backgroundColor: isDark ? AppColors.darkSurface2 : AppColors.lightSurface2,
                                      valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    loading: () => const SizedBox(height: 100),
                    error: (_, __) => const SizedBox(),
                  ),
                ],
              ),
            ),
          ),

          // ── AI Tip of the Day ───────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Iconsax.magic_star, color: Colors.white, size: 24),
                        ),
                        const Gap(12),
                        const Text(
                          'Bugungi AI Tavsiyasi',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
                        ),
                      ],
                    ),
                    const Gap(16),
                    const Text(
                      "Chizmalarda asosiy yo'g'on chiziqni qalamga biroz bosim berib chizish, detalning ko'rinishini yanada aniqroq qiladi. Bugun amaliyotda sinab ko'ring!",
                      style: TextStyle(color: Colors.white, height: 1.6, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;
  const _HeaderButton({required this.icon, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface2 : AppColors.lightSurface2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        child: Icon(icon, size: 22, color: isDark ? Colors.white : Colors.black),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: color.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const Gap(16),
              Text(
                label,
                style: AppTextStyles.h4.copyWith(fontSize: 15, color: color, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
