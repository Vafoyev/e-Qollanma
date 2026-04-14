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
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: CustomScrollView(
        slivers: [
          // ── Header ────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 160,
            floating: false,
            pinned: true,
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      bottom: -20,
                      child: Icon(
                        Iconsax.task_square,
                        size: 140,
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'quiz_title'.tr(),
                            style: AppTextStyles.h1.copyWith(color: Colors.white),
                          ),
                          const Gap(4),
                          const Text(
                            'Bilimingizni sinovdan o\'tkazing',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Stats Row ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                children: [
                  _StatBadge(
                    label: 'Mavjud testlar',
                    value: '12 ta',
                    icon: Iconsax.document_text,
                    isDark: isDark,
                  ),
                  const Gap(12),
                  _StatBadge(
                    label: 'O\'rtacha ball',
                    value: '85%',
                    icon: Iconsax.chart_2,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),

          // ── Quiz List ─────────────────────────────────────────────────
          quizAsync.when(
            loading: () => SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, __) => _shimmer(isDark),
                  childCount: 4,
                ),
              ),
            ),
            error: (e, _) => SliverFillRemaining(
              child: _buildError(e.toString(), ref),
            ),
            data: (quizzes) {
              if (quizzes.isEmpty) {
                return SliverFillRemaining(
                  child: Center(child: Text('quiz_empty'.tr())),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => _QuizCard(
                      quiz: quizzes[i],
                      isDark: isDark,
                      onTap: () => context.push('/quiz/${quizzes[i].id}'),
                    ),
                    childCount: quizzes.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _shimmer(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Shimmer.fromColors(
        baseColor: isDark ? AppColors.darkSurface2 : AppColors.lightSurface2,
        highlightColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _buildError(String msg, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Iconsax.danger, size: 48, color: AppColors.error),
          const Gap(12),
          Text(msg),
          const Gap(16),
          ElevatedButton(
            onPressed: () => ref.refresh(quizListProvider),
            child: Text('btn_retry'.tr()),
          ),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isDark;

  const _StatBadge({
    required this.label,
    required this.value,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const Gap(8),
            Text(value, style: AppTextStyles.h3.copyWith(color: isDark ? AppColors.darkText : AppColors.lightText)),
            Text(label, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}

class _QuizCard extends StatelessWidget {
  final QuizModel quiz;
  final bool isDark;
  final VoidCallback onTap;

  const _QuizCard({required this.quiz, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(quiz.icon, color: AppColors.primaryDark, size: 26),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quiz.category,
                    style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                  const Gap(2),
                  Text(
                    quiz.title,
                    style: AppTextStyles.h4.copyWith(
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(4),
                  Row(
                    children: [
                      const Icon(Iconsax.info_circle, size: 14, color: AppColors.lightIcon),
                      const Gap(4),
                      Text(
                        '${quiz.questionCount} ta savol',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Iconsax.arrow_right_3, color: AppColors.lightIcon, size: 18),
          ],
        ),
      ),
    );
  }
}
