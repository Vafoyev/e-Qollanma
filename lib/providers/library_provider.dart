import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/library_model.dart';
import '../data/repositories/library_repository.dart';

// ── Filter state ──────────────────────────────────────────────────────────────
class LibraryFilter {
  final String lang;
  final String search;

  const LibraryFilter({this.lang = '', this.search = ''});

  LibraryFilter copyWith({String? lang, String? search}) => LibraryFilter(
    lang:   lang   ?? this.lang,
    search: search ?? this.search,
  );
}

final libraryFilterProvider =
StateProvider<LibraryFilter>((ref) => const LibraryFilter());

// ── Book list ─────────────────────────────────────────────────────────────────
final bookListProvider = FutureProvider<List<LibraryModel>>((ref) async {
  final filter = ref.watch(libraryFilterProvider);
  return ref.watch(libraryRepositoryProvider).getBooks(
    lang:   filter.lang,
    search: filter.search,
  );
});