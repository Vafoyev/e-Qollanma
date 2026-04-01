import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/video_model.dart';
import '../data/repositories/video_repository.dart';

final videoListProvider = FutureProvider<List<VideoModel>>((ref) async {
  return ref.watch(videoRepositoryProvider).getVideos();
});