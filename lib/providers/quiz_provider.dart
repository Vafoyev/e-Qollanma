import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/quiz_model.dart';
import '../data/models/result_model.dart';
import '../data/repositories/quiz_repository.dart';

// ── Quiz list ─────────────────────────────────────────────────────────────────
final quizListProvider = FutureProvider<List<QuizModel>>((ref) async {
  return ref.watch(quizRepositoryProvider).getQuizzes();
});

// ── Quiz savollari (quizId bo'yicha) ──────────────────────────────────────────
final quizQuestionsProvider =
FutureProvider.family<List<QuestionModel>, String>((ref, quizId) async {
  return ref.watch(quizRepositoryProvider).getQuizQuestions(quizId);
});

// ── Foydalanuvchi tanlagan javoblar ───────────────────────────────────────────
// key: question_id, value: selected_option (masalan: "A")
final quizAnswersProvider =
StateProvider.family<Map<String, String>, String>((ref, quizId) => {});

// ── Submit natija ─────────────────────────────────────────────────────────────
final quizSubmitProvider =
FutureProvider.family<ResultModel, Map<String, dynamic>>(
        (ref, params) async {
      final quizId  = params['quizId'] as String;
      final answers = params['answers'] as List<Map<String, String>>;
      return ref.watch(quizRepositoryProvider).submitQuiz(
        quizId:  quizId,
        answers: answers,
      );
    });