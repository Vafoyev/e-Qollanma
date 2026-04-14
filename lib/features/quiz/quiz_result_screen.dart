import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/models/quiz_model.dart';
import '../../core/router/app_router.dart';

class QuizResultScreen extends ConsumerWidget {
  final String quizId;
  final ResultModel? result;

  const QuizResultScreen({
    super.key,
    required this.quizId,
    this.result,
  });

  String _getAIConclusion(double percentage) {
    if (percentage >= 90) {
      return "Sizning chizmachilik bo'yicha bilimingiz juda yuqori! Siz barcha standartlarni mukammal bilasiz. Shunday davom eting, sizdan yaxshi muhandis chiqadi.";
    } else if (percentage >= 70) {
      return "Yaxshi natija! Mavzuni tushunasiz, lekin ba'zi o'lchamlar va chiziq turlariga ko'proq e'tibor berishingizni maslahat beraman. Kutubxonadagi darsliklarni yana bir ko'zdan kechiring.";
    } else if (percentage >= 50) {
      return "Bilimingiz o'rtacha. Test savollarida ko'proq xatolarga yo'l qo'ydingiz. Video darslarni qaytadan ko'rib chiqishingiz va amaliy mashqlarni ko'proq bajarishingiz foydali bo'ladi.";
    } else {
      return "Hozircha natijangiz past. Chizmachilik asoslarini, xususan chiziq turlari va format o'lchamlarini boshidan o'rganishni tavsiya qilaman. Taslim bo'lmang, qayta urinib ko'ring!";
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Agar result null bo'lsa (masalan, router orqali noto'g'ri kirilganda)
    if (result == null) {
      return const Scaffold(body: Center(child: Text('Natija topilmadi')));
    }

    final isPassed = result!.isPassed;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Gap(40),

                    // ── Animation / Icon ─────────────────────────────────────
                    SizedBox(
                      height: 200,
                      child: isPassed
                          ? Lottie.asset(
                              'assets/animations/splash_drawing.json',
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.check_circle_outline_rounded,
                                  size: 100,
                                  color: AppColors.success,
                                );
                              },
                            )
                          : const Icon(Iconsax.danger, size: 100, color: AppColors.error),
                    ),

                    const Gap(24),

                    // ── Status Title ─────────────────────────────────────────
                    Text(
                      isPassed ? 'quiz_passed'.tr() : 'quiz_failed'.tr(),
                      style: AppTextStyles.h1.copyWith(
                        color: isPassed ? AppColors.success : AppColors.error,
                        fontSize: 32,
                      ),
                    ),
                    
                    const Gap(8),

                    Text(
                      isPassed 
                          ? 'Tabriklaymiz! Siz testdan muvaffaqiyatli o\'tdingiz.'
                          : 'Afsus, siz yetarli ball to\'play olmadingiz.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body.copyWith(color: isDark ? AppColors.darkTextSub : AppColors.lightTextSub),
                    ),

                    const Gap(40),

                    // ── Score Card ───────────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _ResultRow(
                            label: 'quiz_total'.tr(),
                            value: '${result!.total}',
                            icon: Iconsax.document_text,
                            color: AppColors.primary,
                            isDark: isDark,
                          ),
                          const Divider(height: 32),
                          _ResultRow(
                            label: 'quiz_correct'.tr(),
                            value: '${result!.correct}',
                            icon: Iconsax.tick_circle,
                            color: AppColors.success,
                            isDark: isDark,
                          ),
                          const Divider(height: 32),
                          _ResultRow(
                            label: 'quiz_percentage'.tr(),
                            value: '${result!.percentage.toStringAsFixed(0)}%',
                            icon: Iconsax.chart_2,
                            color: AppColors.warning,
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ),

                    const Gap(24),

                    // ── AI Conclusion (AI Xulosa) ─────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark 
                              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                              : [const Color(0xFFF0F9FF), const Color(0xFFE0F2FE)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Iconsax.cpu, color: AppColors.primary, size: 24),
                              const Gap(10),
                              Text(
                                'AI Xulosa',
                                style: AppTextStyles.h4.copyWith(color: AppColors.primary),
                              ),
                            ],
                          ),
                          const Gap(12),
                          Text(
                            _getAIConclusion(result!.percentage),
                            style: AppTextStyles.body.copyWith(
                              color: isDark ? AppColors.darkText : AppColors.lightText,
                              height: 1.6,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Buttons ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => context.go(AppRoutes.home),
                    child: Text('quiz_home'.tr()),
                  ),
                  const Gap(12),
                  TextButton(
                    onPressed: () => context.replace('/quiz/$quizId'),
                    child: Text('quiz_retry'.tr()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _ResultRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const Gap(16),
        Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: AppTextStyles.h3.copyWith(
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
      ],
    );
  }
}
