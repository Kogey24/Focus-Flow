import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/chapter_tree.dart';
import '../../core/utils/duration_formatter.dart';
import '../../core/widgets/countdown_timer.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../core/widgets/progress_bar.dart';
import '../../domain/enums/material_type.dart' as study;
import '../../domain/models/chapter.dart';
import '../../domain/models/material.dart';
import 'session_notifier.dart';
import 'session_state.dart';

class FocusSessionScreen extends ConsumerStatefulWidget {
  const FocusSessionScreen({super.key, this.materialId, this.chapterId});

  final String? materialId;
  final String? chapterId;

  @override
  ConsumerState<FocusSessionScreen> createState() => _FocusSessionScreenState();
}

class _FocusSessionScreenState extends ConsumerState<FocusSessionScreen> {
  bool _finished = false;
  bool _syncedRouteSelection = false;
  List<String> _selectionPath = const [];

  @override
  void didUpdateWidget(covariant FocusSessionScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.materialId != widget.materialId ||
        oldWidget.chapterId != widget.chapterId) {
      _syncedRouteSelection = false;
      _selectionPath = const [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = sessionNotifierProvider(
      materialId: widget.materialId,
      chapterId: widget.chapterId,
    );
    final state = ref.watch(provider);
    final timer = ref.watch(sessionTimerControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Focus session')),
      body: state.when(
        data: (sessionState) {
          if (sessionState.materials.isEmpty) {
            return EmptyStateWidget(
              title: 'No focus material yet',
              message:
                  'Add something to your library before starting a study session.',
              ctaLabel: 'Add material',
              onPressed: () => context.go('/library/add'),
            );
          }

          final selectedMaterial =
              sessionState.materials.firstWhereOrNull(
                (material) => material.id == sessionState.selectedMaterialId,
              ) ??
              sessionState.materials.first;
          final chapterTree = ChapterTree.fromChapters(sessionState.chapters);
          final selectedChapter = sessionState.selectedChapterId == null
              ? null
              : chapterTree.chapterById(sessionState.selectedChapterId);

          _syncRouteSelection(chapterTree, sessionState.selectedChapterId);

          final visiblePath = _selectionPath
              .where((chapterId) => chapterTree.chapterById(chapterId) != null)
              .toList(growable: false);
          final currentParentId = visiblePath.isEmpty ? null : visiblePath.last;
          final visibleChapters = chapterTree.childrenOf(currentParentId);
          final isSelectionVisible =
              selectedChapter != null &&
              visibleChapters.any(
                (chapter) => chapter.id == selectedChapter.id,
              );
          final selectedPathLabel = selectedChapter == null
              ? null
              : chapterTree.pathLabel(selectedChapter.id);
          final canStartSession =
              sessionState.chapters.isEmpty || isSelectionVisible;

          if (sessionState.activeSessionId == null) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Prepare your next focus block',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  selectedMaterial.type == study.MaterialType.book
                                      ? 'Choose a book, drill into the right part, chapter, or topic, then lock in your session length.'
                                      : 'Choose a material, pick the section you want, and move into focused work without distractions.',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Choose material',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 12),
                        ...sessionState.materials.map(
                          (material) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _SessionMaterialTile(
                              material: material,
                              isSelected: material.id == selectedMaterial.id,
                              onTap: () => _selectMaterial(material.id),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          sessionState.chapters.isEmpty
                              ? 'What to focus on'
                              : _selectionTitleFor(
                                  material: selectedMaterial,
                                  depth: visiblePath.length,
                                ),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 12),
                        if (sessionState.chapters.isEmpty)
                          Card(
                            child: ListTile(
                              leading: Icon(selectedMaterial.type.icon),
                              title: const Text('Whole material'),
                              subtitle: Text(
                                'No sections were detected for ${selectedMaterial.title}, so the session will start from the material itself.',
                              ),
                            ),
                          )
                        else
                          _HierarchySelectionCard(
                            material: selectedMaterial,
                            chapterTree: chapterTree,
                            visiblePath: visiblePath,
                            visibleChapters: visibleChapters,
                            selectedChapterId: sessionState.selectedChapterId,
                            onBack: visiblePath.isEmpty ? null : _goBackLevel,
                            onChapterTap: (chapter) => _handleChapterTap(
                              tree: chapterTree,
                              chapter: chapter,
                            ),
                          ),
                        if (selectedPathLabel != null) ...[
                          const SizedBox(height: 16),
                          Card(
                            child: ListTile(
                              leading: const Icon(Icons.playlist_play_rounded),
                              title: const Text('Selected focus target'),
                              subtitle: Text(selectedPathLabel),
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Session duration',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  '${sessionState.durationMinutes} min',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Slider(
                                  value: sessionState.durationMinutes
                                      .toDouble(),
                                  min: 5,
                                  max: 90,
                                  divisions: 17,
                                  label: '${sessionState.durationMinutes} min',
                                  onChanged: (value) {
                                    ref
                                        .read(provider.notifier)
                                        .setDuration(value.round());
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: canStartSession
                          ? () => _startSession(sessionState)
                          : null,
                      child: const Text('Start session'),
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  selectedMaterial.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  selectedPathLabel ?? 'Deep focus mode',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                CountdownTimer(total: timer.total, remaining: timer.remaining),
                const SizedBox(height: 24),
                ProgressBar(
                  value: selectedMaterial.progress,
                  type: selectedMaterial.type,
                  height: 10,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.tonal(
                        onPressed: () {
                          final controller = ref.read(
                            sessionTimerControllerProvider.notifier,
                          );
                          if (timer.status == SessionTimerStatus.running) {
                            controller.pause();
                          } else if (timer.status ==
                              SessionTimerStatus.paused) {
                            controller.resume();
                          }
                        },
                        child: Text(
                          timer.status == SessionTimerStatus.paused
                              ? 'Resume'
                              : 'Pause',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.tonal(
                        onPressed: () {
                          ref.read(provider.notifier).markSelectedChapterDone();
                        },
                        child: const Text('Mark done'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () async {
                      await ref.read(provider.notifier).abandonSession();
                      ref.read(sessionTimerControllerProvider.notifier).reset();
                      if (!context.mounted) return;
                      context.go('/');
                    },
                    child: const Text('End session'),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => EmptyStateWidget(
          title: 'Session setup failed',
          message: '$error',
          ctaLabel: 'Retry',
          onPressed: () => ref.invalidate(provider),
        ),
      ),
    );
  }

  Future<void> _selectMaterial(String materialId) async {
    _syncedRouteSelection = true;
    await ref
        .read(
          sessionNotifierProvider(
            materialId: widget.materialId,
            chapterId: widget.chapterId,
          ).notifier,
        )
        .selectMaterial(materialId);
    if (!mounted) return;
    setState(() => _selectionPath = const []);
  }

  void _handleChapterTap({
    required ChapterTree tree,
    required Chapter chapter,
  }) {
    final notifier = ref.read(
      sessionNotifierProvider(
        materialId: widget.materialId,
        chapterId: widget.chapterId,
      ).notifier,
    );
    _syncedRouteSelection = true;

    if (tree.hasChildren(chapter.id)) {
      notifier.selectChapter(null);
      setState(() {
        _selectionPath = [
          ..._selectionPath.where((id) => tree.chapterById(id) != null),
          chapter.id,
        ];
      });
      return;
    }

    notifier.selectChapter(chapter.id);
  }

  void _goBackLevel() {
    final notifier = ref.read(
      sessionNotifierProvider(
        materialId: widget.materialId,
        chapterId: widget.chapterId,
      ).notifier,
    );
    _syncedRouteSelection = true;
    notifier.selectChapter(null);
    if (_selectionPath.isEmpty) return;
    setState(() {
      _selectionPath = _selectionPath.sublist(0, _selectionPath.length - 1);
    });
  }

  String _selectionTitleFor({
    required StudyMaterial material,
    required int depth,
  }) {
    if (material.type != study.MaterialType.book) {
      return depth == 0 ? 'Choose a section' : 'Choose the next section';
    }

    return switch (depth) {
      0 => 'Choose a part',
      1 => 'Choose a chapter',
      _ => 'Choose a topic',
    };
  }

  void _syncRouteSelection(ChapterTree tree, String? selectedChapterId) {
    if (_syncedRouteSelection ||
        widget.chapterId == null ||
        selectedChapterId == null)
      return;
    _syncedRouteSelection = true;
    final nextPath = tree
        .ancestorIdsOf(selectedChapterId)
        .reversed
        .toList(growable: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _selectionPath = nextPath);
    });
  }

  Future<void> _startSession(SessionViewState sessionState) async {
    final provider = sessionNotifierProvider(
      materialId: widget.materialId,
      chapterId: widget.chapterId,
    );
    final notifier = ref.read(provider.notifier);
    await notifier.startSession();
    final updatedState = ref.read(provider).valueOrNull;
    if (updatedState?.activeSessionId == null || !mounted) return;
    ref
        .read(sessionTimerControllerProvider.notifier)
        .start(
          Duration(minutes: sessionState.durationMinutes),
          onComplete: () =>
              _completeSession(context, sessionState.durationMinutes * 60),
        );
  }

  Future<void> _completeSession(
    BuildContext context,
    int plannedSeconds,
  ) async {
    if (_finished) return;
    _finished = true;
    final timer = ref.read(sessionTimerControllerProvider);
    final spentSeconds = timer.elapsed.inSeconds == 0
        ? plannedSeconds
        : timer.elapsed.inSeconds;
    await ref
        .read(
          sessionNotifierProvider(
            materialId: widget.materialId,
            chapterId: widget.chapterId,
          ).notifier,
        )
        .completeSession(actualDurationSeconds: spentSeconds);
    ref.read(sessionTimerControllerProvider.notifier).reset();
    if (!context.mounted) return;
    context.go(
      '/session/complete',
      extra: SessionCompleteArgs(focusSeconds: spentSeconds),
    );
  }
}

class _SessionMaterialTile extends StatelessWidget {
  const _SessionMaterialTile({
    required this.material,
    required this.isSelected,
    required this.onTap,
  });

  final StudyMaterial material;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: isSelected
          ? theme.colorScheme.primary.withOpacity(0.08)
          : theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                child: Icon(
                  material.type.icon,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      material.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      material.author?.trim().isNotEmpty == true
                          ? material.author!
                          : material.type.label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text('${(material.progress * 100).round()}%'),
              const SizedBox(width: 8),
              Icon(
                isSelected
                    ? Icons.check_circle_rounded
                    : Icons.chevron_right_rounded,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HierarchySelectionCard extends StatelessWidget {
  const _HierarchySelectionCard({
    required this.material,
    required this.chapterTree,
    required this.visiblePath,
    required this.visibleChapters,
    required this.selectedChapterId,
    required this.onChapterTap,
    this.onBack,
  });

  final StudyMaterial material;
  final ChapterTree chapterTree;
  final List<String> visiblePath;
  final List<Chapter> visibleChapters;
  final String? selectedChapterId;
  final VoidCallback? onBack;
  final void Function(Chapter chapter) onChapterTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _levelLabel(material.type, visiblePath.length),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (onBack != null)
                  TextButton.icon(
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('Back'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              visiblePath.isEmpty
                  ? 'Start from the top level and keep drilling down until you reach the exact section to study.'
                  : visiblePath
                        .map((id) => chapterTree.chapterById(id)?.title)
                        .whereType<String>()
                        .join(' / '),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            if (visibleChapters.isEmpty)
              Text(
                'No deeper sections were detected here.',
                style: theme.textTheme.bodyMedium,
              )
            else
              ...visibleChapters.map(
                (chapter) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ChapterSelectionTile(
                    chapter: chapter,
                    chapterTree: chapterTree,
                    isSelected: selectedChapterId == chapter.id,
                    onTap: () => onChapterTap(chapter),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _levelLabel(study.MaterialType materialType, int depth) {
    if (materialType != study.MaterialType.book) {
      return depth == 0 ? 'Sections' : 'Subsections';
    }

    return switch (depth) {
      0 => 'Book parts',
      1 => 'Chapters',
      _ => 'Topics',
    };
  }
}

class _ChapterSelectionTile extends StatelessWidget {
  const _ChapterSelectionTile({
    required this.chapter,
    required this.chapterTree,
    required this.isSelected,
    required this.onTap,
  });

  final Chapter chapter;
  final ChapterTree chapterTree;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasChildren = chapterTree.hasChildren(chapter.id);
    final subtitle = hasChildren ? _branchSubtitle() : _leafSubtitle();

    return Material(
      color: isSelected
          ? theme.colorScheme.primary.withOpacity(0.08)
          : theme.colorScheme.surfaceContainerHighest.withOpacity(0.35),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                hasChildren
                    ? Icons.account_tree_rounded
                    : Icons.article_outlined,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chapter.title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                hasChildren
                    ? Icons.chevron_right_rounded
                    : isSelected
                    ? Icons.check_circle_rounded
                    : Icons.play_circle_outline_rounded,
                color: hasChildren || isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _branchSubtitle() {
    final totalLeaves = chapterTree.leafCount(chapter.id);
    if (totalLeaves == 0) return _pageLabel();
    final completedLeaves = chapterTree.completedLeafCount(chapter.id);
    final base = '$completedLeaves / $totalLeaves complete';
    final pageLabel = _pageLabel();
    return pageLabel == null ? base : '$base  -  $pageLabel';
  }

  String? _leafSubtitle() => _pageLabel();

  String? _pageLabel() {
    if (chapter.pageStart == null) return null;
    final end = chapter.pageEnd ?? chapter.pageStart;
    if (end == chapter.pageStart) return 'Page ${chapter.pageStart}';
    return 'Pages ${chapter.pageStart}-$end';
  }
}

class SessionCompleteArgs {
  const SessionCompleteArgs({required this.focusSeconds});

  final int focusSeconds;
}

class SessionCompleteScreen extends StatelessWidget {
  const SessionCompleteScreen({super.key, this.args});

  final SessionCompleteArgs? args;

  @override
  Widget build(BuildContext context) {
    final seconds = args?.focusSeconds ?? 1500;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.92, end: 1),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.elasticOut,
                        builder: (context, value, child) {
                          return Transform.scale(scale: value, child: child);
                        },
                        child: const Icon(Icons.celebration_rounded, size: 120),
                      ),
                      Text(
                        'Session complete',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You stayed focused for ${DurationFormatter.asCompact(Duration(seconds: seconds))}.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => context.go('/session'),
                  child: const Text('Start another'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.go('/'),
                  child: const Text('Go home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
