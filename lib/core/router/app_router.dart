import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/splash/splash_screen.dart';
import '../../features/language/language_screen.dart';
import '../../features/onboarding/intro_screen.dart';
import '../../features/onboarding/authors_screen.dart';
import '../../features/onboarding/curriculum_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/home/main_screen.dart';
import '../../features/videos/video_detail_screen.dart';
import '../../features/library/book_detail_screen.dart';
import '../../features/quiz/quiz_screen.dart';
import '../../features/quiz/quiz_result_screen.dart';
import '../storage/prefs_storage.dart';
import '../storage/secure_storage.dart';

// ── Route names ──────────────────────────────────────────────────────────────
class AppRoutes {
  static const splash      = '/';
  static const language    = '/language';
  static const intro       = '/intro';
  static const authors     = '/authors';
  static const curriculum  = '/curriculum';
  static const login       = '/login';
  static const register    = '/register';
  static const home        = '/home';
  static const videoDetail = '/video/:id';
  static const bookDetail  = '/book/:id';
  static const quiz        = '/quiz/:id';
  static const quizResult  = '/quiz/:id/result';
}

// ── Router provider ───────────────────────────────────────────────────────────
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    redirect: (context, state) async {
      final isLoggedIn   = await SecureStorage.getAccessToken() != null;
      final onboardDone  = PrefsStorage.isOnboardDone();
      final path         = state.matchedLocation;

      // Splash — hech qanday redirect yo'q
      if (path == AppRoutes.splash) return null;

      // Til tanlanmagan bo'lsa
      if (PrefsStorage.getSavedLocale() == null) {
        return AppRoutes.language;
      }

      // Onboarding ko'rsatilmagan bo'lsa
      if (!onboardDone &&
          path != AppRoutes.intro &&
          path != AppRoutes.authors &&
          path != AppRoutes.curriculum) {
        return AppRoutes.intro;
      }

      // Login kerak bo'lgan sahifalarga kirmoqchi bo'lsa
      final protectedRoutes = [
        AppRoutes.home,
        '/video',
        '/book',
        '/quiz',
      ];
      final needsAuth = protectedRoutes.any((r) => path.startsWith(r));
      if (needsAuth && !isLoggedIn) return AppRoutes.login;

      // Login sahifasida bo'lib, allaqachon login qilgan bo'lsa
      if ((path == AppRoutes.login || path == AppRoutes.register) &&
          isLoggedIn) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.language,
        builder: (_, __) => const LanguageScreen(),
      ),
      GoRoute(
        path: AppRoutes.intro,
        builder: (_, __) => const IntroScreen(),
      ),
      GoRoute(
        path: AppRoutes.authors,
        builder: (_, __) => const AuthorsScreen(),
      ),
      GoRoute(
        path: AppRoutes.curriculum,
        builder: (_, __) => const CurriculumScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (_, __) => const MainScreen(),
      ),
      GoRoute(
        path: AppRoutes.videoDetail,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return VideoDetailScreen(videoId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.bookDetail,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return BookDetailScreen(bookId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.quiz,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return QuizScreen(quizId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.quizResult,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return QuizResultScreen(quizId: id);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          '404 — Sahifa topilmadi\n${state.error}',
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
});