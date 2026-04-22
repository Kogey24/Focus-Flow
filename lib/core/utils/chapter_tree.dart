import '../../domain/models/chapter.dart';

class ChapterTreeNode {
  const ChapterTreeNode({
    required this.chapter,
    required this.children,
  });

  final Chapter chapter;
  final List<ChapterTreeNode> children;

  bool get isLeaf => children.isEmpty;
}

class ChapterTree {
  ChapterTree._({
    required this.roots,
    required Map<String, Chapter> chaptersById,
    required Map<String?, List<Chapter>> childrenByParent,
    required Map<String, String?> parentById,
  })  : _chaptersById = chaptersById,
        _childrenByParent = childrenByParent,
        _parentById = parentById;

  factory ChapterTree.fromChapters(List<Chapter> chapters) {
    final ordered = [...chapters]..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    final chaptersById = <String, Chapter>{
      for (final chapter in ordered) chapter.id: chapter,
    };
    final childrenByParent = <String?, List<Chapter>>{};
    final parentById = <String, String?>{};

    for (final chapter in ordered) {
      final parentId = chaptersById.containsKey(chapter.parentId) ? chapter.parentId : null;
      parentById[chapter.id] = parentId;
      childrenByParent.putIfAbsent(parentId, () => <Chapter>[]).add(chapter);
    }

    ChapterTreeNode buildNode(Chapter chapter) {
      final children = childrenByParent[chapter.id] ?? const <Chapter>[];
      return ChapterTreeNode(
        chapter: chapter,
        children: children.map(buildNode).toList(growable: false),
      );
    }

    final roots = (childrenByParent[null] ?? const <Chapter>[]).map(buildNode).toList(growable: false);

    return ChapterTree._(
      roots: roots,
      chaptersById: chaptersById,
      childrenByParent: childrenByParent,
      parentById: parentById,
    );
  }

  final List<ChapterTreeNode> roots;
  final Map<String, Chapter> _chaptersById;
  final Map<String?, List<Chapter>> _childrenByParent;
  final Map<String, String?> _parentById;

  Chapter? chapterById(String? id) {
    if (id == null) return null;
    return _chaptersById[id];
  }

  bool hasChildren(String id) => (_childrenByParent[id] ?? const <Chapter>[]).isNotEmpty;

  bool isLeaf(String id) => !hasChildren(id);

  List<Chapter> childrenOf(String? parentId) => List<Chapter>.unmodifiable(
        _childrenByParent[parentId] ?? const <Chapter>[],
      );

  List<Chapter> leafChapters({String? rootId}) {
    if (_chaptersById.isEmpty) return const <Chapter>[];

    if (rootId == null) {
      return _collectLeafChapters(roots);
    }

    final root = chapterById(rootId);
    if (root == null) return const <Chapter>[];
    if (isLeaf(root.id)) return [root];

    return _collectLeafChapters(
      roots.where((node) => node.chapter.id == root.id).toList(growable: false).isNotEmpty
          ? roots.where((node) => node.chapter.id == root.id).toList(growable: false)
          : [ChapterTreeNode(chapter: root, children: _buildChildren(root.id))],
    );
  }

  List<ChapterTreeNode> _buildChildren(String parentId) {
    return childrenOf(parentId)
        .map(
          (child) => ChapterTreeNode(
            chapter: child,
            children: _buildChildren(child.id),
          ),
        )
        .toList(growable: false);
  }

  List<Chapter> _collectLeafChapters(List<ChapterTreeNode> nodes) {
    final leaves = <Chapter>[];

    void visit(ChapterTreeNode node) {
      if (node.isLeaf) {
        leaves.add(node.chapter);
        return;
      }
      for (final child in node.children) {
        visit(child);
      }
    }

    for (final node in nodes) {
      visit(node);
    }

    return leaves;
  }

  List<Chapter> leafDescendantsOf(String id) => leafChapters(rootId: id);

  Chapter? firstIncompleteLeaf() {
    for (final chapter in leafChapters()) {
      if (!chapter.isCompleted) return chapter;
    }
    return null;
  }

  bool isEffectivelyCompleted(String id) {
    final chapter = chapterById(id);
    if (chapter == null) return false;

    final leaves = leafDescendantsOf(id);
    if (leaves.isEmpty) return chapter.isCompleted;
    return leaves.every((leaf) => leaf.isCompleted);
  }

  double completionRatio(String id) {
    final leaves = leafDescendantsOf(id);
    if (leaves.isEmpty) return 0;
    final completed = leaves.where((leaf) => leaf.isCompleted).length;
    return completed / leaves.length;
  }

  int completedLeafCount(String id) {
    return leafDescendantsOf(id).where((leaf) => leaf.isCompleted).length;
  }

  int leafCount(String id) => leafDescendantsOf(id).length;

  int depthOf(String id) {
    var depth = 0;
    var cursor = _parentById[id];
    while (cursor != null) {
      depth += 1;
      cursor = _parentById[cursor];
    }
    return depth;
  }

  List<String> ancestorIdsOf(String? id) {
    if (id == null || !_chaptersById.containsKey(id)) return const <String>[];
    final ancestors = <String>[];
    var cursor = _parentById[id];
    while (cursor != null) {
      ancestors.add(cursor);
      cursor = _parentById[cursor];
    }
    return ancestors;
  }

  String? normalizeToLeafId(String? id) {
    if (_chaptersById.isEmpty) return null;
    if (id == null) return firstIncompleteLeaf()?.id ?? leafChapters().firstOrNull?.id;

    final chapter = chapterById(id);
    if (chapter == null) return firstIncompleteLeaf()?.id ?? leafChapters().firstOrNull?.id;
    if (isLeaf(chapter.id)) return chapter.id;

    final descendants = leafDescendantsOf(chapter.id);
    if (descendants.isEmpty) return null;

    for (final leaf in descendants) {
      if (!leaf.isCompleted) return leaf.id;
    }
    return descendants.first.id;
  }

  String pathLabel(String id, {String separator = ' / '}) {
    final segments = <String>[];
    var cursor = chapterById(id);
    while (cursor != null) {
      segments.add(cursor.title);
      cursor = chapterById(_parentById[cursor.id]);
    }
    return segments.reversed.join(separator);
  }
}

extension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
