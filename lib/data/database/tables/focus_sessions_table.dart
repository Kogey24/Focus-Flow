import 'package:drift/drift.dart';

import 'chapters_table.dart';
import 'materials_table.dart';

@DataClassName('FocusSessionEntity')
@TableIndex(name: 'focus_sessions_started_idx', columns: {#startedAt})
class FocusSessionsTable extends Table {
  @override
  String get tableName => 'focus_sessions';

  TextColumn get id => text()();
  TextColumn get materialId => text().references(MaterialsTable, #id)();
  TextColumn get chapterId => text().nullable().references(ChaptersTable, #id)();
  IntColumn get startedAt => integer()();
  IntColumn get endedAt => integer().nullable()();
  IntColumn get durationSeconds => integer()();
  TextColumn get status => text()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
