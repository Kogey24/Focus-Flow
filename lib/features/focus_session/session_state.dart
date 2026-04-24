import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/chapter.dart';
import '../../domain/models/material.dart';

enum SessionTimerStatus { idle, running, paused, completed }

class SessionViewState {
  static const _unset = Object();

  const SessionViewState({
    required this.materials,
    required this.chapters,
    required this.selectedMaterialId,
    required this.selectedChapterId,
    required this.queuedChapterIds,
    required this.durationMinutes,
    this.activeSessionId,
  });

  final List<StudyMaterial> materials;
  final List<Chapter> chapters;
  final String? selectedMaterialId;
  final String? selectedChapterId;
  final List<String> queuedChapterIds;
  final int durationMinutes;
  final String? activeSessionId;

  String? get currentQueuedChapterId =>
      queuedChapterIds.isEmpty ? null : queuedChapterIds.first;

  SessionViewState copyWith({
    List<StudyMaterial>? materials,
    List<Chapter>? chapters,
    Object? selectedMaterialId = _unset,
    Object? selectedChapterId = _unset,
    List<String>? queuedChapterIds,
    int? durationMinutes,
    Object? activeSessionId = _unset,
  }) {
    return SessionViewState(
      materials: materials ?? this.materials,
      chapters: chapters ?? this.chapters,
      selectedMaterialId: selectedMaterialId == _unset
          ? this.selectedMaterialId
          : selectedMaterialId as String?,
      selectedChapterId: selectedChapterId == _unset
          ? this.selectedChapterId
          : selectedChapterId as String?,
      queuedChapterIds: queuedChapterIds ?? this.queuedChapterIds,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      activeSessionId: activeSessionId == _unset
          ? this.activeSessionId
          : activeSessionId as String?,
    );
  }
}

class SessionTimerState {
  const SessionTimerState({
    required this.total,
    required this.remaining,
    required this.status,
  });

  final Duration total;
  final Duration remaining;
  final SessionTimerStatus status;

  Duration get elapsed => total - remaining;
}

class SessionTimerController extends StateNotifier<SessionTimerState> {
  SessionTimerController()
    : super(
        const SessionTimerState(
          total: Duration.zero,
          remaining: Duration.zero,
          status: SessionTimerStatus.idle,
        ),
      );

  Ticker? _ticker;
  DateTime? _targetEnd;
  VoidCallback? _onComplete;

  void start(Duration total, {VoidCallback? onComplete}) {
    _onComplete = onComplete;
    _targetEnd = DateTime.now().add(total);
    state = SessionTimerState(
      total: total,
      remaining: total,
      status: SessionTimerStatus.running,
    );
    _ticker?.dispose();
    _ticker = Ticker(_handleTick)..start();
  }

  void pause() {
    if (state.status != SessionTimerStatus.running) return;
    _ticker?.stop();
    state = SessionTimerState(
      total: state.total,
      remaining: state.remaining,
      status: SessionTimerStatus.paused,
    );
  }

  void resume() {
    if (state.status != SessionTimerStatus.paused) return;
    _targetEnd = DateTime.now().add(state.remaining);
    _ticker?.dispose();
    _ticker = Ticker(_handleTick)..start();
    state = SessionTimerState(
      total: state.total,
      remaining: state.remaining,
      status: SessionTimerStatus.running,
    );
  }

  void reset() {
    _ticker?.dispose();
    _ticker = null;
    _targetEnd = null;
    _onComplete = null;
    state = const SessionTimerState(
      total: Duration.zero,
      remaining: Duration.zero,
      status: SessionTimerStatus.idle,
    );
  }

  void _handleTick(Duration elapsed) {
    if (_targetEnd == null) return;
    final remaining = _targetEnd!.difference(DateTime.now());
    if (remaining <= Duration.zero) {
      _ticker?.stop();
      state = SessionTimerState(
        total: state.total,
        remaining: Duration.zero,
        status: SessionTimerStatus.completed,
      );
      _onComplete?.call();
      return;
    }
    state = SessionTimerState(
      total: state.total,
      remaining: remaining,
      status: SessionTimerStatus.running,
    );
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }
}

final sessionTimerControllerProvider =
    StateNotifierProvider.autoDispose<
      SessionTimerController,
      SessionTimerState
    >((ref) {
      final controller = SessionTimerController();
      ref.onDispose(controller.dispose);
      return controller;
    });
