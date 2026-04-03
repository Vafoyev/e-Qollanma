import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/models/quiz_model.dart';
import '../../providers/quiz_provider.dart';

class QuizListScreen extends ConsumerWidget {
  const QuizListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark     = Theme.of(context).brightness == Brightness.dark;
    final quizAsync  = ref.watch(quizListProvider);

    return Scaffold(
      backgroundColor:
      isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: Text('quiz_title'.tr()),
        backgroundColor:
        isDark ? AppColors.darkSurface : AppColors.lightSurface,
      ),
      body: quizAsync.when(
        loading: () => _shimmer(isDark),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Iconsax.wifi_square,
                  size: 48, color: AppColors.error),
              const Gap(12),
              Text(e.toString(), textAlign: TextAlign.center),
              const Gap(16),
              ElevatedButton(
                onPressed: () => ref.refresh(quizListProvider),
                child: Text('btn_retry'.tr()),
              ),
            ],
          ),
        ),
        data: (quizzes) {
          if (quizzes.isEmpty) {
            return Center(
              child: Text('quiz_empty'.tr(),
                  style: AppTextStyles.body.copyWith(
                    color: isDark
                        ? AppColors.darkTextSub
                        : AppColors.lightTextSub,
                  )),
            );
          }
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => ref.refresh(quizListProvider.future),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: quizzes.length,
              itemBuilder: (_, i) => _QuizTile(
                quiz: quizzes[i],
                isDark: isDark,
                index: i + 1,
                onTap: () =>
                    context.push('/quiz/${quizzes[i].id}'),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _shimmer(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Shimmer.fromColors(
          baseColor: isDark
              ? AppColors.darkSurface2
              : AppColors.lightSurface2,
          highlightColor:
          isDark ? AppColors.darkBorder : AppColors.lightBorder,
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurface
                  : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuizTile extends StatelessWidget {
  final QuizModel quiz;
  final bool isDark;
  final int index;
  final VoidCallback onTap;

  const _QuizTile({
    required this.quiz,
    required this.isDark,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding:
        const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
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
            // Raqam
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '$index',
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ),

            const Gap(14),

            // Nomi
            Expanded(
              child: Text(
                quiz.title,
                style: AppTextStyles.h4.copyWith(
                  color: isDark
                      ? AppColors.darkText
                      : AppColors.lightText,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const Gap(12),

            // Arrow
            Icon(
              Iconsax.arrow_right_3,
              color: AppColors.primary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}