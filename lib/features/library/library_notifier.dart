import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/material_repository.dart';
import 'library_state.dart';

part 'library_notifier.g.dart';

@riverpod
class LibraryNotifier extends _$LibraryNotifier {
  LibraryFilter _filter = LibraryFilter.all;
  String _search = '';

  @override
  Future<LibraryState> build() async {
    final materials = await ref.watch(materialRepositoryProvider).getAllMaterials(
          filter: _filter.type,
          search: _search,
        );
    return LibraryState(
      filter: _filter,
      searchQuery: _search,
      materials: materials,
    );
  }

  Future<void> setFilter(LibraryFilter filter) async {
    _filter = filter;
    ref.invalidateSelf();
    state = await AsyncValue.guard(build);
  }

  Future<void> setSearch(String search) async {
    _search = search;
    ref.invalidateSelf();
    state = await AsyncValue.guard(build);
  }
}
