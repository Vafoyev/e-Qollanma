class LibraryModel {
  final String id;
  final String title;
  final String author;
  final String language;
  final String fileUrl;
  final String? coverUrl;
  final String createdAt;

  const LibraryModel({
    required this.id,
    required this.title,
    required this.author,
    required this.language,
    required this.fileUrl,
    this.coverUrl,
    required this.createdAt,
  });

  factory LibraryModel.fromJson(Map<String, dynamic> json) => LibraryModel(
    id:        json['id'] ?? '',
    title:     json['title'] ?? '',
    author:    json['author'] ?? '',
    language:  json['language'] ?? 'uz',
    fileUrl:   json['file_url'] ?? '',
    coverUrl:  json['cover_url'],
    createdAt: json['created_at'] ?? '',
  );

  String get languageLabel {
    switch (language) {
      case 'uz': return "O'zbek";
      case 'ru': return 'Русский';
      case 'en': return 'English';
      default:   return language;
    }
  }
}