import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

/// Quiz Game - Multiple choice questions about drawing
class GameQuizScreen extends StatefulWidget {
  const GameQuizScreen({super.key});

  @override
  State<GameQuizScreen> createState() => _GameQuizScreenState();
}

class _GameQuizScreenState extends State<GameQuizScreen> {
  late List<_QuizQuestion> questions;
  int _currentQuestion = 0;
  int _correctAnswers = 0;
  int? _selectedAnswer;
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    _initializeQuestions();
  }

  void _initializeQuestions() {
    questions = [
      _QuizQuestion(
        question: "Chizmachilik nima?",
        options: [
          "Rasm chizish san'ati",
          "Texnik jadvallar va sxemalarni to'g'ri usulda chizish",
          "Shunga o'xshash narsa",
        ],
        correctIndex: 1,
      ),
      _QuizQuestion(
        question: "A4 qog'ozning o'lchamlari qanday?",
        options: ["210 × 297 mm", "297 × 420 mm", "148 × 210 mm"],
        correctIndex: 0,
      ),
      _QuizQuestion(
        question: "GOST bu nima?",
        options: [
          "Yangi texnika",
          "Davlat standartlari",
          "Rasm turlari",
        ],
        correctIndex: 1,
      ),
      _QuizQuestion(
        question: "Vertikal chiziq qalinligi qancha?",
        options: ["0.25 mm", "0.5-0.7 mm", "1.4 mm"],
        correctIndex: 1,
      ),
      _QuizQuestion(
        question: "Aksonometrik proyeksiya nechta ko'rinishni ko'rsatadi?",
        options: ["1 ta", "2 ta", "3 ta"],
        correctIndex: 2,
      ),
      _QuizQuestion(
        question: "Qaysi format chizmachilikda eng keng tarqalgan?",
        options: ["A3", "A4", "A2"],
        correctIndex: 1,
      ),
      _QuizQuestion(
        question: "Kesim nima uchun ishlatiladi?",
        options: [
          "Faqat dekoratsiya uchun",
          "Ichki tuzilishni ko'rsatish uchun",
          "Rasm chizmalarini qo'shimchali chizish uchun",
        ],
        correctIndex: 1,
      ),
      _QuizQuestion(
        question: "Masshtab nima?",
        options: [
          "Chizmada hamma narsani katta qilish",
          "Haqiqiy o'lchamlari bilan chiziladigan nisbat",
          "Chiziq turlari",
        ],
        correctIndex: 1,
      ),
    ];
  }

  void _selectAnswer(int index) {
    setState(() {
      _selectedAnswer = index;
      _answered = true;
    });

    if (index == questions[_currentQuestion].correctIndex) {
      setState(() => _correctAnswers++);
    }

    Future.delayed(const Duration(milliseconds: 800), () {
      if (_currentQuestion < questions.length - 1) {
        setState(() {
          _currentQuestion++;
          _selectedAnswer = null;
          _answered = false;
        });
      } else {
        _showResults();
      }
    });
  }

  void _showResults() {
    final percentage = ((_correctAnswers / questions.length) * 100).toStringAsFixed(0);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text("Test Natijasi"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
              child: Text(
                "$percentage%",
                style: AppTextStyles.h2.copyWith(color: AppColors.primary),
              ),
            ),
            const Gap(16),
            Text(
              "$_correctAnswers/${questions.length} to'g'ri",
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Yopish"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentQuestion = 0;
                _correctAnswers = 0;
                _selectedAnswer = null;
                _answered = false;
              });
            },
            child: const Text("Qayta o'ynash"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final question = questions[_currentQuestion];

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: const Text("Chizmachilik Testi"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Progress info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Savol ${_currentQuestion + 1}/${questions.length}",
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "$_correctAnswers to'g'ri",
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (_currentQuestion + 1) / questions.length,
                minHeight: 6,
                backgroundColor: isDark ? AppColors.darkSurface : Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const Gap(32),

            // Question
            Text(
              question.question,
              style: AppTextStyles.h3,
              textAlign: TextAlign.center,
            ),
            const Gap(32),

            // Options
            Expanded(
              child: ListView.separated(
                itemCount: question.options.length,
                separatorBuilder: (_, __) => const Gap(12),
                itemBuilder: (context, index) {
                  final isSelected = _selectedAnswer == index;
                  final isCorrect = index == question.correctIndex;
                  final showResult = _answered && isSelected;

                  return GestureDetector(
                    onTap: _answered ? null : () => _selectAnswer(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: showResult
                            ? (isCorrect ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1))
                            : (isDark ? AppColors.darkSurface : Colors.white),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: showResult
                              ? (isCorrect ? Colors.green : Colors.red)
                              : (isSelected
                                  ? AppColors.primary
                                  : (isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder)),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: showResult
                                    ? (isCorrect ? Colors.green : Colors.red)
                                    : AppColors.primary,
                                width: 2,
                              ),
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.transparent,
                            ),
                            child: Center(
                              child: showResult
                                  ? Icon(
                                      isCorrect ? Iconsax.tick_circle : Iconsax.close_circle,
                                      color: isCorrect ? Colors.green : Colors.red,
                                      size: 16,
                                    )
                                  : Text(
                                      "${index + 1}",
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const Gap(16),
                          Expanded(
                            child: Text(
                              question.options[index],
                              style: AppTextStyles.body.copyWith(
                                color: showResult
                                    ? (isCorrect ? Colors.green : Colors.red)
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  _QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}
