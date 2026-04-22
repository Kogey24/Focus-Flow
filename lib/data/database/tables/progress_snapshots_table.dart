import 'package:drift/drift.dart';

import 'chapters_table.dart';
import 'materials_table.dart';

@DataClassName('ProgressSnapshotEntity')
class ProgressSnapshotsTable extends Table {
  @override
  String get tableName => 'progress_snapshots';

  TextColumn get id => text()();
  TextColumn get materialId => text().references(MaterialsTable, #id)();
  TextColumn get chapterId => text().nullable().references(ChaptersTable, #id)();
  IntColumn get snapshotAt => integer()();
  RealColumn get percentComplete => real()();
  IntColumn get lastPositionSeconds => integer().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
