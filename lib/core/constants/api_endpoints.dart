class ApiEndpoints {
  ApiEndpoints._();

  // ── Auth ──────────────────────────────────────────────────────────────────
  static const String register    = '/auth/register';
  static const String login       = '/auth/login';
  static const String adminLogin  = '/auth/admin/login';
  static const String refresh     = '/auth/refresh';
  static const String profile     = '/auth/profile';
  static const String myResults   = '/auth/my-results';
  static const String logout      = '/auth/logout';

  // ── Student ───────────────────────────────────────────────────────────────
  static const String library     = '/student/library';
  static const String videos      = '/student/videos';
  static const String quizzes     = '/student/quizzes';

  static String quizById(String id)     => '/student/quizzes/$id';
  static String submitQuiz(String id)   => '/student/quizzes/$id/submit';
  static String bookById(String id)     => '/student/library/$id';

  // ── Config ────────────────────────────────────────────────────────────────
  static const String checkVersion = '/config/check-version';

  // ── Health ────────────────────────────────────────────────────────────────
  static const String health       = '/health';
}