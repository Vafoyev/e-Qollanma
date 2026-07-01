import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

/// Drawing Game - Select correct projection types
class DrawingGameScreen extends StatefulWidget {
  const DrawingGameScreen({super.key});

  @override
  State<DrawingGameScreen> createState() => _DrawingGameScreenState();
}

class _DrawingGameScreenState extends State<DrawingGameScreen> {
  late List<_ProjectionQuestion> questions;
  int _currentQuestion = 0;
  int _correctAnswers = 0;

  @override
  void initState() {
    super.initState();
    _initializeQuestions();
  }

  void _initializeQuestions() {
    questions = [
      _ProjectionQuestion(
        question: "Bu qanday projektsiya?",
        hint: "Uchta ko'rinish: old, yuqori, yon",
        options: ["Ortogonal", "Aksometrik", "Perspektiva"],
        correctIndex: 0,
        icon: Iconsax.box,
      ),
      _ProjectionQuestion(
        question: "Qaysi kesim turi to'g'ri?",
        hint: "Kesim tekisligi qismini ko'rsatadi",
        options: ["Vertikal kesim", "Gorizontal kesim", "Egilgan kesim"],
        correctIndex: 2,
        icon: Iconsax.slash,
      ),
      _ProjectionQuestion(
        question: "Chiziqning qalinligi nima?",
        hint: "GOST standart bo'yicha",
        options: ["0.5 mm", "0.3-0.5 mm", "1.4 mm"],
        correctIndex: 1,
        icon: Iconsax.minus,
      ),
      _ProjectionQuestion(
        question: "Qaysi masshtab to'g'ri?",
        hint: "Katta ko'paytirish nisbati",
        options: ["1:2", "2:1", "1:4"],
        correctIndex: 1,
        icon: Iconsax.bezier,
      ),
      _ProjectionQuestion(
        question: "Qanday protsiyada hamma tomonlar teng?",
        hint: "Aksometrik proyeksiya turlari",
        options: ["Izometrik", "Dimetrik", "Trimetrik"],
        correctIndex: 0,
        icon: Iconsax.shapes,
      ),
    ];
  }

  void _selectAnswer(int selectedIndex) {
    final question = questions[_currentQuestion];
    if (selectedIndex == question.correctIndex) {
      setState(() => _correctAnswers++);
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      if (_currentQuestion < questions.length - 1) {
        setState(() => _currentQuestion++);
      } else {
        _showResults();
      }
    });
  }

  void _showResults() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text("Natijalar"),
        content: Text(
          "Siz ${questions.length} ta savoldan $_correctAnswers tasiga to'g'ri javob berdingiz!\n\n"
          "Foiz: ${((_correctAnswers / questions.length) * 100).toStringAsFixed(0)}%",
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentQuestion = 0;
                _correctAnswers = 0;
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
        title: const Text("Chizmali o'yini"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Savol ${_currentQuestion + 1}/${questions.length}",
                  style: AppTextStyles.body,
                ),
                Text(
                  "To'g'ri: $_correctAnswers",
                  style: AppTextStyles.body.copyWith(color: AppColors.success),
                ),
              ],
            ),
            const Gap(12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (_currentQuestion + 1) / questions.length,
                minHeight: 8,
                backgroundColor: isDark ? AppColors.darkSurface : Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const Gap(32),

            // Question
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Icon(question.icon, size: 64, color: AppColors.primary),
                  const Gap(16),
                  Text(
                    question.question,
                    style: AppTextStyles.h3,
                    textAlign: TextAlign.center,
                  ),
                  const Gap(12),
                  Text(
                    question.hint,
                    style: AppTextStyles.caption.copyWith(
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Gap(32),

            // Options
            Expanded(
              child: ListView.separated(
                itemCount: question.options.length,
                separatorBuilder: (_, __) => const Gap(12),
                itemBuilder: (context, index) {
                  return _OptionButton(
                    text: question.options[index],
                    onTap: () => _selectAnswer(index),
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

class _ProjectionQuestion {
  final String question;
  final String hint;
  final List<String> options;
  final int correctIndex;
  final IconData icon;

  _ProjectionQuestion({
    required this.question,
    required this.hint,
    required this.options,
    required this.correctIndex,
    required this.icon,
  });
}

class _OptionButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const _OptionButton({required this.text, required this.onTap});

  @override
  State<_OptionButton> createState() => _OptionButtonState();
}

class _OptionButtonState extends State<_OptionButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    _controller.forward().then((_) => widget.onTap());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ScaleTransition(
      scale: Tween<double>(begin: 1.0, end: 0.95).animate(_controller),
      child: GestureDetector(
        onTap: _onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
              ),
              const Gap(16),
              Expanded(
                child: Text(
                  widget.text,
                  style: AppTextStyles.body,
                ),
              ),
              const Icon(Iconsax.arrow_right, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
