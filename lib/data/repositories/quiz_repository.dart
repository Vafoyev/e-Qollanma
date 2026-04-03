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
      final res  = await _dio.get(ApiEndpoints.quizzes);
      final list = res.data as List<dynamic>;
      return list
          .map((e) => QuizModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // Savollari (to'g'ri javobsiz)
  Future<List<QuestionModel>> getQuizQuestions(String quizId) async {
    try {
      final res  = await _dio.get(ApiEndpoints.quizById(quizId));
      final list = res.data as List<dynamic>;
      return list
          .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // Testni topshirish
  Future<ResultModel> submitQuiz({
    required String quizId,
    required List<AnswerModel> answers,
  }) async {
    try {
      final res = await _dio.post(
        ApiEndpoints.submitQuiz(quizId),
        data: {
          'answers': answers.map((a) => a.toJson()).toList(),
        },
      );
      return ResultModel.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  return QuizRepository(ref.watch(dioProvider));
});