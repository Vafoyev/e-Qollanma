import 'package:e_qollanma/data/repositories/quiz_repository.dart';
import 'package:e_qollanma/data/models/quiz_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
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

      final result = await ref
          .read(quizRepositoryProvider)
          .submitQuiz(
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
    final isDark        = Theme.of(context).brightness == Brightness.dark;
    final questionsAsync =
    ref.watch(quizQuestionsProvider(widget.quizId));
    final answers = ref.watch(quizAnswersProvider(widget.quizId));

    return questionsAsync.when(
      loading: () => const Scaffold(
        body:
        Center(child: CircularProgressIndicator(color: AppColors.primary)),
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

        final q       = questions[_currentIndex];
        final total   = questions.length;
        final isLast  = _currentIndex == total - 1;
        final selected = answers[q.id];
        final progress = (_currentIndex + 1) / total;

        return Scaffold(
          backgroundColor:
          isDark ? AppColors.darkBg : AppColors.lightBg,
          appBar: AppBar(
            title: Text(
              '${'quiz_question'.tr()} ${_currentIndex + 1} ${'quiz_of'.tr()} $total',
            ),
            backgroundColor:
            isDark ? AppColors.darkSurface : AppColors.lightSurface,
            leading: _currentIndex > 0
                ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () =>
                  setState(() => _currentIndex--),
            )
                : null,
          ),
          body: Column(
            children: [
              // ── Progress bar ───────────────────────────────────────────
              LinearProgressIndicator(
                value: progress,
                backgroundColor: isDark
                    ? AppColors.darkBorder
                    : AppColors.lightBorder,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                minHeight: 4,
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(8),

                      // ── Savol ────────────────────────────────────────
                      Text(
                        q.questionText,
                        style: AppTextStyles.h3.copyWith(
                          color: isDark
                              ? AppColors.darkText
                              : AppColors.lightText,
                        ),
                      ),

                      const Gap(28),

                      // ── Variantlar ───────────────────────────────────
                      ...q.optionEntries.map((entry) {
                        final key      = entry.key;
                        final value    = entry.value;
                        final isSelected = selected == key;

                        return GestureDetector(
                          onTap: () {
                            ref
                                .read(quizAnswersProvider(
                                widget.quizId)
                                .notifier)
                                .update((s) => {
                              ...s,
                              q.id: key,
                            });
                          },
                          child: AnimatedContainer(
                            duration:
                            const Duration(milliseconds: 200),
                            margin:
                            const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryLight
                                  : (isDark
                                  ? AppColors.darkSurface
                                  : AppColors.lightSurface),
                              borderRadius:
                              BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : (isDark
                                    ? AppColors.darkBorder
                                    : AppColors.lightBorder),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Harf (A, B, C...)
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary
                                        : (isDark
                                        ? AppColors.darkSurface2
                                        : AppColors
                                        .lightSurface2),
                                    borderRadius:
                                    BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      key,
                                      style: AppTextStyles.bodyMedium
                                          .copyWith(
                                        color: isSelected
                                            ? Colors.white
                                            : (isDark
                                            ? AppColors
                                            .darkTextSub
                                            : AppColors
                                            .lightTextSub),
                                      ),
                                    ),
                                  ),
                                ),

                                const Gap(14),

                                // Javob matni
                                Expanded(
                                  child: Text(
                                    value,
                                    style:
                                    AppTextStyles.body.copyWith(
                                      color: isSelected
                                          ? AppColors.primaryDark
                                          : (isDark
                                          ? AppColors.darkText
                                          : AppColors.lightText),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              // ── Keyingi / Topshirish tugmasi ───────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
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
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                      : Text(isLast
                      ? 'quiz_finish'.tr()
                      : 'btn_next'.tr()),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}