import 'dart:async';
import 'dart:io';

import 'package:drift/native.dart' show SqliteException;
import 'package:ffmpeg_kit_audio_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_audio_flutter/ffprobe_kit.dart';
import 'package:ffmpeg_kit_audio_flutter/return_code.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../core/services/storage_alert_service.dart';
import '../../core/extensions/string_extensions.dart';
import '../../core/utils/pdf_toc_parser.dart';
import '../../data/repositories/material_repository.dart';
import '../../domain/enums/material_type.dart';
import '../../domain/models/chapter.dart';
import '../../domain/models/material.dart';
import 'add_material_state.dart';
import 'course_import_service.dart';

part 'add_material_notifier.g.dart';

@Riverpod(keepAlive: true)
class AddMaterialNotifier extends _$AddMaterialNotifier {
  static const MethodChannel _mediaFolderChannel = MethodChannel(
    'focus_flow/media_folder',
  );
  static const int _videoCompressionThresholdBytes = 25 * 1024 * 1024;
  static const int _audioCompressionThresholdBytes = 5 * 1024 * 1024;
  static const int _sqliteFullResultCode = 13;
  static const double _fileTransferPhaseWeight = 0.92;
  final Uuid _uuid = const Uuid();
  final PdfTocParser _parser = PdfTocParser();
  double _lastReportedUploadProgress = -1;

