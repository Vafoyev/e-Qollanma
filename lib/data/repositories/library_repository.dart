import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/library_model.dart';
import '../../core/network/dio_client.dart';
import '../../core/constants/api_endpoints.dart';

class LibraryRepository {
  final Dio _dio;
  LibraryRepository(this._dio);

  Future<List<LibraryModel>> getBooks({
    String? lang,
    String? search,
  }) async {
    try {
      final res = await _dio.get(
        ApiEndpoints.library,
        queryParameters: {
          if (lang   != null && lang.isNotEmpty)   'lang':   lang,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );
      final list = res.data as List<dynamic>;
      return list
          .map((e) => LibraryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

final libraryRepositoryProvider = Provider<LibraryRepository>((ref) {
  return LibraryRepository(ref.watch(dioProvider));
});