import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/quiz_model.dart';

class QuizRepository {
  QuizRepository();

  // Faol testlar ro'yxati
  Future<List<QuizModel>> getQuizzes() async {
    // Real API ga so'rov (Hozircha mock data qaytarish uchun)
    // final res  = await _dio.get(ApiEndpoints.quizzes);
    // return (res.data as List).map((e) => QuizModel.fromJson(e)).toList();
    
    // Mock data — server tayyor bo'lganda API ga almashtiriladi
    return [];
  }

  // Savollari (to'g'ri javobsiz)
  Future<List<QuestionModel>> getQuizQuestions(String quizId) async {
    // Real API ga so'rov
    // final res  = await _dio.get(ApiEndpoints.quizById(quizId));
    // return (res.data as List).map((e) => QuestionModel.fromJson(e)).toList();
    
    // Mock data
    return [];
  }

  // Testni topshirish
  Future<ResultModel> submitQuiz({
    required String quizId,
    required List<AnswerModel> answers,
  }) async {
    try {
      // Real topshirish:
      // final res = await _dio.post(ApiEndpoints.submitQuiz(quizId), data: ...);
      
      // MOCK NATIJA (Server ulanmaguncha):
      await Future.delayed(const Duration(seconds: 1));
      final correctCount = (answers.length * 0.8).round(); // Taxminiy 80% to'g'ri
      
      return ResultModel(
        resultId: 'mock_res_${DateTime.now().millisecondsSinceEpoch}',
        correct: correctCount,
        total: answers.length,
        percentage: (correctCount / answers.length) * 100,
        submittedAt: DateTime.now().toIso8601String(),
      );
    } catch (e) {
      rethrow;
    }
  }
}

final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  return QuizRepository();
});
