import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/models/video_model.dart';
import '../../providers/video_provider.dart';

class VideosScreen extends ConsumerWidget {
  const VideosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark     = Theme.of(context).brightness == Brightness.dark;
    final videosAsync = ref.watch(videoListProvider);

    return Scaffold(
      backgroundColor:
      isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: Text('videos_title'.tr()),
        backgroundColor:
        isDark ? AppColors.darkSurface : AppColors.lightSurface,
      ),
      body: videosAsync.when(
        loading: () => _buildShimmer(isDark),
        error: (e, _) => _buildError(context, ref, e.toString(), isDark),
        data: (videos) {
          if (videos.isEmpty) {
            return _buildEmpty(isDark);
          }
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => ref.refresh(videoListProvider.future),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: videos.length,
              itemBuilder: (_, i) => _VideoCard(
                video: videos[i],
                isDark: isDark,
                onTap: () => context.push(
                  '/video/${videos[i].id}',
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmer(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Shimmer.fromColors(
          baseColor: isDark
              ? AppColors.darkSurface2
              : AppColors.lightSurface2,
          highlightColor:
          isDark ? AppColors.darkBorder : AppColors.lightBorder,
          child: Container(
            height: 220,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurface
                  : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Iconsax.video_slash,
              size: 64,
              color: isDark
                  ? AppColors.darkIcon
                  : AppColors.lightIcon),
          const Gap(16),
          Text('videos_empty'.tr(),
              style: AppTextStyles.body.copyWith(
                color: isDark
                    ? AppColors.darkTextSub
                    : AppColors.lightTextSub,
              )),
        ],
      ),
    );
  }

  Widget _buildError(
      BuildContext context, WidgetRef ref, String msg, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Iconsax.wifi_square,
                size: 64, color: AppColors.error),
            const Gap(16),
            Text(msg,
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: isDark
                      ? AppColors.darkTextSub
                      : AppColors.lightTextSub,
                )),
            const Gap(24),
            ElevatedButton(
              onPressed: () => ref.refresh(videoListProvider),
              child: Text('btn_retry'.tr()),
            ),
          ],
        ),
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
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
            isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Thumbnail ────────────────────────────────────────────────
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16)),
              child: Stack(
                children: [
                  video.thumbnailUrl != null
                      ? CachedNetworkImage(
                    imageUrl: video.thumbnailUrl!,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      height: 180,
                      color: isDark
                          ? AppColors.darkSurface2
                          : AppColors.lightSurface2,
                    ),
                    errorWidget: (_, __, ___) =>
                        _thumbnailPlaceholder(isDark),
                  )
                      : _thumbnailPlaceholder(isDark),

                  // Play button overlay
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),

                  // YouTube badge
                  if (video.isYoutube)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF0000),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'YouTube',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Nunito',
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── Info ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: AppTextStyles.h4.copyWith(
                      color: isDark
                          ? AppColors.darkText
                          : AppColors.lightText,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (video.description.isNotEmpty) ...[
                    const Gap(6),
                    Text(
                      video.description,
                      style: AppTextStyles.small.copyWith(
                        color: isDark
                            ? AppColors.darkTextSub
                            : AppColors.lightTextSub,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _thumbnailPlaceholder(bool isDark) {
    return Container(
      height: 180,
      width: double.infinity,
      color:
      isDark ? AppColors.darkSurface2 : AppColors.lightSurface2,
      child: Icon(
        Iconsax.video_play,
        size: 48,
        color: isDark ? AppColors.darkIcon : AppColors.lightIcon,
      ),
    );
  }
}