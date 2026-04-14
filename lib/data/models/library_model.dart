enum LibraryType { book, presentation, doc, lecture }

class LibraryModel {
  final String id;
  final String title;
  final String author;
  final String language;
  final String fileUrl;
  final String? coverUrl;
  final String createdAt;
  final LibraryType type;
  final String category; // Masalan: "Geometriya", "Mashinasozlik"
  final String size; // Masalan: "2.4 MB"

  const LibraryModel({
    required this.id,
    required this.title,
    required this.author,
    required this.language,
    required this.fileUrl,
    this.coverUrl,
    required this.createdAt,
    required this.type,
    required this.category,
    required this.size,
  });

  factory LibraryModel.fromJson(Map<String, dynamic> json) {
    LibraryType type = LibraryType.book;
    switch (json['type']) {
      case 'presentation': type = LibraryType.presentation; break;
      case 'doc':          type = LibraryType.doc; break;
      case 'lecture':      type = LibraryType.lecture; break;
    }

    return LibraryModel(
      id:        json['id'] ?? '',
      title:     json['title'] ?? '',
      author:    json['author'] ?? '',
      language:  json['language'] ?? 'uz',
      fileUrl:   json['file_url'] ?? '',
      coverUrl:  json['cover_url'],
      createdAt: json['created_at'] ?? '',
      type:      type,
      category:  json['category'] ?? 'Umumiy',
      size:      json['size'] ?? '0 MB',
    );
  }

  String get languageLabel {
    switch (language) {
      case 'uz': return "O'zbek";
      case 'ru': return 'Русский';
      case 'en': return 'English';
      default:   return language;
    }
  }

  String get typeLabel {
    switch (type) {
      case LibraryType.book:         return "Darslik";
      case LibraryType.presentation: return "Taqdimot";
      case LibraryType.doc:          return "Hujjat";
      case LibraryType.lecture:      return "Ma'ruza";
    }
  }
}
