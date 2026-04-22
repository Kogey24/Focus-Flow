import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../domain/enums/session_status.dart';
import '../../domain/models/focus_session.dart';
import '../database/app_database.dart';
import 'material_repository.dart';

part 'session_repository.g.dart';

class SessionRepository {
  SessionRepository(this._db);

  final AppDatabase _db;
  final Uuid _uuid = const Uuid();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  Future<FocusSession> startSession({
    required String materialId,
    String? chapterId,
    required int durationSeconds,
    String? notes,
  }) async {
    final id = _uuid.v4();
    final startedAt = DateTime.now();
    await _db.into(_db.focusSessionsTable).insert(
          FocusSessionsTableCompanion.insert(
            id: id,
            materialId: materialId,
            startedAt: startedAt.millisecondsSinceEpoch,
            durationSeconds: durationSeconds,
            status: SessionStatus.active.value,
            chapterId: Value(chapterId),
            notes: Value(notes),
          ),
        );

    await (_db.update(_db.materialsTable)..where((tbl) => tbl.id.equals(materialId))).write(
      const MaterialsTableCompanion(status: Value('in_progress')),
    );

    return FocusSession(
      id: id,
      materialId: materialId,
      chapterId: chapterId,
      startedAt: startedAt,
      durationSeconds: durationSeconds,
      status: SessionStatus.active,
      notes: notes,
    );
  }

  Future<void> updateSessionStatus({
    required String sessionId,
    required SessionStatus status,
  }) async {
    await (_db.update(_db.focusSessionsTable)..where((tbl) => tbl.id.equals(sessionId))).write(
      FocusSessionsTableCompanion(
        status: Value(status.value),
      ),
    );
  }

  Future<void> completeSession({
    required String sessionId,
    required int actualDurationSeconds,
  }) async {
    final now = DateTime.now();
    final session = await (_db.select(_db.focusSessionsTable)
          ..where((tbl) => tbl.id.equals(sessionId)))
        .getSingle();

    await (_db.update(_db.focusSessionsTable)..where((tbl) => tbl.id.equals(sessionId))).write(
      FocusSessionsTableCompanion(
        endedAt: Value(now.millisecondsSinceEpoch),
        durationSeconds: Value(actualDurationSeconds),
        status: const Value('completed'),
      ),
    );

    await _upsertStreak(
      date: now,
      focusSeconds: actualDurationSeconds,
    );

    await (_db.update(_db.materialsTable)..where((tbl) => tbl.id.equals(session.materialId))).write(
      const MaterialsTableCompanion(status: Value('in_progress')),
    );
  }

  Future<void> abandonSession(String sessionId) async {
    await (_db.update(_db.focusSessionsTable)..where((tbl) => tbl.id.equals(sessionId))).write(
      FocusSessionsTableCompanion(
        endedAt: Value(DateTime.now().millisecondsSinceEpoch),
        status: const Value('abandoned'),
      ),
    );
  }

  Future<int> getTodayFocusSeconds() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999)
        .millisecondsSinceEpoch;

    final totalExpression = _db.focusSessionsTable.durationSeconds.sum();
    final row = await (_db.selectOnly(_db.focusSessionsTable)
          ..addColumns([totalExpression])
          ..where(_db.focusSessionsTable.startedAt.isBetweenValues(startOfDay, endOfDay))
          ..where(_db.focusSessionsTable.status.equals(SessionStatus.completed.value)))
        .getSingle();
    return row.read(totalExpression) ?? 0;
  }

  Future<int> getCompletedSessionsCount({DateTime? from}) async {
    final countExpression = _db.focusSessionsTable.id.count();
    final query = _db.selectOnly(_db.focusSessionsTable)
      ..addColumns([countExpression]);
    query.where(_db.focusSessionsTable.status.equals(SessionStatus.completed.value));
    if (from != null) {
      query.where(_db.focusSessionsTable.startedAt.isBiggerOrEqualValue(from.millisecondsSinceEpoch));
    }
    final row = await query.getSingle();
    return row.read(countExpression) ?? 0;
  }

  Stream<int> watchCurrentStreak() {
    return (_db.select(_db.streaksTable)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)]))
        .watch()
        .asyncMap((_) => getCurrentStreak());
  }

  Future<int> getCurrentStreak() async {
    final rows = await (_db.select(_db.streaksTable)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)]))
        .get();
    if (rows.isEmpty) return 0;

    final today = DateTime.now();
    final dates = rows
        .map((row) => _dateFormat.parse(row.date))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    final normalizedToday = DateTime(today.year, today.month, today.day);
    final normalizedYesterday = normalizedToday.subtract(const Duration(days: 1));
    final first = dates.first;
    if (!_isSameDay(first, normalizedToday) && !_isSameDay(first, normalizedYesterday)) {
      return 0;
    }

    var streak = 0;
    var cursor = first;
    for (final date in dates) {
      final normalized = DateTime(date.year, date.month, date.day);
      if (_isSameDay(normalized, cursor)) {
        streak++;
        cursor = cursor.subtract(const Duration(days: 1));
      } else if (normalized.isAfter(cursor)) {
        continue;
      } else {
        break;
      }
    }
    return streak;
  }

  Future<void> _upsertStreak({
    required DateTime date,
    required int focusSeconds,
  }) async {
    final key = _dateFormat.format(date);
    final existing = await (_db.select(_db.streaksTable)
          ..where((tbl) => tbl.date.equals(key)))
        .getSingleOrNull();

    if (existing == null) {
      await _db.into(_db.streaksTable).insert(
            StreaksTableCompanion.insert(
              id: _uuid.v4(),
              date: key,
              totalFocusSeconds: Value(focusSeconds),
              sessionCount: const Value(1),
            ),
          );
    } else {
      await (_db.update(_db.streaksTable)..where((tbl) => tbl.id.equals(existing.id))).write(
        StreaksTableCompanion(
          totalFocusSeconds: Value(existing.totalFocusSeconds + focusSeconds),
          sessionCount: Value(existing.sessionCount + 1),
        ),
      );
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

@Riverpod(keepAlive: true)
SessionRepository sessionRepository(Ref ref) {
  return SessionRepository(ref.watch(appDatabaseProvider));
}
