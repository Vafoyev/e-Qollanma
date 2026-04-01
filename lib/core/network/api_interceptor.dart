import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';

class ApiInterceptor extends Interceptor {
  final Dio dio;

  ApiInterceptor(this.dio);

  // ── Request — har so'rovga token qo'shish ─────────────────────────────────
  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final token = await SecureStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  // ── Response — oddiy o'tkazish ────────────────────────────────────────────
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  // ── Error — 401 bo'lsa token yangilash ───────────────────────────────────
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshed = await _refreshToken();
      if (refreshed) {
        // Eski so'rovni yangi token bilan qayta yuborish
        final opts = err.requestOptions;
        final newToken = await SecureStorage.getAccessToken();
        opts.headers['Authorization'] = 'Bearer $newToken';

        try {
          final response = await dio.fetch(opts);
          handler.resolve(response);
          return;
        } catch (e) {
          // Refresh ham ishlamadi — logout
          await _logout();
        }
      } else {
        await _logout();
      }
    }
    handler.next(err);
  }

  // ── Token yangilash ───────────────────────────────────────────────────────
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await SecureStorage.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
        options: Options(
          // Interceptor chaqirilmasin
          extra: {'skipInterceptor': true},
        ),
      );

      final newAccessToken  = response.data['access_token'];
      final newRefreshToken = response.data['refresh_token'];

      if (newAccessToken != null) {
        await SecureStorage.saveAccessToken(newAccessToken);
      }
      if (newRefreshToken != null) {
        await SecureStorage.saveRefreshToken(newRefreshToken);
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  // ── Logout (tokenlar o'chirilib, login sahifaga) ──────────────────────────
  Future<void> _logout() async {
    await SecureStorage.clearAll();
    // Router redirect o'zi hal qiladi — token yo'q bo'lsa login ga ketadi
  }
}