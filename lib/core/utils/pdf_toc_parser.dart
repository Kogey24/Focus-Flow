import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pdfx/pdfx.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/chapter.dart';
import '../extensions/string_extensions.dart';

enum TocParseConfidence { high, low }

class TocParseResult {
  const TocParseResult({
    required this.chapters,
    required this.confidence,
    required this.totalPages,
  });

  final List<Chapter> chapters;
  final TocParseConfidence confidence;
  final int totalPages;
}

class PdfTocParser {
  PdfTocParser({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  static const MethodChannel _outlineChannel = MethodChannel('focus_flow/pdf_outline');

  final Uuid _uuid;

  Future<TocParseResult> parse({
    required String materialId,
    required String filePath,
  }) async {
    final document = await PdfDocument.openFile(filePath);
    try {
      final totalPages = document.pagesCount;
      final tableOfContentsChapters = await _buildTableOfContentsChapters(
        materialId: materialId,
        filePath: filePath,
        totalPages: totalPages,
      );

      if (tableOfContentsChapters.isNotEmpty) {
        return TocParseResult(
          chapters: tableOfContentsChapters,
          confidence: TocParseConfidence.high,
          totalPages: totalPages,
        );
      }

      final inferred = _buildFallbackChapters(
        materialId: materialId,
        filePath: filePath,
        totalPages: totalPages,
      );
      return TocParseResult(
        chapters: inferred,
        confidence: TocParseConfidence.low,
        totalPages: totalPages,
      );
    } finally {
      await document.close();
    }
  }

  Future<List<Chapter>> _buildTableOfContentsChapters({
    required String materialId,
    required String filePath,
    required int totalPages,
  }) async {
    if (!Platform.isAndroid) return const <Chapter>[];

    try {
      final rawEntries = await _outlineChannel.invokeListMethod<dynamic>(
        'extractTableOfContents',
        {'filePath': filePath},
      );
      if (rawEntries == null || rawEntries.isEmpty) return const <Chapter>[];

      final entries = rawEntries
          .map((entry) => _TocEntry.fromMap(Map<Object?, Object?>.from(entry as Map)))
          .where((entry) => entry.title.trim().isNotEmpty && entry.pageStart != null)
          .toList(growable: false);

      if (entries.isEmpty) return const <Chapter>[];

      final nodes = <_MutableTocNode>[];
      final stack = <_MutableTocNode>[];

      for (final entry in entries) {
        final level = entry.level < 0 ? 0 : entry.level;
        while (stack.length > level) {
          stack.removeLast();
        }

        final pageStart = _clampPage(entry.pageStart!, totalPages);
        final node = _MutableTocNode(
          id: _uuid.v4(),
          title: entry.title.trim(),
          parentId: stack.isEmpty ? null : stack.last.id,
          orderIndex: nodes.length,
          level: level,
          pageStart: pageStart,
        );

        nodes.add(node);
        stack.add(node);
      }

      for (var index = 0; index < nodes.length; index++) {
        final current = nodes[index];
        _MutableTocNode? nextBoundary;

        for (var cursor = index + 1; cursor < nodes.length; cursor++) {
          final candidate = nodes[cursor];
          if (candidate.level <= current.level) {
            nextBoundary = candidate;
            break;
          }
        }

        final nextPageStart = nextBoundary?.pageStart ?? totalPages + 1;
        current.pageEnd = nextPageStart - 1 < current.pageStart ? current.pageStart : nextPageStart - 1;
      }

      return nodes
          .map(
            (node) => Chapter(
              id: node.id,
              materialId: materialId,
              title: node.title,
              parentId: node.parentId,
              orderIndex: node.orderIndex,
              pageStart: node.pageStart,
              pageEnd: node.pageEnd,
            ),
          )
          .toList(growable: false);
    } on MissingPluginException {
      return const <Chapter>[];
    } on PlatformException {
      return const <Chapter>[];
    } catch (_) {
      return const <Chapter>[];
    }
  }

  int _clampPage(int page, int totalPages) {
    if (page < 1) return 1;
    if (page > totalPages) return totalPages;
    return page;
  }

  List<Chapter> _buildFallbackChapters({
    required String materialId,
    required String filePath,
    required int totalPages,
  }) {
    final file = File(filePath);
    final baseTitle = file.uri.pathSegments.isEmpty
        ? 'Document'
        : file.uri.pathSegments.last.filenameLabel();

    if (totalPages <= 12) {
      return [
        Chapter(
          id: _uuid.v4(),
          materialId: materialId,
          title: baseTitle,
          orderIndex: 0,
          pageStart: 1,
          pageEnd: totalPages,
        ),
      ];
    }

    final chunk = (totalPages / 4).ceil();
    final chapters = <Chapter>[];
    for (var index = 0; index < 4; index++) {
      final pageStart = index * chunk + 1;
      if (pageStart > totalPages) break;
      final pageEnd = (pageStart + chunk - 1).clamp(1, totalPages);
      chapters.add(
        Chapter(
          id: _uuid.v4(),
          materialId: materialId,
          title: 'Part ${index + 1}',
          orderIndex: index,
          pageStart: pageStart,
          pageEnd: pageEnd,
        ),
      );
    }
    return chapters;
  }
}

class _TocEntry {
  const _TocEntry({
    required this.title,
    required this.level,
    required this.pageStart,
  });

  factory _TocEntry.fromMap(Map<Object?, Object?> map) {
    final rawPage = map['pageStart'];
    final pageStart = rawPage is int ? rawPage : int.tryParse('$rawPage');

    return _TocEntry(
      title: '${map['title'] ?? ''}',
      level: map['level'] is int ? map['level'] as int : int.tryParse('${map['level']}') ?? 0,
      pageStart: pageStart,
    );
  }

  final String title;
  final int level;
  final int? pageStart;
}

class _MutableTocNode {
  _MutableTocNode({
    required this.id,
    required this.title,
    required this.parentId,
    required this.orderIndex,
    required this.level,
    required this.pageStart,
  });

  final String id;
  final String title;
  final String? parentId;
  final int orderIndex;
  final int level;
  final int pageStart;
  int? pageEnd;
}
