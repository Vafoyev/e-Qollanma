import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/models/quiz_model.dart';
import '../../data/repositories/quiz_repository.dart';
import '../../providers/quiz_provider.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final String quizId;
  const QuizScreen({super.key, required this.quizId});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int _currentIndex = 0;
  bool _isSubmitting = false;

  Future<void> _submit() async {
    final answers = ref.read(quizAnswersProvider(widget.quizId));
    setState(() => _isSubmitting = true);

    try {
      final answerModels = answers.entries
          .map((e) => AnswerModel(
                questionId: e.key,
                selectedOption: e.value,
              ))
          .toList();

      final result = await ref.read(quizRepositoryProvider).submitQuiz(
            quizId: widget.quizId,
            answers: answerModels,
          );

      if (!mounted) return;
      context.pushReplacement(
        '/quiz/${widget.quizId}/result',
        extra: result,
      );
    } catch (e) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final questionsAsync = ref.watch(quizQuestionsProvider(widget.quizId));
    final answers = ref.watch(quizAnswersProvider(widget.quizId));

    return questionsAsync.when(
      loading: () => Scaffold(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        body: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(e.toString())),
      ),
      data: (questions) {
        if (questions.isEmpty) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('no_data'.tr())),
          );
        }

        final q = questions[_currentIndex];
        final total = questions.length;
        final isLast = _currentIndex == total - 1;
        final selected = answers[q.id];
        final progress = (_currentIndex + 1) / total;

        return Scaffold(
          backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
          appBar: AppBar(
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            leading: IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () => context.pop(),
            ),
            title: Column(
              children: [
                Text(
                  'quiz_title'.tr(),
                  style: AppTextStyles.h4,
                ),
                Text(
                  '${_currentIndex + 1} / $total',
                  style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              // ── Progress Tracker ──────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: isDark ? AppColors.darkSurface2 : AppColors.lightSurface2,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Savol Card ──────────────────────────────────────
                      Container(
                        width: double.infinity,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${'quiz_question'.tr()} ${_currentIndex + 1}',
                              style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                            ),
                            const Gap(12),
                            Text(
                              q.questionText,
                              style: AppTextStyles.h3.copyWith(
                                height: 1.5,
                                color: isDark ? AppColors.darkText : AppColors.lightText,
                              ),
                            ),
                            if (q.imageUrl != null) ...[
                              const Gap(20),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(q.imageUrl!, fit: BoxFit.cover),
                              ),
                            ],
                          ],
                        ),
                      ),

                      const Gap(32),

                      // ── Variantlar ───────────────────────────────────
                      ...q.optionEntries.map((entry) {
                        final key = entry.key;
                        final value = entry.value;
                        final isSelected = selected == key;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _OptionTile(
                            label: key,
                            text: value,
                            isSelected: isSelected,
                            isDark: isDark,
                            onTap: () {
                              ref.read(quizAnswersProvider(widget.quizId).notifier).update((s) => {
                                    ...s,
                                    q.id: key,
                                  });
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              // ── Navigation Buttons ─────────────────────────────────────
              Container(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    if (_currentIndex > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => setState(() => _currentIndex--),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.lightBorder),
                          ),
                          child: const Icon(Icons.arrow_back_rounded),
                        ),
                      )
                    else
                      const Spacer(),
                    
                    const Gap(16),
                    
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: selected == null
                            ? null
                            : isLast
                                ? (_isSubmitting ? null : _submit)
                                : () => setState(() => _currentIndex++),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                              )
                            : Text(isLast ? 'quiz_finish'.tr() : 'btn_next'.tr()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String label;
  final String text;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _OptionTile({
    required this.label,
    required this.text,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withValues(alpha: 0.2) : (isDark ? AppColors.darkSurface2 : AppColors.lightSurface2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  label,
                  style: AppTextStyles.h4.copyWith(
                    color: isSelected ? Colors.white : (isDark ? AppColors.darkText : AppColors.lightText),
                  ),
                ),
              ),
            ),
            const Gap(16),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isSelected ? Colors.white : (isDark ? AppColors.darkText : AppColors.lightText),
                ),
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
