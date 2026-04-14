import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/quiz_model.dart';
import '../../core/network/dio_client.dart';
import '../../core/constants/api_endpoints.dart';

class QuizRepository {
  final Dio _dio;
  QuizRepository(this._dio);

  // Faol testlar ro'yxati
  Future<List<QuizModel>> getQuizzes() async {
    try {
      // Real API ga so'rov (Hozircha error bo'lsa mock data qaytarish uchun try-catch ichida)
      // final res  = await _dio.get(ApiEndpoints.quizzes);
      // ...
      throw DioException(requestOptions: RequestOptions(path: ApiEndpoints.quizzes));
    } catch (e) {
      // Mock data provider orqali keladi, bu yerda faqat metod strukturasi uchun
      rethrow;
    }
  }

  // Savollari (to'g'ri javobsiz)
  Future<List<QuestionModel>> getQuizQuestions(String quizId) async {
    try {
      // final res  = await _dio.get(ApiEndpoints.quizById(quizId));
      throw DioException(requestOptions: RequestOptions(path: ''));
    } catch (e) {
      rethrow;
    }
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
  return QuizRepository(ref.watch(dioProvider));
});
