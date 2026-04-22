import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/chapter_notes_table.dart';
import 'tables/chapters_table.dart';
import 'tables/focus_sessions_table.dart';
import 'tables/materials_table.dart';
import 'tables/progress_snapshots_table.dart';
import 'tables/streaks_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    MaterialsTable,
    ChaptersTable,
    FocusSessionsTable,
    ProgressSnapshotsTable,
    StreaksTable,
    ChapterNotesTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  Future<void> clearAllData() async {
    await transaction(() async {
      await delete(chapterNotesTable).go();
      await delete(progressSnapshotsTable).go();
      await delete(focusSessionsTable).go();
      await delete(chaptersTable).go();
      await delete(streaksTable).go();
      await delete(materialsTable).go();
    });
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'focus_flow',
    native: const DriftNativeOptions(
      shareAcrossIsolates: true,
    ),
  );
}
