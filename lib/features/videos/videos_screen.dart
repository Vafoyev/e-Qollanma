import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/models/video_model.dart';
import '../../providers/video_provider.dart';
import '../../shared/widgets/loading_shimmer.dart';
import '../../shared/widgets/app_error_widget.dart';

class VideosScreen extends ConsumerWidget {
  const VideosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark      = Theme.of(context).brightness == Brightness.dark;
    final videosAsync = ref.watch(filteredVideoListProvider);
    final allVideos   = ref.watch(videoListProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 800;
        // Desktopda ko'proq ustunlar, Mobilda 1 ta (List ko'rinishida)
        final int crossAxisCount = isDesktop ? (constraints.maxWidth ~/ 350).clamp(2, 4) : 1;

        return Scaffold(
          backgroundColor: Colors.transparent, // Desktopda fondan foydalanish uchun
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── App Bar ──────────────────────────────────────────────────
              SliverAppBar(
                expandedHeight: isDesktop ? 80 : 100,
                floating: true,
                pinned: true,
                elevation: 0,
                backgroundColor: isDesktop ? Colors.transparent : (isDark ? AppColors.darkBg : AppColors.lightBg),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'videos_title'.tr(),
                    style: (isDark ? AppTextStyles.h2Dark : AppTextStyles.h2).copyWith(
                      fontSize: isDesktop ? 22 : 20,
                    ),
                  ),
                  titlePadding: EdgeInsets.only(
                    left: 20, 
                    bottom: isDesktop ? 24 : 14
                  ),
                ),
              ),

              // ── Topic Selector ───────────────────────────────────────────
              SliverToBoxAdapter(
                child: allVideos.when(
                  data: (videos) {
                    final topics = ['Barchasi', ...videos.map((v) => v.topic).toSet()];
                    return _TopicSelector(topics: topics);
                  },
                  loading: () => const SizedBox(height: 54),
                  error: (_, __) => const SizedBox(),
                ),
              ),

              // ── Videos Grid ──────────────────────────────────────────────
              videosAsync.when(
                loading: () => SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: isDesktop ? 1.1 : 1.4,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (_, __) => const LoadingShimmer(height: 250, borderRadius: 24),
                      childCount: 6,
                    ),
                  ),
                ),
                error: (e, _) => SliverFillRemaining(
                  child: AppErrorWidget(
                    message: "Internet aloqasini tekshiring",
                    onRetry: () => ref.refresh(videoListProvider),
                  ),
                ),
                data: (videos) {
                  if (videos.isEmpty) return const SliverToBoxAdapter();
                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 24,
                        childAspectRatio: isDesktop ? 1.05 : 1.35,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => _VideoCard(
                          video: videos[i],
                          isDark: isDark,
                          isDesktop: isDesktop,
                          onTap: () => context.push('/video/${videos[i].id}'),
                        ),
                        childCount: videos.length,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }
    );
  }
}

class _TopicSelector extends ConsumerWidget {
  final List<String> topics;
  const _TopicSelector({required this.topics});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTopic = ref.watch(selectedTopicProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 54,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: topics.length,
        itemBuilder: (context, i) {
          final topic = topics[i];
          final isActive = selectedTopic == topic;

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => ref.read(selectedTopicProvider.notifier).state = topic,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : (isDark ? AppColors.darkSurface : Colors.white),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isActive ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                  boxShadow: isActive ? [
                    BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))
                  ] : [],
                ),
                child: Center(
                  child: Text(
                    topic,
                    style: TextStyle(
                      color: isActive ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _VideoCard extends StatelessWidget {
  final VideoModel video;
  final bool isDark;
  final bool isDesktop;
  final VoidCallback onTap;

  const _VideoCard({
    required this.video,
    required this.isDark,
    required this.isDesktop,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Thumbnail ──────────────────────────────────────────────
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    child: CachedNetworkImage(
                      imageUrl: video.thumbnailUrl ?? '',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const LoadingShimmer(height: 200, borderRadius: 0),
                      errorWidget: (_, __, ___) => Container(
                        color: isDark ? AppColors.darkSurface2 : AppColors.lightSurface2,
                        child: Icon(Iconsax.video_play, size: 40, color: AppColors.primary.withValues(alpha: 0.3)),
                      ),
                    ),
                  ),
                  // Play Icon Overlay
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.play_arrow_rounded, color: AppColors.primary, size: 32),
                      ),
                    ),
                  ),
                  // Duration Badge
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        video.duration, 
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // ── Info ───────────────────────────────────────────────────
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            video.topic.toUpperCase(), 
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 10)
                          ),
                        ),
                        const Spacer(),
                        Text(video.createdAt, style: AppTextStyles.caption.copyWith(fontSize: 10)),
                      ],
                    ),
                    const Gap(10),
                    Text(
                      video.title, 
                      style: (isDark ? AppTextStyles.h4Dark : AppTextStyles.h4).copyWith(fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(6),
                    Expanded(
                      child: Text(
                        video.description, 
                        style: (isDark ? AppTextStyles.smallDark : AppTextStyles.small).copyWith(fontSize: 12), 
                        maxLines: isDesktop ? 2 : 1, 
                        overflow: TextOverflow.ellipsis
                      ),
                    ),
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
