import 'dart:io';

import 'package:mime/mime.dart';

import '../../domain/enums/material_type.dart';

abstract final class FileTypeDetector {
  static MaterialType? detectMaterialType(String path) {
    final extension = path.split('.').last.toLowerCase();
    final mime = lookupMimeType(path) ?? '';

    if (<String>{'pdf', 'doc', 'docx'}.contains(extension) || mime.contains('pdf')) {
      return MaterialType.book;
    }
    if (<String>{'mp4', 'mkv', 'mov', 'avi', 'webm'}.contains(extension) ||
        mime.startsWith('video/')) {
      return MaterialType.video;
    }
    if (<String>{'mp3', 'aac', 'wav', 'm4a', 'flac'}.contains(extension) ||
        mime.startsWith('audio/')) {
      return MaterialType.audio;
    }
    return null;
  }

  static bool isSupportedMediaFile(FileSystemEntity entity) {
    if (entity is! File) return false;
    return detectMaterialType(entity.path) != null;
  }
}
