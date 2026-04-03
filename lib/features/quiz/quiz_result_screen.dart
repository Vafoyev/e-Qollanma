import 'package:e_qollanma/data/models/quiz_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/router/app_router.dart';

class QuizResultScreen extends ConsumerWidget {
  final String quizId;
  const QuizResultScreen({super.key, required this.quizId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final result = GoRouterState.of(context).extra as ResultModel?;

    if (result == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('no_data'.tr())),
      );
    }

    final isPassed  = result.isPassed;
    final color     = isPassed ? AppColors.success : AppColors.error;
    final bgColor   = isPassed ? AppColors.successLight : AppColors.errorLight;

    return Scaffold(
      backgroundColor:
      isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),

              // ── Natija doirasi ─────────────────────────────────────────
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 4),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${result.percentage.toStringAsFixed(0)}%',
                      style: AppTextStyles.h1.copyWith(
                        color: color,
                        fontSize: 38,
                      ),
                    ),
                    Text(
                      isPassed
                          ? 'quiz_passed'.tr()
                          : 'quiz_failed'.tr(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),

              const Gap(40),

              // ── Natija sarlavha ────────────────────────────────────────
              Text(
                'quiz_result_title'.tr(),
                style: AppTextStyles.h2.copyWith(
                  color:
                  isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),

              const Gap(32),

              // ── Statistika kartalari ───────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'quiz_correct'.tr(),
                      value: '${result.correct}',
                      color: AppColors.success,
                      bgColor: AppColors.successLight,
                      isDark: isDark,
                    ),
                  ),
                  const Gap(14),
                  Expanded(
                    child: _StatCard(
                      label: 'quiz_total'.tr(),
                      value: '${result.total}',
                      color: isDark
                          ? AppColors.darkText
                          : AppColors.lightText,
                      bgColor: isDark
                          ? AppColors.darkSurface2
                          : AppColors.lightSurface2,
                      isDark: isDark,
                    ),
                  ),
                  const Gap(14),
                  Expanded(
                    child: _StatCard(
                      label: 'quiz_percentage'.tr(),
                      value:
                      '${result.percentage.toStringAsFixed(0)}%',
                      color: color,
                      bgColor: bgColor,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // ── Tugmalar ───────────────────────────────────────────────
              if (!isPassed)
                OutlinedButton(
                  onPressed: () =>
                      context.pushReplacement('/quiz/$quizId'),
                  child: Text('quiz_retry'.tr()),
                ),

              const Gap(12),

              ElevatedButton(
                onPressed: () => context.go(AppRoutes.home),
                child: Text('quiz_home'.tr()),
              ),

              const Gap(32),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color bgColor;
  final bool isDark;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.bgColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.h2.copyWith(color: color),
          ),
          const Gap(4),
          Text(
            label,
            style: AppTextStyles.small.copyWith(
              color: isDark
                  ? AppColors.darkTextSub
                  : AppColors.lightTextSub,
            ),
          ),
        ],
      ),
    );
  }
}