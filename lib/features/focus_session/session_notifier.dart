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
    final fallbackMaterialId =
        materials.any((material) => material.id == materialId)
        ? materialId
        : (materials.isNotEmpty ? materials.first.id : null);
    final chapters = fallbackMaterialId == null
        ? <Chapter>[]
        : await materialRepository.getChapters(fallbackMaterialId);
    final chapterTree = ChapterTree.fromChapters(chapters);
    final initialChapterId = chapterTree.normalizeToLeafId(chapterId);
    final prefs = ref.watch(sharedPreferencesProvider);

    return SessionViewState(
      materials: materials,
      chapters: chapters,
      selectedMaterialId: fallbackMaterialId,
      selectedChapterId: initialChapterId,
      queuedChapterIds: initialChapterId == null
          ? const []
          : [initialChapterId],
      durationMinutes: prefs.getInt('default_session_minutes') ?? 25,
    );
  }

  Future<void> selectMaterial(String? materialId) async {
    final current = state.valueOrNull;
    if (current == null || materialId == null) return;
    final chapters = await ref
        .read(materialRepositoryProvider)
        .getChapters(materialId);
    final chapterTree = ChapterTree.fromChapters(chapters);
    final initialChapterId = chapterTree.normalizeToLeafId(null);
    state = AsyncData(
      current.copyWith(
        selectedMaterialId: materialId,
        selectedChapterId: initialChapterId,
        queuedChapterIds: initialChapterId == null
            ? const []
            : [initialChapterId],
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
        selectedChapterId: chapterId == null
            ? null
            : chapterTree.normalizeToLeafId(chapterId),
      ),
    );
  }

  void toggleQueuedChapter(String chapterId) {
    final current = state.valueOrNull;
    if (current == null) return;

    final chapterTree = ChapterTree.fromChapters(current.chapters);
    final normalizedChapterId = chapterTree.normalizeToLeafId(chapterId);
    if (normalizedChapterId == null) return;

    final queue = [...current.queuedChapterIds];
    final existingIndex = queue.indexOf(normalizedChapterId);
    if (existingIndex >= 0) {
      queue.removeAt(existingIndex);
    } else {
      queue.add(normalizedChapterId);
      final orderedLeafIds = chapterTree
          .leafChapters()
          .map((chapter) => chapter.id)
          .toList(growable: false);
      queue.sort(
        (a, b) =>
            orderedLeafIds.indexOf(a).compareTo(orderedLeafIds.indexOf(b)),
      );
    }

    final nextSelectedChapterId = switch ((
      existingIndex >= 0,
      current.selectedChapterId == normalizedChapterId,
    )) {
      (true, true) => queue.isEmpty ? null : queue.first,
      (true, false) => current.selectedChapterId,
      _ => normalizedChapterId,
    };

    state = AsyncData(
      current.copyWith(
        selectedChapterId: nextSelectedChapterId,
        queuedChapterIds: queue,
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
    if (current.chapters.isNotEmpty && current.currentQueuedChapterId == null) {
      return;
    }
    final session = await ref
        .read(sessionRepositoryProvider)
        .startSession(
          materialId: current.selectedMaterialId!,
          chapterId: current.currentQueuedChapterId,
          durationSeconds: current.durationMinutes * 60,
        );
    state = AsyncData(current.copyWith(activeSessionId: session.id));
  }

  Future<void> completeSession({required int actualDurationSeconds}) async {
    final current = state.valueOrNull;
    if (current == null || current.activeSessionId == null) return;
    await ref
        .read(sessionRepositoryProvider)
        .completeSession(
          sessionId: current.activeSessionId!,
          actualDurationSeconds: actualDurationSeconds,
        );
    state = AsyncData(current.copyWith(activeSessionId: null));
    ref.invalidate(homeNotifierProvider);
    ref.invalidate(statsNotifierProvider);
    ref.invalidate(libraryNotifierProvider);
  }

  Future<void> abandonSession() async {
    final current = state.valueOrNull;
    if (current == null || current.activeSessionId == null) return;
    await ref
        .read(sessionRepositoryProvider)
        .abandonSession(current.activeSessionId!);
    state = AsyncData(current.copyWith(activeSessionId: null));
  }

  Future<void> markCurrentQueueItemDone() async {
    final currentChapterId = state.valueOrNull?.currentQueuedChapterId;
    if (currentChapterId == null) {
      return;
    }
    await markQueuedChapterDone(currentChapterId);
  }

  Future<void> markQueuedChapterDone(String chapterId) async {
    final current = state.valueOrNull;
    if (current == null || current.selectedMaterialId == null) {
      return;
    }
    final chapterTree = ChapterTree.fromChapters(current.chapters);
    final normalizedChapterId = chapterTree.normalizeToLeafId(chapterId);
    if (normalizedChapterId == null ||
        !current.queuedChapterIds.contains(normalizedChapterId)) {
      return;
    }

    final materialRepository = ref.read(materialRepositoryProvider);
    await materialRepository.toggleChapterCompletion(
      materialId: current.selectedMaterialId!,
      chapterId: normalizedChapterId,
      completed: true,
    );
    final updatedMaterial = await materialRepository.getMaterialById(
      current.selectedMaterialId!,
    );
    final updatedChapters = await materialRepository.getChapters(
      current.selectedMaterialId!,
    );
    final availableChapterIds = {
      for (final chapter in updatedChapters)
        if (!chapter.isCompleted) chapter.id,
    };
    final remainingQueue = current.queuedChapterIds
        .where(
          (chapterId) =>
              chapterId != normalizedChapterId &&
              availableChapterIds.contains(chapterId),
        )
        .toList(growable: false);
    final nextSelectedChapterId =
        remainingQueue.contains(current.selectedChapterId)
        ? current.selectedChapterId
        : (remainingQueue.isEmpty ? null : remainingQueue.first);
    final updatedMaterials = updatedMaterial == null
        ? current.materials
        : current.materials
              .map(
                (material) => material.id == updatedMaterial.id
                    ? updatedMaterial
                    : material,
              )
              .toList(growable: false);
    state = AsyncData(
      current.copyWith(
        materials: updatedMaterials,
        chapters: updatedChapters,
        selectedChapterId: nextSelectedChapterId,
        queuedChapterIds: remainingQueue,
      ),
    );
    ref.invalidate(libraryNotifierProvider);
    ref.invalidate(statsNotifierProvider);
    ref.invalidate(homeNotifierProvider);
    ref.invalidate(materialDetailNotifierProvider(current.selectedMaterialId!));
  }
}
