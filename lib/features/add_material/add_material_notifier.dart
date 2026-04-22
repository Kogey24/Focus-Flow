import 'dart:io';

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

import '../../core/extensions/string_extensions.dart';
import '../../core/utils/pdf_toc_parser.dart';
import '../../data/repositories/material_repository.dart';
import '../../domain/enums/material_type.dart';
import '../../domain/models/chapter.dart';
import '../../domain/models/material.dart';
import 'add_material_state.dart';

part 'add_material_notifier.g.dart';

@riverpod
class AddMaterialNotifier extends _$AddMaterialNotifier {
  static const MethodChannel _mediaFolderChannel = MethodChannel('focus_flow/media_folder');
  static const int _videoCompressionThresholdBytes = 25 * 1024 * 1024;
  static const int _audioCompressionThresholdBytes = 5 * 1024 * 1024;
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
      folderIgnoredFilesCount: null,
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
        folderIgnoredFilesCount: null,
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

    final extensions = _allowedExtensionsFor(current.type);

    if (current.type == MaterialType.course) return;

    final result = await FilePicker.pickFiles(
      allowMultiple: current.type != MaterialType.book,
      type: FileType.custom,
      allowedExtensions: extensions,
    );
    if (result == null || result.files.isEmpty) return;

    final paths = result.files.map((file) => file.path).whereType<String>().toList();
    _debugLogBlock([
      '[AddMaterial][files] Selected ${paths.length} ${current.type.label.toLowerCase()} file(s).',
      for (var i = 0; i < paths.length; i++) '[AddMaterial][files] file[$i]=${paths[i]}',
    ]);
    await _loadSelectedFiles(
      paths,
      selectedFolderPath: null,
      folderIgnoredFilesCount: null,
    );
  }

  Future<void> pickFolder() async {
    final current = state.valueOrNull;
    if (current == null || current.type == MaterialType.book || current.type == MaterialType.course) {
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
          suggestedTitle: current.title.trim().isEmpty ? selection.folderName.filenameLabel() : null,
        );
        return;
      }
    }

    await _pickFolderFromFileSystem(current);
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
      type: current.type,
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

    _debugLog('[AddMaterial][save] Material saved successfully with id=$materialId.');

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
      ),
    );
    return materialId;
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

    _debugLogBlock([
      '[AddMaterial][load] Received ${sortedPaths.length} path(s) for ${current.type.label.toLowerCase()}.',
      '[AddMaterial][load] selectedFolderPath=${selectedFolderPath ?? '(none)'}',
      '[AddMaterial][load] ignoredFilesCount=${folderIgnoredFilesCount ?? 0}',
      for (var i = 0; i < sortedPaths.length; i++) '[AddMaterial][load] input[$i]=${sortedPaths[i]}',
    ]);

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
      chapters = sortedPaths.asMap().entries.map((entry) {
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
      }).toList(growable: false);

      state = AsyncData(
        current.copyWith(
          title: suggestedTitle ?? current.title,
          selectedPaths: sortedPaths,
          selectedFolderPath: selectedFolderPath,
          folderIgnoredFilesCount: folderIgnoredFilesCount,
          chapters: chapters,
          totalPages: null,
          totalDuration: null,
        ),
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
      current.copyWith(
        title: suggestedTitle ?? current.title,
        selectedPaths: sortedPaths,
        selectedFolderPath: selectedFolderPath,
        folderIgnoredFilesCount: folderIgnoredFilesCount,
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
    required MaterialType type,
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
      copied.add(
        await _copyOrOptimizeMediaFile(
          sourcePath: sourcePath,
          destinationRoot: materialDir.path,
          relativePath: relativePath,
          type: type,
        ),
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

  Future<_PickedMediaFolder?> _pickAndroidMediaFolder(MaterialType type) async {
    final allowedExtensions = _allowedExtensionsFor(type);

    if (allowedExtensions.isEmpty) return null;

    try {
      final result = await _mediaFolderChannel.invokeMapMethod<String, Object?>(
        'pickMediaFolder',
        {
          'allowedExtensions': allowedExtensions,
          'mediaType': switch (type) {
            MaterialType.video => 'video',
            MaterialType.audio => 'audio',
            _ => '',
          },
        },
      );
      if (result == null) return null;

      final rootPath = result['rootPath'] as String?;
      final folderName = result['folderName'] as String?;
      final files = (result['files'] as List<Object?>?)?.whereType<String>().toList(growable: false) ?? const [];
      final ignoredFilesCount = (result['ignoredFilesCount'] as num?)?.toInt() ?? 0;
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
      debugPrint('Media folder channel unavailable, falling back to filesystem scan: $error');
      return null;
    } on PlatformException catch (error) {
      debugPrint('Media folder channel failed, falling back to filesystem scan: ${error.message}');
      return null;
    }
  }

  Future<void> _pickFolderFromFileSystem(AddMaterialState current) async {
    final folderPath = await FilePicker.getDirectoryPath();
    if (folderPath == null) return;

    final allowedExtensions = _allowedExtensionsFor(current.type).toSet();
    final files = <File>[];
    var ignoredFilesCount = 0;
    await for (final entity in Directory(folderPath).list(recursive: true, followLinks: false)) {
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
      MaterialType.video => ['mp4', 'mkv', 'mov', 'avi', 'webm', 'm4v', '3gp', 'mpeg', 'mpg', 'ts'],
      MaterialType.audio => ['mp3', 'aac', 'wav', 'm4a', 'flac', 'ogg', 'opus', 'wma'],
      MaterialType.course => const <String>[],
    };
  }

  Future<bool> _matchesMaterialType({
    required String filePath,
    required MaterialType type,
    required Set<String> allowedExtensions,
  }) async {
    final extension = path.extension(filePath).replaceFirst('.', '').toLowerCase();
    if (allowedExtensions.contains(extension)) {
      return true;
    }

    try {
      final session = await FFprobeKit.getMediaInformation(filePath);
      final info = session.getMediaInformation();
      final streamTypes = info
              ?.getStreams()
              .map((stream) => stream.getType()?.toLowerCase())
              .whereType<String>()
              .toSet() ??
          const <String>{};
      return switch (type) {
        MaterialType.video => streamTypes.contains('video'),
        MaterialType.audio => streamTypes.contains('audio') && !streamTypes.contains('video'),
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
  }) async {
    final sourceFile = File(sourcePath);
    final originalDestination = path.join(destinationRoot, relativePath);
    await Directory(path.dirname(originalDestination)).create(recursive: true);

    if (!_shouldCompressFile(sourceFile: sourceFile, type: type)) {
      await sourceFile.copy(originalDestination);
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
    );

    if (compressed != null) {
      return compressed;
    }

    if (await File(optimizedDestination).exists()) {
      await File(optimizedDestination).delete();
    }
    await sourceFile.copy(originalDestination);
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
    final originalExtension = path.extension(relativePath).replaceFirst('.', '').toLowerCase();
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
  }) async {
    final sourceFile = File(sourcePath);
    final compressionArgs = await _compressionArguments(
      sourcePath: sourcePath,
      destinationPath: destinationPath,
      type: type,
    );
    if (compressionArgs == null) return null;

    try {
      final session = await FFmpegKit.executeWithArguments(compressionArgs);
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

  Future<({int width, int height})?> _probeVideoDimensions(String filePath) async {
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
      for (var i = 0; i < files.length; i++) '[AddMaterial][folder][$source] file[$i]=${files[i]}',
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
      if (totalDuration != null) '[AddMaterial][structure] totalDurationSeconds=$totalDuration',
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
    if (type != MaterialType.book && (chapter.filePath == null || chapter.filePath!.trim().isEmpty)) {
      issues.add('media file path is missing');
    }
    if (type == MaterialType.book &&
        chapter.pageStart != null &&
        chapter.pageEnd != null &&
        chapter.pageEnd! < chapter.pageStart!) {
      issues.add('pageEnd is before pageStart');
    }

    if (issues.isNotEmpty) {
      return (
        isValid: false,
        remark: issues.join('; '),
      );
    }

    final remark = switch (type) {
      MaterialType.book when chapter.pageStart != null =>
        'valid chapter: title and order index are set, and page metadata is available',
      MaterialType.book =>
        'valid chapter: title and order index are set; page metadata is optional',
      _ when chapter.duration != null =>
        'valid media item: title, order index, file path, and duration are available',
      _ =>
        'valid media item: title, order index, and file path are available; duration can remain empty until probing succeeds',
    };

    return (
      isValid: true,
      remark: remark,
    );
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
      for (var i = 0; i < copiedPaths.length; i++) '[AddMaterial][save] copied[$i]=${copiedPaths[i]}',
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
