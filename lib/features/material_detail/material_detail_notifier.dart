import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/material_repository.dart';
import '../home/home_notifier.dart';
import '../library/library_notifier.dart';
import '../stats/stats_notifier.dart';
import 'material_detail_state.dart';

part 'material_detail_notifier.g.dart';

@riverpod
class MaterialDetailNotifier extends _$MaterialDetailNotifier {
  @override
  Future<MaterialDetailState> build(String materialId) async {
    final repository = ref.watch(materialRepositoryProvider);
    final material = await repository.getMaterialById(materialId);
    if (material == null) {
      throw Exception('Material not found');
    }
    final chapters = await repository.getChapters(materialId);
    final firstIncomplete = await repository.getFirstIncompleteChapter(materialId);
    return MaterialDetailState(
      material: material,
      chapters: chapters,
      activeChapterId: firstIncomplete?.id,
    );
  }

  Future<void> toggleChapter(String chapterId) async {
    final current = state.valueOrNull;
    if (current == null) return;
    await ref.read(materialRepositoryProvider).toggleChapterCompletion(
          materialId: current.material.id,
          chapterId: chapterId,
        );
    ref.invalidateSelf();
    state = await AsyncValue.guard(() => build(current.material.id));
  }

  Future<void> addNote({
    required String chapterId,
    required String note,
  }) async {
    final current = state.valueOrNull;
    if (current == null || note.trim().isEmpty) return;
    await ref.read(materialRepositoryProvider).addChapterNote(
          chapterId: chapterId,
          note: note.trim(),
        );
    ref.invalidateSelf();
    state = await AsyncValue.guard(() => build(current.material.id));
  }

  Future<void> deleteMaterial() async {
    final current = state.valueOrNull;
    if (current == null) return;
    await ref.read(materialRepositoryProvider).deleteMaterial(current.material.id);
    ref.invalidate(homeNotifierProvider);
    ref.invalidate(libraryNotifierProvider);
    ref.invalidate(statsNotifierProvider);
    ref.invalidateSelf();
  }
}
