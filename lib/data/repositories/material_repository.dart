import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../core/utils/chapter_tree.dart';
import '../../domain/enums/material_type.dart';
import '../../domain/models/chapter.dart';
import '../../domain/models/material.dart';
import '../database/app_database.dart';

part 'material_repository.g.dart';

class MaterialRepository {
  MaterialRepository(this._db);

  final AppDatabase _db;
  final Uuid _uuid = const Uuid();

  Future<List<StudyMaterial>> getAllMaterials({
    MaterialType? filter,
    String search = '',
  }) async {
    final rows = await _filteredMaterialQuery(filter: filter, search: search).get();
    return Future.wait(rows.map(_mapMaterial));
  }

  Stream<List<StudyMaterial>> watchMaterials({
    MaterialType? filter,
    String search = '',
  }) {
    return _filteredMaterialQuery(filter: filter, search: search)
        .watch()
        .asyncMap((rows) => Future.wait(rows.map(_mapMaterial)));
  }

  Future<List<StudyMaterial>> getInProgress({int limit = 3}) async {
    final materials = await getAllMaterials();
    final sorted = [...materials]
      ..sort((a, b) {
        final aPriority = a.isInProgress ? 0 : (a.isNotStarted ? 1 : 2);
        final bPriority = b.isInProgress ? 0 : (b.isNotStarted ? 1 : 2);
        if (aPriority != bPriority) return aPriority.compareTo(bPriority);
        return b.createdAt.compareTo(a.createdAt);
      });
    return sorted.take(limit).toList();
  }

