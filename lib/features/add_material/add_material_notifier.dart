import 'dart:io';

import 'package:ffmpeg_kit_audio_flutter/ffprobe_kit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../core/extensions/string_extensions.dart';
import '../../core/utils/file_type_detector.dart';
import '../../core/utils/pdf_toc_parser.dart';
import '../../data/repositories/material_repository.dart';
import '../../domain/enums/material_type.dart';
import '../../domain/models/chapter.dart';
import '../../domain/models/material.dart';
import 'add_material_state.dart';

part 'add_material_notifier.g.dart';

@riverpod
class AddMaterialNotifier extends _$AddMaterialNotifier {
  final Uuid _uuid = const Uuid();
  final PdfTocParser _parser = PdfTocParser();

  @override
  Future<AddMaterialState> build() async {
    return const AddMaterialState(
      type: MaterialType.book,
      title: '',
      author: '',
      source: '',
      selectedPaths: [],
      selectedFolderPath: null,
      chapters: [],
      isSaving: false,
    );
  }

  void setType(MaterialType type) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(
        type: type,
        selectedPaths: [],
        selectedFolderPath: null,
        chapters: [],
        totalDuration: null,
        totalPages: null,
      ),
    );
  }

  void setTitle(String value) => _patch((current) => current.copyWith(title: value));

  void setAuthor(String value) => _patch((current) => current.copyWith(author: value));

  void setSource(String value) => _patch((current) => current.copyWith(source: value));

  void addManualChapter() {
    final current = state.valueOrNull;
    if (current == null) return;
    final chapters = [...current.chapters];
    chapters.add(
      Chapter(
        id: _uuid.v4(),
        materialId: 'pending',
        title: 'New item ${chapters.length + 1}',
        orderIndex: chapters.length,
      ),
    );
    state = AsyncData(current.copyWith(chapters: chapters));
  }

  void updateChapterTitle(int index, String title) {
    final current = state.valueOrNull;
    if (current == null || index >= current.chapters.length) return;
    final chapters = [...current.chapters];
    chapters[index] = chapters[index].copyWith(title: title);
    state = AsyncData(current.copyWith(chapters: chapters));
  }

  void removeChapter(int index) {
    final current = state.valueOrNull;
    if (current == null || index >= current.chapters.length) return;
    final chapters = [...current.chapters]..removeAt(index);
    final normalized = [
      for (var i = 0; i < chapters.length; i++) chapters[i].copyWith(orderIndex: i),
    ];
    state = AsyncData(current.copyWith(chapters: normalized));
  }

  Future<void> pickFiles() async {
    final current = state.valueOrNull;
    if (current == null) return;

    final extensions = switch (current.type) {
      MaterialType.book => ['pdf', 'docx'],
      MaterialType.video => ['mp4', 'mkv', 'mov', 'avi', 'webm'],
      MaterialType.audio => ['mp3', 'aac', 'wav', 'm4a', 'flac'],
      MaterialType.course => <String>[],
    };

    if (current.type == MaterialType.course) return;

    final result = await FilePicker.pickFiles(
      allowMultiple: current.type != MaterialType.book,
      type: FileType.custom,
      allowedExtensions: extensions,
    );
    if (result == null || result.files.isEmpty) return;

    final paths = result.files.map((file) => file.path).whereType<String>().toList();
    await _loadSelectedFiles(paths, selectedFolderPath: null);
  }

  Future<void> pickFolder() async {
    final current = state.valueOrNull;
    if (current == null || current.type == MaterialType.book || current.type == MaterialType.course) {
      return;
    }

    final folderPath = await FilePicker.getDirectoryPath();
    if (folderPath == null) return;

    final files = <File>[];
    await for (final entity in Directory(folderPath).list(recursive: true, followLinks: false)) {
      if (entity is! File) continue;
      if (FileTypeDetector.detectMaterialType(entity.path) != current.type) continue;
      files.add(entity);
    }
    files.sort((a, b) => a.path.compareTo(b.path));

    await _loadSelectedFiles(
      files.map((file) => file.path).toList(growable: false),
      selectedFolderPath: folderPath,
      suggestedTitle: current.title.trim().isEmpty
          ? path.basename(folderPath).filenameLabel()
          : null,
    );
  }

  Future<String?> save() async {
    final current = state.valueOrNull;
    if (current == null) return null;

    final materialId = _uuid.v4();
    state = AsyncData(current.copyWith(isSaving: true));

    final copiedPaths = await _copyFiles(
      materialId,
      current.selectedPaths,
      selectedFolderPath: current.selectedFolderPath,
    );
    final repository = ref.read(materialRepositoryProvider);
    final firstFilePath = copiedPaths.isEmpty ? null : copiedPaths.first;

    final updatedChapters = [
      for (var i = 0; i < current.chapters.length; i++)
        current.chapters[i].copyWith(
          id: current.chapters[i].id == 'pending' ? _uuid.v4() : current.chapters[i].id,
          materialId: materialId,
          orderIndex: i,
          filePath: copiedPaths.length > i ? copiedPaths[i] : current.chapters[i].filePath,
        ),
    ];

    final title = current.title.trim().isEmpty
        ? (current.selectedPaths.isNotEmpty
            ? path.basename(current.selectedPaths.first).filenameLabel()
            : 'Untitled ${current.type.label}')
        : current.title.trim();

    final material = StudyMaterial(
      id: materialId,
      title: title,
      author: current.author.trim().isEmpty ? null : current.author.trim(),
      type: current.type,
      filePath: firstFilePath,
      totalDuration: current.totalDuration,
      totalPages: current.totalPages,
      createdAt: DateTime.now(),
      status: 'not_started',
      tags: current.source.trim().isEmpty ? const [] : [current.source.trim()],
    );

    await repository.saveMaterial(
      material: material,
      chapters: updatedChapters,
    );

    state = const AsyncData(
      AddMaterialState(
        type: MaterialType.book,
        title: '',
        author: '',
        source: '',
        selectedPaths: [],
        selectedFolderPath: null,
        chapters: [],
        isSaving: false,
      ),
    );
    return materialId;
  }

  Future<void> _loadSelectedFiles(
    List<String> paths, {
    required String? selectedFolderPath,
    String? suggestedTitle,
  }) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final sortedPaths = [...paths]..sort();
    var chapters = <Chapter>[];
    int? totalPages;
    int? totalDuration;

    if (current.type == MaterialType.book && sortedPaths.isNotEmpty) {
      final parse = await _parser.parse(
        materialId: 'pending',
        filePath: sortedPaths.first,
      );
      chapters = parse.chapters;
      totalPages = parse.totalPages;
    } else {
      chapters = await Future.wait(
        sortedPaths.asMap().entries.map((entry) async {
          final seconds = await _probeDuration(entry.value);
          totalDuration = (totalDuration ?? 0) + (seconds ?? 0);
          return Chapter(
            id: _uuid.v4(),
            materialId: 'pending',
            title: _mediaLabelForPath(
              filePath: entry.value,
              selectedFolderPath: selectedFolderPath,
            ),
            orderIndex: entry.key,
            duration: seconds,
            filePath: entry.value,
          );
        }),
      );
    }

    state = AsyncData(
      current.copyWith(
        title: suggestedTitle ?? current.title,
        selectedPaths: sortedPaths,
        selectedFolderPath: selectedFolderPath,
        chapters: chapters,
        totalPages: totalPages,
        totalDuration: totalDuration,
      ),
    );
  }

  Future<List<String>> _copyFiles(
    String materialId,
    List<String> sourcePaths, {
    required String? selectedFolderPath,
  }) async {
    if (sourcePaths.isEmpty) return const [];
    final docsDir = await getApplicationDocumentsDirectory();
    final materialDir = Directory(
      path.join(docsDir.path, 'focusflow', 'materials', materialId),
    );
    await materialDir.create(recursive: true);

    final copied = <String>[];
    for (final sourcePath in sourcePaths) {
      final relativePath = selectedFolderPath == null
          ? path.basename(sourcePath)
          : path.relative(sourcePath, from: selectedFolderPath);
      final destination = path.join(materialDir.path, relativePath);
      await Directory(path.dirname(destination)).create(recursive: true);
      await File(sourcePath).copy(destination);
      copied.add(destination);
    }
    return copied;
  }

  Future<int?> _probeDuration(String filePath) async {
    try {
      final session = await FFprobeKit.getMediaInformation(filePath);
      final info = await session.getMediaInformation();
      final rawDuration = info?.getDuration();
      return double.tryParse(rawDuration ?? '')?.round();
    } catch (_) {
      return null;
    }
  }

  void _patch(AddMaterialState Function(AddMaterialState current) update) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(update(current));
  }

  String _mediaLabelForPath({
    required String filePath,
    required String? selectedFolderPath,
  }) {
    if (selectedFolderPath == null) {
      return path.basename(filePath).filenameLabel();
    }

    final relativePath = path.relative(filePath, from: selectedFolderPath);
    final withoutExtension = relativePath.replaceAll(RegExp(r'\.[A-Za-z0-9]+$'), '');
    return withoutExtension
        .replaceAll('\\', ' / ')
        .replaceAll('/', ' / ')
        .replaceAll(RegExp(r'[_\-]+'), ' ')
        .toTitleCase();
  }
}
