import 'package:drift/drift.dart';

@DataClassName('MaterialEntity')
class MaterialsTable extends Table {
  @override
  String get tableName => 'materials';

  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get author => text().nullable()();
  TextColumn get type => text()();
  TextColumn get filePath => text().nullable()();
  TextColumn get thumbnailPath => text().nullable()();
  IntColumn get totalDuration => integer().nullable()();
  IntColumn get totalPages => integer().nullable()();
  IntColumn get createdAt => integer()();
  TextColumn get status => text().withDefault(const Constant('not_started'))();
  TextColumn get tags => text().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
