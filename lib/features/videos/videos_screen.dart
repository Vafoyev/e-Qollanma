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

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'videos_title'.tr(),
                style: AppTextStyles.h2.copyWith(
                  fontSize: 20,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 20, bottom: 14),
            ),
          ),

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

          videosAsync.when(
            loading: () => SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, __) => const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: LoadingShimmer(height: 220, borderRadius: 24),
                  ),
                  childCount: 3,
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
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => _VideoCard(
                      video: videos[i],
                      isDark: isDark,
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                    style: AppTextStyles.small.copyWith(
                      color: isActive ? Colors.white : (isDark ? AppColors.darkText : AppColors.lightText),
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
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
  final VoidCallback onTap;

  const _VideoCard({
    required this.video,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.4 : 0.06),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: CachedNetworkImage(
                    imageUrl: video.thumbnailUrl ?? '',
                    width: double.infinity,
                    height: 190,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => const LoadingShimmer(height: 190, borderRadius: 24),
                    errorWidget: (_, __, ___) => Container(
                      height: 190,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface2 : AppColors.lightSurface2,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Iconsax.video_play, size: 48, color: AppColors.primary.withValues(alpha: 0.5)),
                          const Gap(8),
                          Text("Rasm yuklanmadi", style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                  ),
                ),
                // Play Icon Overlay
                Positioned.fill(
                  child: Center(
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 15)],
                      ),
                      child: const Icon(Icons.play_arrow_rounded, color: AppColors.primary, size: 36),
                    ),
                  ),
                ),
                // Duration Badge
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(10)),
                    child: Text(video.duration, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                        child: Text(video.topic.toUpperCase(), style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 10)),
                      ),
                      const Spacer(),
                      Text(video.createdAt, style: AppTextStyles.caption),
                    ],
                  ),
                  const Gap(12),
                  Text(video.title, style: AppTextStyles.h4.copyWith(fontSize: 18, color: isDark ? AppColors.darkText : AppColors.lightText)),
                  const Gap(8),
                  Text(video.description, style: AppTextStyles.body.copyWith(fontSize: 14, color: isDark ? AppColors.darkTextSub : AppColors.lightTextSub), maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
