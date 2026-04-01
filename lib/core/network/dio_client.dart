import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_interceptor.dart';

const String _baseUrl = 'https://your-api-domain.com/api/v1';
// TODO: production da o'zgartir

class DioClient {
  DioClient._();

  static Dio? _instance;

  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        responseType: ResponseType.json,
      ),
    );

    // Interceptorlar — tartib muhim
    dio.interceptors.addAll([
      ApiInterceptor(dio),       // 1. Token qo'shish / refresh
      PrettyDioLogger(           // 2. Debug logging (faqat debug mode)
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    ]);

    return dio;
  }
}

// ── Riverpod provider ─────────────────────────────────────────────────────────
final dioProvider = Provider<Dio>((ref) {
  return DioClient.instance;
});

// ── API xatoliklarni handle qilish ────────────────────────────────────────────
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;

  ApiException({
    required this.message,
    this.statusCode,
    this.errorCode,
  });

  factory ApiException.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return ApiException(
          message: 'Ulanish vaqti tugadi. Internet aloqasini tekshiring.',
          statusCode: 408,
        );
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'Internet aloqasi yo\'q.',
          statusCode: 503,
        );
      case DioExceptionType.badResponse:
        final data = e.response?.data;
        final msg  = data?['message'] ?? 'Serverda xatolik yuz berdi.';
        final code = data?['errorCode'];
        return ApiException(
          message: msg,
          statusCode: e.response?.statusCode,
          errorCode: code,
        );
      default:
        return ApiException(
          message: 'Kutilmagan xatolik yuz berdi.',
        );
    }
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}