  @override
  Future<AddMaterialState> build() async {
    return const AddMaterialState(
      type: MaterialType.book,
      title: '',
      author: '',
      source: '',
      selectedPaths: [],
      selectedFolderPath: null,
      folderIgnoredFilesCount: null,
      chapters: [],
      isSaving: false,
      isImporting: false,
      importWarnings: [],
      uploadProgress: 0,
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
        folderIgnoredFilesCount: null,
        chapters: [],
        totalDuration: null,
        totalPages: null,
        isImporting: false,
        importError: null,
        importWarnings: const [],
        thumbnailPath: null,
        importerLabel: null,
        isPreparingSelection: false,
        selectionStatus: null,
        uploadProgress: 0,
        uploadStatus: null,
        saveError: null,
        isStorageFull: false,
      ),
    );
  }

  void setTitle(String value) =>
      _patch((current) => current.copyWith(title: value));

  void setAuthor(String value) =>
      _patch((current) => current.copyWith(author: value));

  void setSource(String value) =>
      _patch((current) => current.copyWith(source: value));

  void addManualChapter() {
    final current = state.valueOrNull;
    if (current == null) return;
    final chapters = [...current.chapters];
    chapters.add(
      Chapter(
        id: _uuid.v4(),
        materialId: 'pending',
        title: '${_manualChapterLabel(current.type)} ${chapters.length + 1}',
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
      for (var i = 0; i < chapters.length; i++)
        chapters[i].copyWith(orderIndex: i),
    ];
    state = AsyncData(current.copyWith(chapters: normalized));
  }

  Future<void> pickFiles() async {
    final current = state.valueOrNull;
    if (current == null) return;

    final extensions = _allowedExtensionsFor(current.type);

    if (current.type == MaterialType.course) return;

    try {
      final result = await FilePicker.pickFiles(
        allowMultiple: current.type != MaterialType.book,
        type: FileType.custom,
        allowedExtensions: extensions,
      );
      if (result == null) {
        _debugLog('[AddMaterial][files] Picker cancelled by the user.');
        return;
      }
      if (result.files.isEmpty) {
        _debugLog(
          '[AddMaterial][files][warn] Picker returned an empty selection.',
        );
        _setSelectionError(
          'No files were returned from the picker. Please try selecting the material again.',
          fallback: current,
        );
        return;
      }

      final paths = result.files
          .map((file) => file.path)
          .whereType<String>()
          .where((path) => path.trim().isNotEmpty)
          .toList(growable: false);

      if (paths.isEmpty) {
        _debugLogBlock([
          '[AddMaterial][files][warn] Picker returned ${result.files.length} file(s), but none exposed a readable cache path.',
          for (var i = 0; i < result.files.length; i++)
            '[AddMaterial][files][warn] raw[$i] name=${result.files[i].name} path=${result.files[i].path ?? '(null)'} identifier=${result.files[i].identifier ?? '(null)'}',
        ]);
        _setSelectionError(
          'The selected file could not be opened from this location. Please choose a file stored on the device and try again.',
          fallback: current,
        );
        return;
      }

      _debugLogBlock([
        '[AddMaterial][files] Selected ${paths.length} ${current.type.label.toLowerCase()} file(s).',
        for (var i = 0; i < paths.length; i++)
          '[AddMaterial][files] file[$i]=${paths[i]}',
      ]);
      await _loadSelectedFiles(
        paths,
        selectedFolderPath: null,
        folderIgnoredFilesCount: null,
      );
    } catch (error, stackTrace) {
      _debugLog(
        '[AddMaterial][files][error] The picker failed: $error\n$stackTrace',
      );
      _setSelectionError(
        'The file picker could not open that material right now. Please try again.',
        fallback: current,
      );
    }
  }

  Future<void> pickFolder() async {
    final current = state.valueOrNull;
    if (current == null ||
        current.type == MaterialType.book ||
        current.type == MaterialType.course) {
      return;
    }

    _debugLog(
      '[AddMaterial][folder] Opening folder picker for ${current.type.label.toLowerCase()} uploads.',
    );

    if (Platform.isAndroid) {
      final selection = await _pickAndroidMediaFolder(current.type);
      if (selection != null) {
        await _loadSelectedFiles(
          selection.files,
          selectedFolderPath: selection.rootPath,
          folderIgnoredFilesCount: selection.ignoredFilesCount,
          suggestedTitle: current.title.trim().isEmpty
              ? selection.folderName.filenameLabel()
              : null,
        );
        return;
      }
    }

    await _pickFolderFromFileSystem(current);
  }

  Future<void> importCourseFromUrl() async {
    final current = state.valueOrNull;
    if (current == null || current.type != MaterialType.course) return;

    final rawUrl = current.source.trim();
    if (rawUrl.isEmpty) {
      state = AsyncData(
        current.copyWith(
          isImporting: false,
          importError: 'Paste a course URL first.',
          importWarnings: const [],
          importerLabel: null,
          saveError: null,
          isStorageFull: false,
        ),
      );
      return;
    }

    state = AsyncData(
      current.copyWith(
        isImporting: true,
        importError: null,
        importWarnings: const [],
        saveError: null,
        isStorageFull: false,
      ),
    );

    try {
      final preview = await ref
          .read(courseImportServiceProvider)
          .importFromUrl(rawUrl);
      final importedChapters = preview.items
          .asMap()
          .entries
          .map(
            (entry) => Chapter(
              id: _uuid.v4(),
              materialId: 'pending',
              title: entry.value.displayTitle,
              orderIndex: entry.key,
              duration: entry.value.durationSeconds,
              filePath: entry.value.sourceUrl,
            ),
          )
          .toList(growable: false);

      state = AsyncData(
        current.copyWith(
          title: current.title.trim().isEmpty ? preview.title : current.title,
          author: current.author.trim().isEmpty
              ? (preview.provider ?? current.author)
              : current.author,
          source: preview.sourceUrl,
          chapters: importedChapters.isEmpty
              ? current.chapters
              : importedChapters,
          totalPages: null,
          totalDuration: importedChapters.isEmpty
              ? current.totalDuration
              : preview.totalDuration,
          isImporting: false,
          importError: null,
          importWarnings: preview.warnings,
          thumbnailPath: preview.thumbnailUrl,
          importerLabel: preview.importerLabel,
          saveError: null,
          isStorageFull: false,
        ),
      );
    } on CourseImportException catch (error) {
      state = AsyncData(
        current.copyWith(
          isImporting: false,
          importError: error.message,
          saveError: null,
          isStorageFull: false,
        ),
      );
    } catch (_) {
      state = AsyncData(
        current.copyWith(
          isImporting: false,
          importError: 'The course outline could not be imported right now.',
          saveError: null,
          isStorageFull: false,
        ),
      );
    }
  }

  Future<String?> save() async {
    final current = state.valueOrNull;
    if (current == null) return null;

    final materialId = _uuid.v4();
    _lastReportedUploadProgress = -1;
    state = AsyncData(
      current.copyWith(
        isSaving: true,
        uploadProgress: 0,
        uploadStatus: _initialUploadStatus(current),
        saveError: null,
        isStorageFull: false,
      ),
    );

    try {
      final copiedPaths = await _copyFiles(
        materialId,
        current.selectedPaths,
        selectedFolderPath: current.selectedFolderPath,
        type: current.type,
        onProgress: _setUploadProgress,
      );
      final repository = ref.read(materialRepositoryProvider);
      final firstFilePath = copiedPaths.isEmpty ? null : copiedPaths.first;

      _setUploadProgress(
        0.95,
        status: current.selectedPaths.isEmpty
            ? 'Saving material to the library...'
            : 'Finishing the upload...',
        force: true,
      );

      final updatedChapters = [
        for (var i = 0; i < current.chapters.length; i++)
          current.chapters[i].copyWith(
            id: current.chapters[i].id == 'pending'
                ? _uuid.v4()
                : current.chapters[i].id,
            materialId: materialId,
            orderIndex: i,
            filePath: copiedPaths.length > i
                ? copiedPaths[i]
                : current.chapters[i].filePath,
          ),
      ];

      final title = current.title.trim().isEmpty
          ? (current.type == MaterialType.course
                ? _fallbackCourseTitle(current.source)
                : (current.selectedPaths.isNotEmpty
                      ? path
                            .basename(current.selectedPaths.first)
                            .filenameLabel()
                      : 'Untitled ${current.type.label}'))
          : current.title.trim();

      final material = StudyMaterial(
        id: materialId,
        title: title,
        author: current.author.trim().isEmpty ? null : current.author.trim(),
        type: current.type,
        filePath: current.type == MaterialType.course
            ? (current.source.trim().isEmpty ? null : current.source.trim())
            : firstFilePath,
        thumbnailPath: current.thumbnailPath,
        totalDuration: current.totalDuration,
        totalPages: current.totalPages,
        createdAt: DateTime.now(),
        status: 'not_started',
        tags: current.source.trim().isEmpty
            ? const []
            : [current.source.trim()],
      );

      _logSavePayload(
        material: material,
        chapters: updatedChapters,
        selectedFolderPath: current.selectedFolderPath,
        copiedPaths: copiedPaths,
      );

      await repository.saveMaterial(
        material: material,
        chapters: updatedChapters,
      );

      _setUploadProgress(1, status: 'Upload complete.', force: true);

      _debugLog(
        '[AddMaterial][save] Material saved successfully with id=$materialId.',
      );

      state = const AsyncData(
        AddMaterialState(
          type: MaterialType.book,
          title: '',
          author: '',
          source: '',
          selectedPaths: [],
          selectedFolderPath: null,
          folderIgnoredFilesCount: null,
          chapters: [],
          isSaving: false,
          isImporting: false,
          importWarnings: [],
          uploadProgress: 0,
        ),
      );
      return materialId;
    } catch (error, stackTrace) {
      final failure = _classifySaveFailure(error);
      _debugLog(
        '[AddMaterial][save] Save failed for id=$materialId: $error\n$stackTrace',
      );
      await _deleteCopiedFilesForMaterial(materialId);

      if (failure.isStorageFull) {
        unawaited(
          ref
              .read(storageAlertServiceProvider)
              .notifyDatabaseFull(body: failure.message),
        );
      }

      final latest = state.valueOrNull ?? current;
      state = AsyncData(
        latest.copyWith(
          isSaving: false,
          uploadStatus: null,
          saveError: failure.message,
          isStorageFull: failure.isStorageFull,
        ),
      );
      return null;
    }
  }

  Future<void> _loadSelectedFiles(
    List<String> paths, {
    required String? selectedFolderPath,
    required int? folderIgnoredFilesCount,
    String? suggestedTitle,
  }) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final sortedPaths = [...paths]..sort();
    var chapters = <Chapter>[];
    int? totalPages;
    int? totalDuration;
    final nextTitle = _selectionTitleForPaths(
      current: current,
      sortedPaths: sortedPaths,
      suggestedTitle: suggestedTitle,
    );

    _debugLogBlock([
      '[AddMaterial][load] Received ${sortedPaths.length} path(s) for ${current.type.label.toLowerCase()}.',
      '[AddMaterial][load] selectedFolderPath=${selectedFolderPath ?? '(none)'}',
      '[AddMaterial][load] ignoredFilesCount=${folderIgnoredFilesCount ?? 0}',
      for (var i = 0; i < sortedPaths.length; i++)
        '[AddMaterial][load] input[$i]=${sortedPaths[i]}',
    ]);

    state = AsyncData(
      current.copyWith(
        title: nextTitle,
        selectedPaths: sortedPaths,
        selectedFolderPath: selectedFolderPath,
        folderIgnoredFilesCount: folderIgnoredFilesCount,
        chapters: const [],
        totalPages: null,
        totalDuration: null,
        importError: null,
        importWarnings: const [],
        thumbnailPath: null,
        importerLabel: null,
        isPreparingSelection: true,
        selectionStatus: _selectionStatusForPaths(
          type: current.type,
          sortedPaths: sortedPaths,
        ),
        saveError: null,
        isStorageFull: false,
      ),
    );

    try {
      if (current.type == MaterialType.book && sortedPaths.isNotEmpty) {
        final parse = await _parser.parse(
          materialId: 'pending',
          filePath: sortedPaths.first,
        );
        chapters = parse.chapters;
        totalPages = parse.totalPages;
        _logPreparedStructure(
          stage: 'parsed book structure',
          type: current.type,
          chapters: chapters,
          selectedFolderPath: selectedFolderPath,
          ignoredFilesCount: folderIgnoredFilesCount,
          totalPages: totalPages,
          totalDuration: totalDuration,
        );
      } else {
        chapters = sortedPaths
            .asMap()
            .entries
            .map((entry) {
              return Chapter(
                id: _uuid.v4(),
                materialId: 'pending',
                title: _mediaLabelForPath(
                  filePath: entry.value,
                  selectedFolderPath: selectedFolderPath,
                ),
                orderIndex: entry.key,
                filePath: entry.value,
              );
            })
            .toList(growable: false);

        state = AsyncData(
          (state.valueOrNull ?? current).copyWith(chapters: chapters),
        );

        _logPreparedStructure(
          stage: 'generated media items',
          type: current.type,
          chapters: chapters,
          selectedFolderPath: selectedFolderPath,
          ignoredFilesCount: folderIgnoredFilesCount,
          totalPages: null,
          totalDuration: null,
        );

        final chaptersWithDurations = await Future.wait(
          chapters.map((chapter) async {
            final seconds = await _probeDuration(chapter.filePath ?? '');
            totalDuration = (totalDuration ?? 0) + (seconds ?? 0);
            _debugLog(
              '[AddMaterial][duration] "${chapter.title}" => ${seconds == null ? 'duration unavailable' : '$seconds seconds'}',
            );
            return chapter.copyWith(duration: seconds);
          }),
        );

        final latest = state.valueOrNull;
        if (latest == null || !listEquals(latest.selectedPaths, sortedPaths)) {
          return;
        }
        state = AsyncData(
          latest.copyWith(
            chapters: chaptersWithDurations,
            totalDuration: totalDuration,
            isPreparingSelection: false,
            selectionStatus: null,
          ),
        );
        _logPreparedStructure(
          stage: 'media durations resolved',
          type: current.type,
          chapters: chaptersWithDurations,
          selectedFolderPath: selectedFolderPath,
          ignoredFilesCount: folderIgnoredFilesCount,
          totalPages: null,
          totalDuration: totalDuration,
        );
        return;
      }

      state = AsyncData(
        (state.valueOrNull ?? current).copyWith(
          chapters: chapters,
          totalPages: totalPages,
          totalDuration: totalDuration,
          isPreparingSelection: false,
          selectionStatus: null,
        ),
      );
    } catch (_) {
      final latest = state.valueOrNull ?? current;
      state = AsyncData(
        latest.copyWith(isPreparingSelection: false, selectionStatus: null),
      );
      rethrow;
    }
  }

  Future<List<String>> _copyFiles(
    String materialId,
    List<String> sourcePaths, {
    required String? selectedFolderPath,
    required MaterialType type,
    required void Function(double progress, {String? status}) onProgress,
  }) async {
    if (sourcePaths.isEmpty) return const [];
    final docsDir = await getApplicationDocumentsDirectory();
    final materialDir = Directory(
      path.join(docsDir.path, 'focusflow', 'materials', materialId),
    );
    await materialDir.create(recursive: true);

    final sourceFiles = sourcePaths.map(File.new).toList(growable: false);
    final sourceSizes = await Future.wait(
      sourceFiles.map((file) => file.length()),
    );
    final totalBytes = sourceSizes.fold<int>(0, (sum, value) => sum + value);
    var completedBytes = 0;
    final copied = <String>[];
    for (var i = 0; i < sourcePaths.length; i++) {
      final sourcePath = sourcePaths[i];
      final sourceSize = sourceSizes[i];
      final relativePath = selectedFolderPath == null
          ? path.basename(sourcePath)
          : path.relative(sourcePath, from: selectedFolderPath);
      final itemStatus = sourcePaths.length == 1
          ? 'Uploading material...'
          : 'Uploading file ${i + 1} of ${sourcePaths.length}...';
      onProgress(
        _scaledUploadProgress(completedBytes, totalBytes),
        status: itemStatus,
      );
      copied.add(
        await _copyOrOptimizeMediaFile(
          sourcePath: sourcePath,
          destinationRoot: materialDir.path,
          relativePath: relativePath,
          type: type,
          onProgress: (fileProgress) {
            final processedBytes =
                completedBytes + (sourceSize * fileProgress).round();
            onProgress(
              _scaledUploadProgress(processedBytes, totalBytes),
              status: itemStatus,
            );
          },
        ),
      );
      completedBytes += sourceSize;
      onProgress(
        _scaledUploadProgress(completedBytes, totalBytes),
        status: itemStatus,
      );
    }
    return copied;
  }

  Future<int?> _probeDuration(String filePath) async {
    try {
      final session = await FFprobeKit.getMediaInformation(filePath);
      final info = session.getMediaInformation();
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

  String _manualChapterLabel(MaterialType type) {
    return switch (type) {
      MaterialType.book => 'New chapter',
      MaterialType.video => 'New episode',
      MaterialType.audio => 'New track',
      MaterialType.course => 'New topic',
    };
  }

  String _fallbackCourseTitle(String source) {
    final uri = Uri.tryParse(source.trim());
    final host = uri?.host.replaceFirst(RegExp(r'^www\.'), '');
    if (host == null || host.trim().isEmpty) {
      return 'Untitled Course';
    }
    return host
        .split('.')
        .first
        .replaceAll(RegExp(r'[_-]+'), ' ')
        .toTitleCase();
  }

  String _mediaLabelForPath({
    required String filePath,
    required String? selectedFolderPath,
  }) {
    if (selectedFolderPath == null) {
      return path.basename(filePath).filenameLabel();
    }

    final relativePath = path.relative(filePath, from: selectedFolderPath);
    final withoutExtension = relativePath.replaceAll(
      RegExp(r'\.[A-Za-z0-9]+$'),
      '',
    );
    return withoutExtension
        .replaceAll('\\', ' / ')
        .replaceAll('/', ' / ')
        .replaceAll(RegExp(r'[_\-]+'), ' ')
        .toTitleCase();
  }

  Future<_PickedMediaFolder?> _pickAndroidMediaFolder(MaterialType type) async {
    final allowedExtensions = _allowedExtensionsFor(type);

    if (allowedExtensions.isEmpty) return null;

    try {
      final result = await _mediaFolderChannel
          .invokeMapMethod<String, Object?>('pickMediaFolder', {
            'allowedExtensions': allowedExtensions,
            'mediaType': switch (type) {
              MaterialType.video => 'video',
              MaterialType.audio => 'audio',
              _ => '',
            },
          });
      if (result == null) return null;

      final rootPath = result['rootPath'] as String?;
      final folderName = result['folderName'] as String?;
      final files =
          (result['files'] as List<Object?>?)?.whereType<String>().toList(
            growable: false,
          ) ??
          const [];
      final ignoredFilesCount =
          (result['ignoredFilesCount'] as num?)?.toInt() ?? 0;
      if (rootPath == null || folderName == null) return null;

      _logFolderSelection(
        source: 'android-channel',
        type: type,
        folderPath: rootPath,
        files: files,
        ignoredFilesCount: ignoredFilesCount,
      );

      return _PickedMediaFolder(
        rootPath: rootPath,
        folderName: folderName,
        files: files,
        ignoredFilesCount: ignoredFilesCount,
      );
    } on MissingPluginException catch (error) {
      debugPrint(
        'Media folder channel unavailable, falling back to filesystem scan: $error',
      );
      return null;
    } on PlatformException catch (error) {
      debugPrint(
        'Media folder channel failed, falling back to filesystem scan: ${error.message}',
      );
      return null;
    }
  }

  Future<void> _pickFolderFromFileSystem(AddMaterialState current) async {
    final folderPath = await FilePicker.getDirectoryPath();
    if (folderPath == null) return;

    final allowedExtensions = _allowedExtensionsFor(current.type).toSet();
    final files = <File>[];
    var ignoredFilesCount = 0;
    await for (final entity in Directory(
      folderPath,
    ).list(recursive: true, followLinks: false)) {
      if (entity is! File) continue;
      final isSupported = await _matchesMaterialType(
        filePath: entity.path,
        type: current.type,
        allowedExtensions: allowedExtensions,
      );
      if (!isSupported) {
        ignoredFilesCount++;
        continue;
      }
      files.add(entity);
    }
    files.sort((a, b) => a.path.compareTo(b.path));

    _logFolderSelection(
      source: 'filesystem',
      type: current.type,
      folderPath: folderPath,
      files: files.map((file) => file.path).toList(growable: false),
      ignoredFilesCount: ignoredFilesCount,
    );

    await _loadSelectedFiles(
      files.map((file) => file.path).toList(growable: false),
      selectedFolderPath: folderPath,
      folderIgnoredFilesCount: ignoredFilesCount,
      suggestedTitle: current.title.trim().isEmpty
          ? path.basename(folderPath).filenameLabel()
          : null,
    );
  }

  List<String> _allowedExtensionsFor(MaterialType type) {
    return switch (type) {
      MaterialType.book => ['pdf', 'docx'],
      MaterialType.video => [
        'mp4',
        'mkv',
        'mov',
        'avi',
        'webm',
        'm4v',
        '3gp',
        'mpeg',
        'mpg',
        'ts',
      ],
      MaterialType.audio => [
        'mp3',
        'aac',
        'wav',
        'm4a',
        'flac',
        'ogg',
        'opus',
        'wma',
      ],
      MaterialType.course => const <String>[],
    };
  }

  Future<bool> _matchesMaterialType({
    required String filePath,
    required MaterialType type,
    required Set<String> allowedExtensions,
  }) async {
    final extension = path
        .extension(filePath)
        .replaceFirst('.', '')
        .toLowerCase();
    if (allowedExtensions.contains(extension)) {
      return true;
    }

    try {
      final session = await FFprobeKit.getMediaInformation(filePath);
      final info = session.getMediaInformation();
      final streamTypes =
          info
              ?.getStreams()
              .map((stream) => stream.getType()?.toLowerCase())
              .whereType<String>()
              .toSet() ??
          const <String>{};
      return switch (type) {
        MaterialType.video => streamTypes.contains('video'),
        MaterialType.audio =>
          streamTypes.contains('audio') && !streamTypes.contains('video'),
        _ => false,
      };
    } catch (_) {
      return false;
    }
  }

  Future<String> _copyOrOptimizeMediaFile({
    required String sourcePath,
    required String destinationRoot,
    required String relativePath,
    required MaterialType type,
    required void Function(double progress) onProgress,
  }) async {
    final sourceFile = File(sourcePath);
    final originalDestination = path.join(destinationRoot, relativePath);
    await Directory(path.dirname(originalDestination)).create(recursive: true);

    if (!_shouldCompressFile(sourceFile: sourceFile, type: type)) {
      await _copyFileWithProgress(
        sourceFile: sourceFile,
        destinationFile: File(originalDestination),
        onProgress: onProgress,
      );
      return originalDestination;
    }

    final optimizedDestination = _optimizedDestinationPath(
      destinationRoot: destinationRoot,
      relativePath: relativePath,
      type: type,
    );
    await Directory(path.dirname(optimizedDestination)).create(recursive: true);

    final compressed = await _compressMediaFile(
      sourcePath: sourcePath,
      destinationPath: optimizedDestination,
      type: type,
      onProgress: (progress) => onProgress(progress * 0.85),
    );

    if (compressed != null) {
      onProgress(1);
      return compressed;
    }

    if (await File(optimizedDestination).exists()) {
      await File(optimizedDestination).delete();
    }
    await _copyFileWithProgress(
      sourceFile: sourceFile,
      destinationFile: File(originalDestination),
      onProgress: (progress) => onProgress(0.85 + (progress * 0.15)),
    );
    return originalDestination;
  }

  bool _shouldCompressFile({
    required File sourceFile,
    required MaterialType type,
  }) {
    final length = sourceFile.lengthSync();
    return switch (type) {
      MaterialType.video => length >= _videoCompressionThresholdBytes,
      MaterialType.audio => length >= _audioCompressionThresholdBytes,
      _ => false,
    };
  }

  String _optimizedDestinationPath({
    required String destinationRoot,
    required String relativePath,
    required MaterialType type,
  }) {
    final normalizedDirectory = path.dirname(relativePath);
    final baseName = path.basenameWithoutExtension(relativePath);
    final originalExtension = path
        .extension(relativePath)
        .replaceFirst('.', '')
        .toLowerCase();
    final optimizedExtension = switch (type) {
      MaterialType.video => '.mp4',
      MaterialType.audio => '.m4a',
      _ => path.extension(relativePath),
    };
    final optimizedName = originalExtension.isEmpty
        ? '${baseName}_focusflow$optimizedExtension'
        : '${baseName}_${originalExtension}_focusflow$optimizedExtension';
    return normalizedDirectory == '.'
        ? path.join(destinationRoot, optimizedName)
        : path.join(destinationRoot, normalizedDirectory, optimizedName);
  }

  Future<String?> _compressMediaFile({
    required String sourcePath,
    required String destinationPath,
    required MaterialType type,
    void Function(double progress)? onProgress,
  }) async {
    final sourceFile = File(sourcePath);
    final compressionArgs = await _compressionArguments(
      sourcePath: sourcePath,
      destinationPath: destinationPath,
      type: type,
    );
    if (compressionArgs == null) return null;

    try {
      final sourceDurationSeconds = await _probeDuration(sourcePath);
      final session = await FFmpegKit.executeWithArgumentsAsync(
        compressionArgs,
        null,
        null,
        sourceDurationSeconds == null || sourceDurationSeconds <= 0
            ? null
            : (statistics) {
                final elapsedSeconds = statistics.getTime() / 1000;
                final progress = (elapsedSeconds / sourceDurationSeconds).clamp(
                  0,
                  0.99,
                );
                onProgress?.call(progress.toDouble());
              },
      );
      final returnCode = await session.getReturnCode();
      final outputFile = File(destinationPath);
      if (!ReturnCode.isSuccess(returnCode) || !await outputFile.exists()) {
        return null;
      }

      final originalSize = await sourceFile.length();
      final compressedSize = await outputFile.length();
      if (compressedSize <= 0 || compressedSize >= originalSize) {
        await outputFile.delete();
        return null;
      }

      return destinationPath;
    } catch (_) {
      return null;
    }
  }

  Future<void> _copyFileWithProgress({
    required File sourceFile,
    required File destinationFile,
    required void Function(double progress) onProgress,
  }) async {
    final totalBytes = await sourceFile.length();
    if (totalBytes <= 0) {
      await sourceFile.copy(destinationFile.path);
      onProgress(1);
      return;
    }

    final sink = destinationFile.openWrite();
    var copiedBytes = 0;

    try {
      await for (final chunk in sourceFile.openRead()) {
        sink.add(chunk);
        copiedBytes += chunk.length;
        onProgress((copiedBytes / totalBytes).clamp(0, 1).toDouble());
      }
      await sink.flush();
      onProgress(1);
    } finally {
      await sink.close();
    }
  }

  Future<List<String>?> _compressionArguments({
    required String sourcePath,
    required String destinationPath,
    required MaterialType type,
  }) async {
    return switch (type) {
      MaterialType.video => _videoCompressionArguments(
        sourcePath: sourcePath,
        destinationPath: destinationPath,
      ),
      MaterialType.audio => _audioCompressionArguments(
        sourcePath: sourcePath,
        destinationPath: destinationPath,
      ),
      _ => null,
    };
  }

  Future<List<String>> _videoCompressionArguments({
    required String sourcePath,
    required String destinationPath,
  }) async {
    final dimensions = await _probeVideoDimensions(sourcePath);
    final args = <String>[
      '-y',
      '-i',
      sourcePath,
      '-map_metadata',
      '0',
      '-movflags',
      '+faststart',
      '-c:v',
      'libx264',
      '-preset',
      'veryfast',
      '-crf',
      '30',
      '-c:a',
      'aac',
      '-b:a',
      '128k',
    ];

    final scale = _downscaleFilter(dimensions);
    if (scale != null) {
      args.addAll(['-vf', scale]);
    }

    args.add(destinationPath);
    return args;
  }

  Future<List<String>> _audioCompressionArguments({
    required String sourcePath,
    required String destinationPath,
  }) async {
    return <String>[
      '-y',
      '-i',
      sourcePath,
      '-map_metadata',
      '0',
      '-vn',
      '-c:a',
      'aac',
      '-b:a',
      '96k',
      destinationPath,
    ];
  }

  Future<({int width, int height})?> _probeVideoDimensions(
    String filePath,
  ) async {
    try {
      final session = await FFprobeKit.getMediaInformation(filePath);
      final info = session.getMediaInformation();
      final videoStream = info?.getStreams().firstWhere(
        (stream) => stream.getType()?.toLowerCase() == 'video',
      );
      final width = videoStream?.getWidth();
      final height = videoStream?.getHeight();
      if (width == null || height == null || width <= 0 || height <= 0) {
        return null;
      }
      return (width: width, height: height);
    } catch (_) {
      return null;
    }
  }

  String? _downscaleFilter(({int width, int height})? dimensions) {
    if (dimensions == null) return null;

    const maxEdge = 1280;
    final width = dimensions.width;
    final height = dimensions.height;
    if (width <= maxEdge && height <= maxEdge) {
      return null;
    }

    if (width >= height) {
      final scaledHeight = _evenDimension((height * maxEdge) / width);
      return 'scale=$maxEdge:$scaledHeight';
    }

    final scaledWidth = _evenDimension((width * maxEdge) / height);
    return 'scale=$scaledWidth:$maxEdge';
  }

  int _evenDimension(num value) {
    final rounded = value.round();
    if (rounded <= 2) return 2;
    return rounded.isEven ? rounded : rounded - 1;
  }

  void _setUploadProgress(
    double progress, {
    String? status,
    bool force = false,
  }) {
    final current = state.valueOrNull;
    if (current == null) return;

    final normalized = progress.clamp(0, 1).toDouble();
    final nextStatus = status ?? current.uploadStatus;
    final shouldUpdate =
        force ||
        (normalized - _lastReportedUploadProgress).abs() >= 0.01 ||
        nextStatus != current.uploadStatus;
    if (!shouldUpdate) return;

    _lastReportedUploadProgress = normalized;
    state = AsyncData(
      current.copyWith(uploadProgress: normalized, uploadStatus: nextStatus),
    );
  }

  void _setSelectionError(String message, {AddMaterialState? fallback}) {
    final current = state.valueOrNull ?? fallback;
    if (current == null) return;

    state = AsyncData(
      current.copyWith(
        isPreparingSelection: false,
        selectionStatus: null,
        saveError: message,
        isStorageFull: false,
      ),
    );
  }

  String _selectionTitleForPaths({
    required AddMaterialState current,
    required List<String> sortedPaths,
    required String? suggestedTitle,
  }) {
    if (suggestedTitle != null && suggestedTitle.trim().isNotEmpty) {
      return suggestedTitle;
    }
    if (current.title.trim().isNotEmpty) {
      return current.title;
    }
    if (sortedPaths.length == 1) {
      return path.basename(sortedPaths.first).filenameLabel();
    }
    return current.title;
  }

  String _selectionStatusForPaths({
    required MaterialType type,
    required List<String> sortedPaths,
  }) {
    return switch (type) {
      MaterialType.book => 'Reading the selected document...',
      MaterialType.video when sortedPaths.length > 1 =>
        'Preparing ${sortedPaths.length} video files...',
      MaterialType.audio when sortedPaths.length > 1 =>
        'Preparing ${sortedPaths.length} audio files...',
      MaterialType.video => 'Preparing the selected video...',
      MaterialType.audio => 'Preparing the selected audio...',
      MaterialType.course => 'Preparing the selected material...',
    };
  }

  double _scaledUploadProgress(int processedBytes, int totalBytes) {
    if (totalBytes <= 0) return _fileTransferPhaseWeight;
    final fileShare = (processedBytes / totalBytes).clamp(0, 1).toDouble();
    return fileShare * _fileTransferPhaseWeight;
  }

  String _initialUploadStatus(AddMaterialState current) {
    if (current.selectedPaths.isEmpty) {
      return 'Saving material to the library...';
    }
    return current.selectedPaths.length == 1
        ? 'Preparing the upload...'
        : 'Preparing ${current.selectedPaths.length} files...';
  }

  _SaveFailure _classifySaveFailure(Object error) {
    final errorText = error.toString().toLowerCase();
    if (error is SqliteException && error.resultCode == _sqliteFullResultCode) {
      return const _SaveFailure(
        message:
            'Focus Flow storage is full, so this material could not be saved. Clear some saved materials or app data, then try again.',
        isStorageFull: true,
      );
    }

    if (error is FileSystemException) {
      final errorCode = error.osError?.errorCode;
      if (errorCode == 28 ||
          errorCode == 112 ||
          errorText.contains('no space left on device') ||
          errorText.contains('space left')) {
        return const _SaveFailure(
          message:
              'Focus Flow storage is full, so this upload could not finish. Free up device space, then try again.',
          isStorageFull: true,
        );
      }
    }

    if (errorText.contains('database or disk is full') ||
        errorText.contains('sqlite_full') ||
        errorText.contains('disk is full')) {
      return const _SaveFailure(
        message:
            'Focus Flow storage is full, so this material could not be saved. Clear some saved materials or app data, then try again.',
        isStorageFull: true,
      );
    }

    return const _SaveFailure(
      message:
          'The material could not be added right now. Check the files and try again.',
      isStorageFull: false,
    );
  }

  Future<void> _deleteCopiedFilesForMaterial(String materialId) async {
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final materialDir = Directory(
        path.join(docsDir.path, 'focusflow', 'materials', materialId),
      );
      if (await materialDir.exists()) {
        await materialDir.delete(recursive: true);
      }
    } catch (_) {
      // Best effort cleanup after a failed save.
    }
  }

  void _debugLog(String message) {
    if (!kDebugMode) return;
    debugPrint(message);
  }

  void _debugLogBlock(Iterable<String> lines) {
    if (!kDebugMode) return;
    for (final line in lines) {
      debugPrint(line);
    }
  }

  void _logFolderSelection({
    required String source,
    required MaterialType type,
    required String folderPath,
    required List<String> files,
    required int ignoredFilesCount,
  }) {
    final lowerType = type.label.toLowerCase();
    _debugLogBlock([
      '[AddMaterial][folder][$source] folderPath=$folderPath',
      '[AddMaterial][folder][$source] supported${lowerType}Files=${files.length}',
      '[AddMaterial][folder][$source] ignoredFiles=$ignoredFilesCount',
      if (files.isEmpty)
        '[AddMaterial][folder][$source] Remark: no supported $lowerType files were found in the selected folder.',
      for (var i = 0; i < files.length; i++)
        '[AddMaterial][folder][$source] file[$i]=${files[i]}',
    ]);
  }

  void _logPreparedStructure({
    required String stage,
    required MaterialType type,
    required List<Chapter> chapters,
    required String? selectedFolderPath,
    required int? ignoredFilesCount,
    required int? totalPages,
    required int? totalDuration,
  }) {
    final itemLabel = _debugItemLabel(type);
    _debugLogBlock([
      '[AddMaterial][structure] stage=$stage',
      '[AddMaterial][structure] type=${type.label}',
      '[AddMaterial][structure] selectedFolderPath=${selectedFolderPath ?? '(none)'}',
      '[AddMaterial][structure] ignoredFilesCount=${ignoredFilesCount ?? 0}',
      '[AddMaterial][structure] ${itemLabel}Count=${chapters.length}',
      if (totalPages != null) '[AddMaterial][structure] totalPages=$totalPages',
      if (totalDuration != null)
        '[AddMaterial][structure] totalDurationSeconds=$totalDuration',
      if (chapters.isEmpty)
        '[AddMaterial][structure] Remark: no $itemLabel entries were generated from the current selection.',
    ]);

    for (var i = 0; i < chapters.length; i++) {
      final chapter = chapters[i];
      final validation = _validateChapterForDebug(chapter: chapter, type: type);
      _debugLog(
        '[AddMaterial][structure][${validation.isValid ? 'VALID' : 'WARN'}] '
        '$itemLabel[$i] title="${chapter.title}" orderIndex=${chapter.orderIndex} '
        'parentId=${chapter.parentId ?? '(root)'} pageStart=${chapter.pageStart ?? '-'} '
        'pageEnd=${chapter.pageEnd ?? '-'} duration=${chapter.duration ?? '-'} '
        'filePath=${chapter.filePath ?? '-'} remark=${validation.remark}',
      );
    }
  }

  ({bool isValid, String remark}) _validateChapterForDebug({
    required Chapter chapter,
    required MaterialType type,
  }) {
    final issues = <String>[];

    if (chapter.title.trim().isEmpty) {
      issues.add('title is empty');
    }
    if (chapter.orderIndex < 0) {
      issues.add('order index is negative');
    }
    if (type != MaterialType.book &&
        type != MaterialType.course &&
        (chapter.filePath == null || chapter.filePath!.trim().isEmpty)) {
      issues.add('media file path is missing');
    }
    if (type == MaterialType.book &&
        chapter.pageStart != null &&
        chapter.pageEnd != null &&
        chapter.pageEnd! < chapter.pageStart!) {
      issues.add('pageEnd is before pageStart');
    }

    if (issues.isNotEmpty) {
      return (isValid: false, remark: issues.join('; '));
    }

    final remark = switch (type) {
      MaterialType.book when chapter.pageStart != null =>
        'valid chapter: title and order index are set, and page metadata is available',
      MaterialType.book =>
        'valid chapter: title and order index are set; page metadata is optional',
      MaterialType.course when chapter.duration != null =>
        'valid course item: title, order index, and duration are available; lesson links are optional',
      MaterialType.course =>
        'valid course item: title and order index are set; lesson links and durations are optional',
      _ when chapter.duration != null =>
        'valid media item: title, order index, file path, and duration are available',
      _ =>
        'valid media item: title, order index, and file path are available; duration can remain empty until probing succeeds',
    };

    return (isValid: true, remark: remark);
  }

  void _logSavePayload({
    required StudyMaterial material,
    required List<Chapter> chapters,
    required String? selectedFolderPath,
    required List<String> copiedPaths,
  }) {
    _debugLogBlock([
      '[AddMaterial][save] Preparing to save material.',
      '[AddMaterial][save] id=${material.id}',
      '[AddMaterial][save] type=${material.type.label}',
      '[AddMaterial][save] title="${material.title}"',
      '[AddMaterial][save] author=${material.author ?? '(none)'}',
      '[AddMaterial][save] selectedFolderPath=${selectedFolderPath ?? '(none)'}',
      '[AddMaterial][save] filePath=${material.filePath ?? '(none)'}',
      '[AddMaterial][save] totalPages=${material.totalPages ?? '-'}',
      '[AddMaterial][save] totalDurationSeconds=${material.totalDuration ?? '-'}',
      '[AddMaterial][save] chaptersCount=${chapters.length}',
      '[AddMaterial][save] copiedFilesCount=${copiedPaths.length}',
      for (var i = 0; i < copiedPaths.length; i++)
        '[AddMaterial][save] copied[$i]=${copiedPaths[i]}',
    ]);

    for (var i = 0; i < chapters.length; i++) {
      final validation = _validateChapterForDebug(
        chapter: chapters[i],
        type: material.type,
      );
      _debugLog(
        '[AddMaterial][save][${validation.isValid ? 'VALID' : 'WARN'}] '
        '${_debugItemLabel(material.type)}[$i] id=${chapters[i].id} '
        'title="${chapters[i].title}" filePath=${chapters[i].filePath ?? '-'} '
        'remark=${validation.remark}',
      );
    }
  }

  String _debugItemLabel(MaterialType type) {
    return switch (type) {
      MaterialType.book => 'chapter',
      MaterialType.video => 'episode',
      MaterialType.audio => 'track',
      MaterialType.course => 'item',
    };
  }
}

class _PickedMediaFolder {
  const _PickedMediaFolder({
    required this.rootPath,
    required this.folderName,
    required this.files,
    required this.ignoredFilesCount,
  });

  final String rootPath;
  final String folderName;
  final List<String> files;
  final int ignoredFilesCount;
}

class _SaveFailure {
  const _SaveFailure({required this.message, required this.isStorageFull});

  final String message;
  final bool isStorageFull;
}
