import 'package:drift/drift.dart';

import 'chapters_table.dart';

@DataClassName('ChapterNoteEntity')
class ChapterNotesTable extends Table {
  @override
  String get tableName => 'chapter_notes';

  TextColumn get id => text()();
  TextColumn get chapterId => text().references(ChaptersTable, #id)();
  TextColumn get note => text()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
