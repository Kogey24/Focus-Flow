import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/enums/material_type.dart';
import '../../domain/enums/session_status.dart';
import '../../domain/models/focus_analytics.dart';
import '../database/app_database.dart';
import 'material_repository.dart';
import 'session_repository.dart';

part 'progress_repository.g.dart';

class ProgressRepository {
  ProgressRepository(this._db);

  final AppDatabase _db;

  Future<List<DailyFocusStat>> getFocusStats({int? days}) async {
    final now = DateTime.now();
    final start = days == null
        ? DateTime(
            now.year,
            now.month,
            now.day,
          ).subtract(const Duration(days: 6))
        : DateTime(
            now.year,
            now.month,
            now.day,
          ).subtract(Duration(days: days - 1));
    final dates = List.generate(
      days ?? 7,
      (index) => DateTime(start.year, start.month, start.day + index),
    );

    final streakRows = await (_db.select(
      _db.streaksTable,
    )..where((tbl) => tbl.date.isBiggerOrEqualValue(_formatDate(start)))).get();
    final byDate = {
      for (final row in streakRows)
        row.date: (
          focusSeconds: row.totalFocusSeconds,
          sessionCount: row.sessionCount,
        ),
    };

    return dates
        .map(
          (date) => DailyFocusStat(
            date: date,
            minutes: ((byDate[_formatDate(date)]?.focusSeconds) ?? 0) / 60,
            sessionCount: byDate[_formatDate(date)]?.sessionCount ?? 0,
          ),
        )
        .toList();
  }

  Future<int> getCompletedMaterialsCount() async {
    final countExpression = _db.materialsTable.id.count();
    final row =
        await (_db.selectOnly(_db.materialsTable)
              ..addColumns([countExpression])
              ..where(_db.materialsTable.status.equals('completed')))
            .getSingle();
    return row.read(countExpression) ?? 0;
  }

  Future<int> getTotalFocusSeconds({DateTime? from}) async {
    final totalExpression = _db.focusSessionsTable.durationSeconds.sum();
    final query = _db.selectOnly(_db.focusSessionsTable)
      ..addColumns([totalExpression]);
    query.where(
      _db.focusSessionsTable.status.equals(SessionStatus.completed.value),
    );
    if (from != null) {
      query.where(
        _db.focusSessionsTable.startedAt.isBiggerOrEqualValue(
          from.millisecondsSinceEpoch,
        ),
      );
    }
    final row = await query.getSingle();
    return row.read(totalExpression) ?? 0;
  }

  Future<List<MaterialTypeBreakdown>> getMaterialBreakdown({
    DateTime? from,
  }) async {
    final materials = await _db.select(_db.materialsTable).get();
    final materialTypeById = {
      for (final material in materials)
        material.id: MaterialType.fromValue(material.type),
    };

    final sessions = await (_db.select(
      _db.focusSessionsTable,
    )..where((tbl) => tbl.status.equals(SessionStatus.completed.value))).get();

    final breakdown = <MaterialType, int>{};
    for (final session in sessions) {
      if (from != null && session.startedAt < from.millisecondsSinceEpoch) {
        continue;
      }
      final type = materialTypeById[session.materialId] ?? MaterialType.book;
      breakdown[type] = (breakdown[type] ?? 0) + session.durationSeconds;
    }

    return breakdown.entries
        .map(
          (entry) =>
              MaterialTypeBreakdown(type: entry.key, minutes: entry.value / 60),
        )
        .toList()
      ..sort((a, b) => b.minutes.compareTo(a.minutes));
  }

  Future<List<RecentCompletion>> getRecentCompletions({int limit = 8}) async {
    final chapters =
        await (_db.select(_db.chaptersTable)
              ..where(
                (tbl) =>
                    tbl.isCompleted.equals(true) & tbl.completedAt.isNotNull(),
              )
              ..orderBy([(tbl) => OrderingTerm.desc(tbl.completedAt)])
              ..limit(limit))
            .get();
    final materials = await _db.select(_db.materialsTable).get();
    final materialTitles = {
      for (final material in materials) material.id: material.title,
    };

    return chapters
        .map(
          (chapter) => RecentCompletion(
            chapterTitle: chapter.title,
            materialTitle:
                materialTitles[chapter.materialId] ?? 'Unknown material',
            completedAt: DateTime.fromMillisecondsSinceEpoch(
              chapter.completedAt!,
            ),
            materialId: chapter.materialId,
          ),
        )
        .toList();
  }

  Stream<List<RecentCompletion>> watchRecentCompletions({int limit = 8}) {
    return (_db.select(_db.chaptersTable)
          ..where(
            (tbl) => tbl.isCompleted.equals(true) & tbl.completedAt.isNotNull(),
          )
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.completedAt)])
          ..limit(limit))
        .watch()
        .asyncMap((_) => getRecentCompletions(limit: limit));
  }

  Future<StatsSummary> getSummary({DateTime? from}) async {
    return StatsSummary(
      totalFocusSeconds: await getTotalFocusSeconds(from: from),
      currentStreak: await SessionRepository(_db).getCurrentStreak(),
      completedSessions: await SessionRepository(
        _db,
      ).getCompletedSessionsCount(from: from),
      completedMaterials: await getCompletedMaterialsCount(),
      dailyStats: await getFocusStats(
        days: from == null ? 7 : DateTime.now().difference(from).inDays + 1,
      ),
      typeBreakdown: await getMaterialBreakdown(from: from),
      recentCompletions: await getRecentCompletions(),
    );
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}

@Riverpod(keepAlive: true)
ProgressRepository progressRepository(Ref ref) {
  return ProgressRepository(ref.watch(appDatabaseProvider));
}