  Future<StudyMaterial?> getMaterialById(String id) async {
    final row = await (_db.select(_db.materialsTable)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return null;
    return _mapMaterial(row);
  }

  Stream<List<Chapter>> watchChapters(String materialId) {
    final query = _db.select(_db.chaptersTable)
      ..where((tbl) => tbl.materialId.equals(materialId))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.orderIndex)]);
    return query.watch().asyncMap((rows) => Future.wait(rows.map(_mapChapter)));
  }

  Future<List<Chapter>> getChapters(String materialId) async {
    final rows = await _getChapterRows(materialId);
    return Future.wait(rows.map(_mapChapter));
  }

  Future<void> saveMaterial({
    required StudyMaterial material,
    required List<Chapter> chapters,
  }) async {
    await _db.transaction(() async {
      await _db.into(_db.materialsTable).insert(
            MaterialsTableCompanion.insert(
              id: material.id,
              title: material.title,
              type: material.type.value,
              createdAt: material.createdAt.millisecondsSinceEpoch,
              author: Value(material.author),
              filePath: Value(material.filePath),
              thumbnailPath: Value(material.thumbnailPath),
              totalDuration: Value(material.totalDuration),
              totalPages: Value(material.totalPages),
              status: Value(material.status),
              tags: Value(material.tags.join(',')),
            ),
          );

      if (chapters.isNotEmpty) {
        await _db.batch((batch) {
          batch.insertAll(
            _db.chaptersTable,
            chapters
                .map(
                  (chapter) => ChaptersTableCompanion.insert(
                    id: chapter.id,
                    materialId: chapter.materialId,
                    title: chapter.title,
                    orderIndex: chapter.orderIndex,
                    parentId: Value(chapter.parentId),
                    pageStart: Value(chapter.pageStart),
                    pageEnd: Value(chapter.pageEnd),
                    duration: Value(chapter.duration),
                    filePath: Value(chapter.filePath),
                    isCompleted: Value(chapter.isCompleted),
                    completedAt: Value(
                      chapter.completedAt?.millisecondsSinceEpoch,
                    ),
                  ),
                )
                .toList(),
          );
        });
      }
    });
  }

  Future<void> toggleChapterCompletion({
    required String materialId,
    required String chapterId,
    bool? completed,
  }) async {
    final chapterTree = await _getChapterTree(materialId);
    final targets = chapterTree.leafDescendantsOf(chapterId);
    if (targets.isEmpty) return;

    final nextValue = completed ?? !chapterTree.isEffectivelyCompleted(chapterId);
    final completedAt = nextValue ? DateTime.now().millisecondsSinceEpoch : null;

    await _db.transaction(() async {
      for (final target in targets) {
        await (_db.update(_db.chaptersTable)..where((tbl) => tbl.id.equals(target.id))).write(
          ChaptersTableCompanion(
            isCompleted: Value(nextValue),
            completedAt: Value(completedAt),
          ),
        );
      }
    });
    await _upsertProgressSnapshot(materialId: materialId, chapterId: chapterId);
    await _syncMaterialStatus(materialId);
  }

  Future<void> addChapterNote({
    required String chapterId,
    required String note,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final existing = await (_db.select(_db.chapterNotesTable)
          ..where((tbl) => tbl.chapterId.equals(chapterId)))
        .getSingleOrNull();

    if (existing == null) {
      await _db.into(_db.chapterNotesTable).insert(
            ChapterNotesTableCompanion.insert(
              id: _uuid.v4(),
              chapterId: chapterId,
              note: note,
              createdAt: now,
              updatedAt: now,
            ),
          );
    } else {
      await (_db.update(_db.chapterNotesTable)..where((tbl) => tbl.id.equals(existing.id))).write(
        ChapterNotesTableCompanion(
          note: Value(note),
          updatedAt: Value(now),
        ),
      );
    }
  }

  Future<double> getMaterialProgress(String materialId) async {
    final chapterTree = await _getChapterTree(materialId);
    final leaves = chapterTree.leafChapters();
    if (leaves.isEmpty) return 0;
    final completed = leaves.where((leaf) => leaf.isCompleted).length;
    return completed / leaves.length;
  }

  Future<Chapter?> getFirstIncompleteChapter(String materialId) async {
    final chapterTree = await _getChapterTree(materialId);
    return chapterTree.firstIncompleteLeaf();
  }

  SimpleSelectStatement<$MaterialsTableTable, MaterialEntity> _filteredMaterialQuery({
    MaterialType? filter,
    String search = '',
  }) {
    final query = _db.select(_db.materialsTable)
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]);

    if (filter != null) {
      query.where((tbl) => tbl.type.equals(filter.value));
    }

    final trimmed = search.trim();
    if (trimmed.isNotEmpty) {
      final pattern = '%$trimmed%';
      query.where(
        (tbl) =>
            tbl.title.like(pattern) |
            (tbl.author.isNotNull() & tbl.author.like(pattern)) |
            (tbl.tags.isNotNull() & tbl.tags.like(pattern)),
      );
    }
    return query;
  }

  Future<StudyMaterial> _mapMaterial(MaterialEntity row) async {
    final progress = await getMaterialProgress(row.id);
    return StudyMaterial(
      id: row.id,
      title: row.title,
      author: row.author,
      type: MaterialType.fromValue(row.type),
      filePath: row.filePath,
      thumbnailPath: row.thumbnailPath,
      totalDuration: row.totalDuration,
      totalPages: row.totalPages,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
      status: row.status,
      tags: row.tags?.split(',').where((item) => item.trim().isNotEmpty).toList() ?? const [],
      progress: progress,
    );
  }

  Future<Chapter> _mapChapter(ChapterEntity row) async {
    final note = await (_db.select(_db.chapterNotesTable)
          ..where((tbl) => tbl.chapterId.equals(row.id))
          ..limit(1))
        .getSingleOrNull();

    return _mapStoredChapter(row, note: note?.note);
  }

  Chapter _mapStoredChapter(ChapterEntity row, {String? note}) {
    return Chapter(
      id: row.id,
      materialId: row.materialId,
      title: row.title,
      parentId: row.parentId,
      orderIndex: row.orderIndex,
      pageStart: row.pageStart,
      pageEnd: row.pageEnd,
      duration: row.duration,
      filePath: row.filePath,
      isCompleted: row.isCompleted,
      completedAt: row.completedAt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(row.completedAt!),
      note: note,
    );
  }

  Future<List<ChapterEntity>> _getChapterRows(String materialId) {
    return (_db.select(_db.chaptersTable)
          ..where((tbl) => tbl.materialId.equals(materialId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.orderIndex)]))
        .get();
  }

  Future<ChapterTree> _getChapterTree(String materialId) async {
    final rows = await _getChapterRows(materialId);
    return ChapterTree.fromChapters(
      rows.map((row) => _mapStoredChapter(row)).toList(growable: false),
    );
  }

  Future<void> _upsertProgressSnapshot({
    required String materialId,
    required String chapterId,
  }) async {
    final progress = await getMaterialProgress(materialId);
    await _db.into(_db.progressSnapshotsTable).insert(
          ProgressSnapshotsTableCompanion.insert(
            id: _uuid.v4(),
            materialId: materialId,
            snapshotAt: DateTime.now().millisecondsSinceEpoch,
            percentComplete: progress,
            chapterId: Value(chapterId),
          ),
        );
  }

  Future<void> _syncMaterialStatus(String materialId) async {
    final progress = await getMaterialProgress(materialId);
    final status = switch (progress) {
      >= 1 => 'completed',
      > 0 => 'in_progress',
      _ => 'not_started',
    };
    await (_db.update(_db.materialsTable)..where((tbl) => tbl.id.equals(materialId))).write(
      MaterialsTableCompanion(
        status: Value(status),
      ),
    );
  }
}

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
}

@Riverpod(keepAlive: true)
MaterialRepository materialRepository(Ref ref) {
  return MaterialRepository(ref.watch(appDatabaseProvider));
}
