import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../../core/network/dio_client.dart';
import '../../core/storage/secure_storage.dart';

class AuthRepository {
  final Dio _dio;
  AuthRepository(this._dio);

  // ── Register ──────────────────────────────────────────────────────────────
  Future<void> register({
    required String fullName,
    required String phone,
    required String password,
  }) async {
    try {
      await _dio.post('/auth/register', data: {
        'fullName': fullName,
        'phone':    phone,
        'password': password,
      });
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ── Login ─────────────────────────────────────────────────────────────────
  Future<UserModel> login({
    required String phone,
    required String password,
  }) async {
    try {
      final res = await _dio.post('/auth/login', data: {
        'phone':    phone,
        'password': password,
      });

      final accessToken  = res.data['access_token'];
      final refreshToken = res.data['refresh_token'];

      await SecureStorage.saveAccessToken(accessToken);
      await SecureStorage.saveRefreshToken(refreshToken);

      return UserModel.fromJson(res.data['user']);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ── Profile ───────────────────────────────────────────────────────────────
  Future<UserModel> getProfile() async {
    try {
      final res = await _dio.get('/auth/profile');
      return UserModel.fromJson(res.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ── My results ────────────────────────────────────────────────────────────
  Future<List<dynamic>> getMyResults() async {
    try {
      final res = await _dio.get('/auth/my-results');
      return res.data as List;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ── Logout ────────────────────────────────────────────────────────────────
  Future<void> logout() async {
    try {
      final refreshToken = await SecureStorage.getRefreshToken();
      await _dio.post('/auth/logout', data: {
        'refresh_token': refreshToken,
      });
    } catch (_) {
      // Logout da xatolik bo'lsa ham local tokenlarni o'chiramiz
    } finally {
      await SecureStorage.clearAll();
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(dioProvider));
});