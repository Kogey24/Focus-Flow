import 'package:drift/drift.dart';

@DataClassName('StreakEntity')
@TableIndex(name: 'streaks_date_idx', columns: {#date})
class StreaksTable extends Table {
  @override
  String get tableName => 'streaks';

  TextColumn get id => text()();
  TextColumn get date => text()();
  IntColumn get totalFocusSeconds => integer().withDefault(const Constant(0))();
  IntColumn get sessionCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
