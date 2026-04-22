import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/utils/chapter_tree.dart';
import '../../core/providers/shared_preferences_provider.dart';
import '../../data/repositories/material_repository.dart';
import '../../data/repositories/session_repository.dart';
import '../../domain/models/chapter.dart';
import '../home/home_notifier.dart';
import '../library/library_notifier.dart';
import '../material_detail/material_detail_notifier.dart';
import '../stats/stats_notifier.dart';
import 'session_state.dart';

part 'session_notifier.g.dart';

@riverpod
class SessionNotifier extends _$SessionNotifier {
  @override
  Future<SessionViewState> build({
    String? materialId,
    String? chapterId,
  }) async {
    final materialRepository = ref.watch(materialRepositoryProvider);
    final materials = await materialRepository.getInProgress(limit: 50);
    final fallbackMaterialId = materials.any((material) => material.id == materialId)
        ? materialId
        : (materials.isNotEmpty ? materials.first.id : null);
    final chapters = fallbackMaterialId == null
        ? <Chapter>[]
        : await materialRepository.getChapters(fallbackMaterialId);
    final chapterTree = ChapterTree.fromChapters(chapters);
    final prefs = ref.watch(sharedPreferencesProvider);

    return SessionViewState(
      materials: materials,
      chapters: chapters,
      selectedMaterialId: fallbackMaterialId,
      selectedChapterId: chapterId == null ? null : chapterTree.normalizeToLeafId(chapterId),
      durationMinutes: prefs.getInt('default_session_minutes') ?? 25,
    );
  }

  Future<void> selectMaterial(String? materialId) async {
    final current = state.valueOrNull;
    if (current == null || materialId == null) return;
    final chapters = await ref.read(materialRepositoryProvider).getChapters(materialId);
    state = AsyncData(
      current.copyWith(
        selectedMaterialId: materialId,
        selectedChapterId: null,
        chapters: chapters,
      ),
    );
  }

  void selectChapter(String? chapterId) {
    final current = state.valueOrNull;
    if (current == null) return;
    final chapterTree = ChapterTree.fromChapters(current.chapters);
    state = AsyncData(
      current.copyWith(
        selectedChapterId: chapterId == null ? null : chapterTree.normalizeToLeafId(chapterId),
      ),
    );
  }

  void setDuration(int minutes) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(durationMinutes: minutes));
  }

  Future<void> startSession() async {
    final current = state.valueOrNull;
    if (current == null || current.selectedMaterialId == null) return;
    if (current.chapters.isNotEmpty && current.selectedChapterId == null) return;
    final session = await ref.read(sessionRepositoryProvider).startSession(
          materialId: current.selectedMaterialId!,
          chapterId: current.selectedChapterId,
          durationSeconds: current.durationMinutes * 60,
        );
    state = AsyncData(current.copyWith(activeSessionId: session.id));
  }

  Future<void> completeSession({required int actualDurationSeconds}) async {
    final current = state.valueOrNull;
    if (current == null || current.activeSessionId == null) return;
    await ref.read(sessionRepositoryProvider).completeSession(
          sessionId: current.activeSessionId!,
          actualDurationSeconds: actualDurationSeconds,
        );
    ref.invalidate(homeNotifierProvider);
    ref.invalidate(statsNotifierProvider);
    ref.invalidate(libraryNotifierProvider);
  }

  Future<void> abandonSession() async {
    final current = state.valueOrNull;
    if (current == null || current.activeSessionId == null) return;
    await ref.read(sessionRepositoryProvider).abandonSession(current.activeSessionId!);
  }

  Future<void> markSelectedChapterDone() async {
    final current = state.valueOrNull;
    if (current == null || current.selectedMaterialId == null || current.selectedChapterId == null) {
      return;
    }
    await ref.read(materialRepositoryProvider).toggleChapterCompletion(
          materialId: current.selectedMaterialId!,
          chapterId: current.selectedChapterId!,
          completed: true,
        );
    ref.invalidate(libraryNotifierProvider);
    ref.invalidate(statsNotifierProvider);
    ref.invalidate(homeNotifierProvider);
    ref.invalidate(materialDetailNotifierProvider(current.selectedMaterialId!));
  }
}
