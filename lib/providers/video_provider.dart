import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/video_model.dart';

final videoListProvider = FutureProvider<List<VideoModel>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 800));

  return [
    const VideoModel(
      id: '1',
      title: 'Nuqta va to\'g\'ri chiziq proyeksiyasi',
      description: 'Chizmachilik asoslari: Nuqtaning uchta tekislikdagi proyeksiyasini qurish usullari.',
      videoUrl: 'https://www.youtube.com/watch?v=Ks-_Mh1QhMc',
      thumbnailUrl: 'https://img.youtube.com/vi/Ks-_Mh1QhMc/hqdefault.jpg',
      isYoutube: true,
      createdAt: '2024-03-20',
      topic: 'Geometrik chizmachilik',
      duration: '12:45',
    ),
    const VideoModel(
      id: '2',
      title: 'Burchaklarni teng bo\'lish',
      description: 'Sirkul yordamida ixtiyoriy burchakni teng ikkiga va uchga bo\'lish algoritmi.',
      videoUrl: 'https://www.youtube.com/watch?v=8Ush6L8A-No',
      thumbnailUrl: 'https://img.youtube.com/vi/8Ush6L8A-No/hqdefault.jpg',
      isYoutube: true,
      createdAt: '2024-03-21',
      topic: 'Geometrik chizmachilik',
      duration: '08:30',
    ),
    const VideoModel(
      id: '3',
      title: 'Aksonometrik proyeksiyalar',
      description: 'Izometriya va dimetriya. Detallarning yaqqol tasvirlarini qurish qoidalari.',
      videoUrl: 'https://www.youtube.com/watch?v=q_X0p_P_x_Y',
      thumbnailUrl: 'https://img.youtube.com/vi/q_X0p_P_x_Y/hqdefault.jpg',
      isYoutube: true,
      createdAt: '2024-03-22',
      topic: 'Proyeksion chizmachilik',
      duration: '15:20',
    ),
    const VideoModel(
      id: '4',
      title: 'Kesim va qirqimlar farqi',
      description: 'Chizmalarda qirqimlarni belgilash va ularni bajarish tartibi haqida batafsil.',
      videoUrl: 'https://www.youtube.com/watch?v=LpG4O7tPZ3U',
      thumbnailUrl: 'https://img.youtube.com/vi/LpG4O7tPZ3U/hqdefault.jpg',
      isYoutube: true,
      createdAt: '2024-03-23',
      topic: 'Proyeksion chizmachilik',
      duration: '18:10',
    ),
  ];
});

final selectedTopicProvider = StateProvider<String>((ref) => 'Barchasi');

final filteredVideoListProvider = Provider<AsyncValue<List<VideoModel>>>((ref) {
  final videosAsync = ref.watch(videoListProvider);
  final selectedTopic = ref.watch(selectedTopicProvider);

  return videosAsync.whenData((videos) {
    if (selectedTopic == 'Barchasi') return videos;
    return videos.where((v) => v.topic == selectedTopic).toList();
  });
});
