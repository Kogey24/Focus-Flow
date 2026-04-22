import 'package:flutter/material.dart' hide MaterialType;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_flow/domain/enums/material_type.dart' as study;
import 'package:focus_flow/domain/models/chapter.dart';
import 'package:focus_flow/features/add_material/add_material_notifier.dart';
import 'package:focus_flow/features/add_material/add_material_screen.dart';
import 'package:focus_flow/features/add_material/add_material_state.dart';

void main() {
  testWidgets('shows folder scan summary and episode durations for video uploads', (
    tester,
  ) async {
    final state = AddMaterialState(
      type: study.MaterialType.video,
      title: '',
      author: '',
      source: '',
      selectedPaths: const [
        r'C:\imports\NGRX-SIGNALS\episode-1.mp4',
        r'C:\imports\NGRX-SIGNALS\episode-2.mkv',
      ],
      selectedFolderPath: r'C:\imports\NGRX-SIGNALS',
      folderIgnoredFilesCount: 3,
      chapters: const [
        Chapter(
          id: 'chapter-1',
          materialId: 'pending',
          title: 'Episode 1',
          orderIndex: 0,
          duration: 120,
          filePath: r'C:\imports\NGRX-SIGNALS\episode-1.mp4',
        ),
        Chapter(
          id: 'chapter-2',
          materialId: 'pending',
          title: 'Episode 2',
          orderIndex: 1,
          duration: 245,
          filePath: r'C:\imports\NGRX-SIGNALS\episode-2.mkv',
        ),
      ],
      isSaving: false,
      totalDuration: 365,
    );

    await tester.pumpWidget(_TestHarness(state: state));
    await tester.pumpAndSettle();

    expect(find.text('NGRX-SIGNALS'), findsOneWidget);
    expect(
      find.text('Found 2 supported video files ready to import and ignored 3 unsupported files.'),
      findsOneWidget,
    );
    expect(find.text('Episode 1'), findsOneWidget);
    expect(find.text('120 seconds'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Episode 2'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Episode 2'), findsOneWidget);
    expect(find.text('245 seconds'), findsOneWidget);
  });

  testWidgets('shows clear empty-state copy when a folder contains no supported media', (
    tester,
  ) async {
    final state = AddMaterialState(
      type: study.MaterialType.video,
      title: '',
      author: '',
      source: '',
      selectedPaths: const [],
      selectedFolderPath: r'C:\imports\NGRX-SIGNALS',
      folderIgnoredFilesCount: 4,
      chapters: const [],
      isSaving: false,
    );

    await tester.pumpWidget(_TestHarness(state: state));
    await tester.pumpAndSettle();

    expect(
      find.text('Found no supported video files and ignored 4 unsupported files.'),
      findsOneWidget,
    );
    expect(find.text('No supported files found'), findsOneWidget);
    expect(
      find.text(
        'The selected folder does not contain supported video files. It ignored 4 unsupported files.',
      ),
      findsOneWidget,
    );
  });
}

class _TestHarness extends StatelessWidget {
  const _TestHarness({required this.state});

  final AddMaterialState state;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        addMaterialNotifierProvider.overrideWith(() => _FakeAddMaterialNotifier(state)),
      ],
      child: const MaterialApp(
        home: AddMaterialScreen(),
      ),
    );
  }
}

class _FakeAddMaterialNotifier extends AddMaterialNotifier {
  _FakeAddMaterialNotifier(this._initialState);

  final AddMaterialState _initialState;

  @override
  Future<AddMaterialState> build() async => _initialState;
}
