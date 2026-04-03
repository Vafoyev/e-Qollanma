import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:gap/gap.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/models/video_model.dart';
import '../../providers/video_provider.dart';

class VideoDetailScreen extends ConsumerStatefulWidget {
  final String videoId;
  const VideoDetailScreen({super.key, required this.videoId});

  @override
  ConsumerState<VideoDetailScreen> createState() =>
      _VideoDetailScreenState();
}

class _VideoDetailScreenState
    extends ConsumerState<VideoDetailScreen> {
  YoutubePlayerController? _ytController;

  @override
  void dispose() {
    _ytController?.dispose();
    super.dispose();
  }

  void _initYoutube(String youtubeId) {
    _ytController ??= YoutubePlayerController(
      initialVideoId: youtubeId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark      = Theme.of(context).brightness == Brightness.dark;
    final videosAsync = ref.watch(videoListProvider);

    return videosAsync.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(e.toString())),
      ),
      data: (videos) {
        final video = videos.firstWhere(
              (v) => v.id == widget.videoId,
          orElse: () => videos.first,
        );

        if (video.isYoutube && video.youtubeId != null) {
          _initYoutube(video.youtubeId!);
        }

        return YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _ytController ??
                YoutubePlayerController(initialVideoId: ''),
            showVideoProgressIndicator: true,
            progressIndicatorColor: AppColors.primary,
          ),
          builder: (context, player) {
            return Scaffold(
              backgroundColor:
              isDark ? AppColors.darkBg : AppColors.lightBg,
              appBar: AppBar(
                title: Text(
                  video.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                backgroundColor: isDark
                    ? AppColors.darkSurface
                    : AppColors.lightSurface,
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Video player ──────────────────────────────────────
                    if (video.isYoutube && _ytController != null)
                      player
                    else
                      Container(
                        height: 220,
                        color: Colors.black,
                        child: const Center(
                          child: Icon(
                            Icons.play_circle_outline,
                            color: Colors.white,
                            size: 64,
                          ),
                        ),
                      ),

                    // ── Ma'lumot ──────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            video.title,
                            style: AppTextStyles.h3.copyWith(
                              color: isDark
                                  ? AppColors.darkText
                                  : AppColors.lightText,
                            ),
                          ),
                          if (video.description.isNotEmpty) ...[
                            const Gap(12),
                            Text(
                              video.description,
                              style: AppTextStyles.body.copyWith(
                                color: isDark
                                    ? AppColors.darkTextSub
                                    : AppColors.lightTextSub,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}