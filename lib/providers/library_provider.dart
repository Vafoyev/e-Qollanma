import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/library_model.dart';

final libraryListProvider = FutureProvider<List<LibraryModel>>((ref) async {
  // Simulyatsiya
  await Future.delayed(const Duration(milliseconds: 800));

  return [
    const LibraryModel(
      id: '1',
      title: 'Chizmachilik (9-sinf)',
      author: 'A. Hamdamov, I. Rahmonov',
      language: 'uz',
      fileUrl: 'https://example.com/book1.pdf',
      coverUrl: 'https://anysoft.uz/storage/covers/1/325_cover.jpg',
      createdAt: '2024-01-10',
      type: LibraryType.book,
      category: 'Darsliklar',
      size: '15.2 MB',
    ),
    const LibraryModel(
      id: '2',
      title: 'Muhandislik grafikasi asoslari',
      author: 'S. Ismatullayev',
      language: 'uz',
      fileUrl: 'https://example.com/book2.pdf',
      coverUrl: 'https://ziyonet.uz/uploads/books/2021/05/60a22f3e8b4e4.jpg',
      createdAt: '2024-02-15',
      type: LibraryType.book,
      category: 'Darsliklar',
      size: '8.4 MB',
    ),
    const LibraryModel(
      id: '3',
      title: 'Geometrik yasashlar (PPT)',
      author: 'Kafedra o\'qituvchilari',
      language: 'uz',
      fileUrl: 'https://example.com/pres1.pptx',
      coverUrl: 'https://img.freepik.com/free-vector/presentation-concept-illustration_114360-2441.jpg',
      createdAt: '2024-03-01',
      type: LibraryType.presentation,
      category: 'Taqdimotlar',
      size: '4.1 MB',
    ),
    const LibraryModel(
      id: '4',
      title: 'Chizmalarni rasmiylashtirish',
      author: 'GOST standartlari',
      language: 'uz',
      fileUrl: 'https://example.com/doc1.pdf',
      coverUrl: 'https://img.freepik.com/free-vector/modern-professional-document-template_1017-7681.jpg',
      createdAt: '2024-03-05',
      type: LibraryType.lecture,
      category: 'Ma\'ruzalar',
      size: '1.2 MB',
    ),
    const LibraryModel(
      id: '5',
      title: 'Loyiha ishi: Mashina detallari',
      author: 'Talaba loyihasi',
      language: 'uz',
      fileUrl: 'https://example.com/project1.pdf',
      coverUrl: 'https://img.freepik.com/free-vector/architect-concept-illustration_114360-1416.jpg',
      createdAt: '2024-03-12',
      type: LibraryType.doc,
      category: 'Loyihalar',
      size: '12.0 MB',
    ),
  ];
});

final selectedLibraryCategoryProvider = StateProvider<String>((ref) => 'Barchasi');
final librarySearchQueryProvider = StateProvider<String>((ref) => '');

final filteredLibraryListProvider = Provider<AsyncValue<List<LibraryModel>>>((ref) {
  final listAsync = ref.watch(libraryListProvider);
  final selectedCategory = ref.watch(selectedLibraryCategoryProvider);
  final searchQuery = ref.watch(librarySearchQueryProvider).toLowerCase();

  return listAsync.whenData((list) {
    return list.where((item) {
      final matchesCategory = selectedCategory == 'Barchasi' || item.category == selectedCategory;
      final matchesSearch = item.title.toLowerCase().contains(searchQuery) || 
                          item.author.toLowerCase().contains(searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();
  });
});
