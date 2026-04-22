import '../../domain/enums/material_type.dart';
import '../../domain/models/material.dart';

enum LibraryFilter {
  all,
  books,
  videos,
  audio,
  courses;

  String get label => switch (this) {
        LibraryFilter.all => 'All',
        LibraryFilter.books => 'Books',
        LibraryFilter.videos => 'Videos',
        LibraryFilter.audio => 'Audio',
        LibraryFilter.courses => 'Courses',
      };

  MaterialType? get type => switch (this) {
        LibraryFilter.all => null,
        LibraryFilter.books => MaterialType.book,
        LibraryFilter.videos => MaterialType.video,
        LibraryFilter.audio => MaterialType.audio,
        LibraryFilter.courses => MaterialType.course,
      };
}

class LibraryState {
  const LibraryState({
    required this.filter,
    required this.searchQuery,
    required this.materials,
  });

  final LibraryFilter filter;
  final String searchQuery;
  final List<StudyMaterial> materials;

  LibraryState copyWith({
    LibraryFilter? filter,
    String? searchQuery,
    List<StudyMaterial>? materials,
  }) {
    return LibraryState(
      filter: filter ?? this.filter,
      searchQuery: searchQuery ?? this.searchQuery,
      materials: materials ?? this.materials,
    );
  }
}
