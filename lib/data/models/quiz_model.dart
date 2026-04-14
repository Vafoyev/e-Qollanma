import 'package:flutter/material.dart';

// ── Quiz ──────────────────────────────────────────────────────────────────────
class QuizModel {
  final String id;
  final String title;
  final bool isActive;
  final String createdAt;
  final String category;
  final int questionCount;
  final IconData icon;

  const QuizModel({
    required this.id,
    required this.title,
    required this.isActive,
    required this.createdAt,
    required this.category,
    required this.questionCount,
    required this.icon,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    // Icon mapping logic if needed from string
    return QuizModel(
      id:            json['id'] ?? '',
      title:         json['title'] ?? '',
      isActive:      json['is_active'] ?? true,
      createdAt:     json['created_at'] ?? '',
      category:      json['category'] ?? 'Umumiy',
      questionCount: json['question_count'] ?? 0,
      icon:          Icons.assignment_outlined, // Default icon
    );
  }
}

// ── Question ──────────────────────────────────────────────────────────────────
class QuestionModel {
  final String id;
  final String questionText;
  final List<Map<String, String>> options;
  final String? imageUrl; // Savolga rasm qo'shish imkoniyati

  const QuestionModel({
    required this.id,
    required this.questionText,
    required this.options,
    this.imageUrl,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'] as List<dynamic>? ?? [];
    final opts = rawOptions
        .map((e) => Map<String, String>.from(
      (e as Map).map((k, v) => MapEntry(k.toString(), v.toString())),
    ))
        .toList();

    return QuestionModel(
      id:           json['id'] ?? '',
      questionText: json['question_text'] ?? '',
      options:      opts,
      imageUrl:     json['image_url'],
    );
  }

  List<MapEntry<String, String>> get optionEntries {
    return options.expand((map) => map.entries).toList();
  }
}

// ── Result ────────────────────────────────────────────────────────────────────
class ResultModel {
  final String resultId;
  final int correct;
  final int total;
  final double percentage;
  final String submittedAt;

  const ResultModel({
    required this.resultId,
    required this.correct,
    required this.total,
    required this.percentage,
    required this.submittedAt,
  });

  factory ResultModel.fromJson(Map<String, dynamic> json) => ResultModel(
    resultId:    json['result_id'] ?? '',
    correct:     json['correct'] ?? 0,
    total:       json['total'] ?? 0,
    percentage:  (json['percentage'] ?? 0).toDouble(),
    submittedAt: json['submitted_at'] ?? '',
  );

  bool get isPassed => percentage >= 60;
}

// ── Answer ────────────────────────────────────────────────────────────────────
class AnswerModel {
  final String questionId;
  final String selectedOption;

  const AnswerModel({
    required this.questionId,
    required this.selectedOption,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) => AnswerModel(
    questionId:    json['question_id'] ?? '',
    selectedOption: json['selected_option'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'question_id': questionId,
    'selected_option': selectedOption,
  };
}
