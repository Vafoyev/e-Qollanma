class VideoModel {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String? thumbnailUrl;
  final bool isYoutube;
  final String createdAt;

  const VideoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    this.thumbnailUrl,
    required this.isYoutube,
    required this.createdAt,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
    id:           json['id'] ?? '',
    title:        json['title'] ?? '',
    description:  json['description'] ?? '',
    videoUrl:     json['video_url'] ?? '',
    thumbnailUrl: json['thumbnail_url'],
    isYoutube:    json['is_youtube'] ?? false,
    createdAt:    json['created_at'] ?? '',
  );

  // YouTube video ID ni ajratish
  String? get youtubeId {
    if (!isYoutube) return null;
    final uri = Uri.tryParse(videoUrl);
    if (uri == null) return null;
    // https://youtu.be/ID yoki https://youtube.com/watch?v=ID
    if (uri.host.contains('youtu.be')) return uri.pathSegments.first;
    return uri.queryParameters['v'];
  }
}