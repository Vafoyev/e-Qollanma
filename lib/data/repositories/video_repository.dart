import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/video_model.dart';
import '../../core/network/dio_client.dart';
import '../../core/constants/api_endpoints.dart';

class VideoRepository {
  final Dio _dio;
  VideoRepository(this._dio);

  Future<List<VideoModel>> getVideos() async {
    try {
      final res  = await _dio.get(ApiEndpoints.videos);
      final list = res.data as List<dynamic>;
      return list
          .map((e) => VideoModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

final videoRepositoryProvider = Provider<VideoRepository>((ref) {
  return VideoRepository(ref.watch(dioProvider));
});