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

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 800;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Header (Mobile only) ──────────────────
              if (!isDesktop)
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 32),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : Colors.white,
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
                      boxShadow: [
                        if(!isDark) BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
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
                              width: 56, height: 56,
                              decoration: const BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
                              child: Center(
                                child: Text(
                                  user?.fullName[0].toUpperCase() ?? 'U', 
                                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)
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
                                    style: isDark ? AppTextStyles.smallDark : AppTextStyles.caption
                                  ),
                                  Text(
                                    user?.fullName ?? 'Foydalanuvchi', 
                                    style: (isDark ? AppTextStyles.h2Dark : AppTextStyles.h2).copyWith(fontSize: 20)
                                  ),
                                ],
                              ),
                            ),
                            Icon(Iconsax.notification, color: isDark ? Colors.white : Colors.black87),
                          ],
                        ),
                        const Gap(28),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          height: 56,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface2 : AppColors.lightSurface2,
                            borderRadius: BorderRadius.circular(20),
                            border: isDark ? Border.all(color: AppColors.darkBorder) : null,
                          ),
                          child: Row(
                            children: [
                              const Icon(Iconsax.search_normal, color: AppColors.primary, size: 22),
                              const Gap(16),
                              Text(
                                'search'.tr(), 
                                style: (isDark ? AppTextStyles.bodyDark : AppTextStyles.body).copyWith(color: isDark ? AppColors.darkIcon : AppColors.lightIcon)
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              SliverGap(isDesktop ? 32 : 24),

              // ── Quick Actions ───────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tezkor buyruqlar', 
                        style: (isDark ? AppTextStyles.h3Dark : AppTextStyles.h3).copyWith(fontSize: 18)
                      ),
                      const Gap(20),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: isDesktop ? 5 : 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: isDesktop ? 1.2 : 1.1,
                        children: [
                          _QuickActionCard(label: 'Video', icon: Iconsax.video_play, color: const Color(0xFF4F46E5), onTap: () => ref.read(navIndexProvider.notifier).state = 1),
                          _QuickActionCard(label: 'Testlar', icon: Iconsax.task_square, color: const Color(0xFFF59E0B), onTap: () => ref.read(navIndexProvider.notifier).state = 3),
                          _QuickActionCard(label: 'Kitoblar', icon: Iconsax.book, color: const Color(0xFF10B981), onTap: () => ref.read(navIndexProvider.notifier).state = 2),
                          _QuickActionCard(label: 'O\'yin', icon: Iconsax.game, color: const Color(0xFFEC4899), onTap: () => context.push(AppRoutes.game)),
                          _QuickActionCard(
                            label: 'AI Yordamchi', 
                            icon: Iconsax.magic_star, 
                            color: const Color(0xFF8B5CF6), 
                            onTap: () => context.push(AppRoutes.aiChat)
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
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'O\'rganishda davom eting', 
                            style: (isDark ? AppTextStyles.h3Dark : AppTextStyles.h3).copyWith(fontSize: 18)
                          ),
                          TextButton(
                            onPressed: () => ref.read(navIndexProvider.notifier).state = 1, 
                            child: const Text('Barchasi')
                          ),
                        ],
                      ),
                      const Gap(12),
                      videosAsync.when(
                        data: (videos) {
                          if (videos.isEmpty) return const SizedBox();
                          final video = videos.first;
                          return Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurface2.withValues(alpha: 0.4) : Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 140, height: 90,
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.darkSurface2 : AppColors.primaryLight,
                                    borderRadius: BorderRadius.circular(16),
                                    image: video.thumbnailUrl != null ? DecorationImage(image: NetworkImage(video.thumbnailUrl!), fit: BoxFit.cover) : null,
                                  ),
                                  child: const Center(child: Icon(Icons.play_circle_fill, color: Colors.white, size: 40)),
                                ),
                                const Gap(24),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        video.title, 
                                        style: (isDark ? AppTextStyles.h4Dark : AppTextStyles.h4).copyWith(fontSize: 18), 
                                        maxLines: 1
                                      ),
                                      const Gap(6),
                                      Text(
                                        '2-dars • 15 daqiqa qoldi', 
                                        style: isDark ? AppTextStyles.smallDark : AppTextStyles.caption
                                      ),
                                      const Gap(16),
                                      LinearProgressIndicator(
                                        value: 0.6, 
                                        minHeight: 8, 
                                        borderRadius: BorderRadius.circular(4), 
                                        backgroundColor: isDark ? Colors.white10 : Colors.black12, 
                                        valueColor: const AlwaysStoppedAnimation(AppColors.primary)
                                      ),
                                    ],
                                  ),
                                ),
                                if (isDesktop) Padding(
                                  padding: const EdgeInsets.only(left: 32),
                                  child: ElevatedButton(
                                    onPressed: () => context.push('/video/${video.id}'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: const Text('Davom etish'),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (_, __) => const SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),

              // ── AI Tip ──────────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient, 
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Bugungi AI Tavsiyasi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
                              Gap(12),
                              Text(
                                "Chizmalarda asosiy yo'g'on chiziqni qalamga biroz bosim berib chizishni unutmang! Bu detalning ko'rinishini yanada aniqroq qiladi.", 
                                style: TextStyle(color: Colors.white, fontSize: 16, height: 1.5)
                              ),
                            ],
                          ),
                        ),
                        const Gap(20),
                        Icon(Iconsax.lamp_on, color: Colors.white, size: isDesktop ? 80 : 60),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _QuickActionCard({required this.label, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.15 : 0.1), 
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withValues(alpha: isDark ? 0.3 : 0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color, 
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 6))
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const Gap(12),
            Flexible(
              child: Text(
                label, 
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? Colors.white.withValues(alpha: 0.9) : color,
                  fontWeight: FontWeight.bold, 
                  fontSize: 14
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
