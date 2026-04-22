import 'package:drift/drift.dart';

import 'materials_table.dart';

@DataClassName('ChapterEntity')
@TableIndex(name: 'chapters_material_idx', columns: {#materialId})
class ChaptersTable extends Table {
  @override
  String get tableName => 'chapters';

  TextColumn get id => text()();
  TextColumn get materialId => text().references(MaterialsTable, #id)();
  TextColumn get title => text()();
  TextColumn get parentId => text().nullable()();
  IntColumn get orderIndex => integer()();
  IntColumn get pageStart => integer().nullable()();
  IntColumn get pageEnd => integer().nullable()();
  IntColumn get duration => integer().nullable()();
  TextColumn get filePath => text().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get completedAt => integer().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
