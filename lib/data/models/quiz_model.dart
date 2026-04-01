// ── Quiz ──────────────────────────────────────────────────────────────────────
class QuizModel {
  final String id;
  final String title;
  final bool isActive;
  final String createdAt;

  const QuizModel({
    required this.id,
    required this.title,
    required this.isActive,
    required this.createdAt,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) => QuizModel(
    id:        json['id'] ?? '',
    title:     json['title'] ?? '',
    isActive:  json['is_active'] ?? true,
    createdAt: json['created_at'] ?? '',
  );
}

// ── Question ──────────────────────────────────────────────────────────────────
class QuestionModel {
  final String id;
  final String questionText;
  final List<Map<String, String>> options;

  const QuestionModel({
    required this.id,
    required this.questionText,
    required this.options,
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
    );
  }

  // [{"A": "Javob 1"}, {"B": "Javob 2"}] → [("A", "Javob 1"), ...]
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