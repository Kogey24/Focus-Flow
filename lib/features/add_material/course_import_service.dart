import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/string_extensions.dart';

final courseImportServiceProvider = Provider<CourseImportService>(
  (ref) => CourseImportService(
    fetcher: HttpCourseImportFetcher(),
    importers: const [
      YouTubePlaylistCourseImporter(),
      StructuredCourseImporter(),
    ],
  ),
);

class CourseImportService {
  const CourseImportService({required this.fetcher, required this.importers});

  final CourseImportFetcher fetcher;
  final List<CourseOutlineImporter> importers;

  Future<CourseImportPreview> importFromUrl(String rawUrl) async {
    final uri = _normalizeCourseUri(rawUrl);
    final document = await fetcher.fetch(uri);
    final fallback = _fallbackPreview(document);

    CourseImportPreview? bestPreview;
    final prioritizedImporters = [
      ...importers.where(
        (importer) => importer.canHandle(document.resolvedUri),
      ),
      ...importers.where(
        (importer) => !importer.canHandle(document.resolvedUri),
      ),
    ];

    for (final importer in prioritizedImporters) {
      final preview = importer.parse(document);
      if (preview == null) continue;
      bestPreview = _pickBetterPreview(bestPreview, preview);
    }

    final merged = _mergePreview(
      primary: bestPreview ?? fallback,
      fallback: fallback,
    );

    final warnings = [
      ...merged.warnings,
      if (merged.items.isEmpty)
        'Course pages can hide outlines behind login, scripts, or anti-scraping rules. '
            'You can still save this course and add topics manually.',
    ];

    return merged.copyWith(warnings: _dedupeStrings(warnings));
  }

  Uri _normalizeCourseUri(String rawUrl) {
    final trimmed = rawUrl.trim();
    if (trimmed.isEmpty) {
      throw const CourseImportException('Paste a course URL first.');
    }

    final withScheme = trimmed.contains('://') ? trimmed : 'https://$trimmed';
    final uri = Uri.tryParse(withScheme);
    if (uri == null || !uri.hasAuthority) {
      throw const CourseImportException(
        'That does not look like a valid course URL.',
      );
    }
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      throw const CourseImportException(
        'Only http and https course URLs are supported right now.',
      );
    }
    return uri;
  }

  CourseImportPreview _fallbackPreview(CourseImportDocument document) {
    final title =
        _extractPageTitle(document.body) ?? _hostLabel(document.resolvedUri);
    final provider =
        _extractPageProvider(document.body) ?? _hostLabel(document.resolvedUri);
    final thumbnailUrl = _extractThumbnailUrl(
      document.body,
      baseUri: document.resolvedUri,
    );

    return CourseImportPreview(
      sourceUrl: document.resolvedUri.toString(),
      title: title,
      provider: provider,
      thumbnailUrl: thumbnailUrl,
      importerLabel: 'Page metadata',
    );
  }
}

class CourseImportPreview {
  const CourseImportPreview({
    required this.sourceUrl,
    required this.title,
    this.provider,
    this.thumbnailUrl,
    this.items = const [],
    this.warnings = const [],
    this.importerLabel,
  });

  final String sourceUrl;
  final String title;
  final String? provider;
  final String? thumbnailUrl;
  final List<CourseImportItem> items;
  final List<String> warnings;
  final String? importerLabel;

  int? get totalDuration {
    var hasAnyDuration = false;
    var total = 0;
    for (final item in items) {
      if (item.durationSeconds == null) continue;
      hasAnyDuration = true;
      total += item.durationSeconds!;
    }
    return hasAnyDuration ? total : null;
  }

  CourseImportPreview copyWith({
    String? sourceUrl,
    String? title,
    Object? provider = _sentinel,
    Object? thumbnailUrl = _sentinel,
    List<CourseImportItem>? items,
    List<String>? warnings,
    Object? importerLabel = _sentinel,
  }) {
    return CourseImportPreview(
      sourceUrl: sourceUrl ?? this.sourceUrl,
      title: title ?? this.title,
      provider: provider == _sentinel ? this.provider : provider as String?,
      thumbnailUrl: thumbnailUrl == _sentinel
          ? this.thumbnailUrl
          : thumbnailUrl as String?,
      items: items ?? this.items,
      warnings: warnings ?? this.warnings,
      importerLabel: importerLabel == _sentinel
          ? this.importerLabel
          : importerLabel as String?,
    );
  }
}

class CourseImportItem {
  const CourseImportItem({
    required this.title,
    this.durationSeconds,
    this.sourceUrl,
    this.sectionTitle,
  });

  final String title;
  final int? durationSeconds;
  final String? sourceUrl;
  final String? sectionTitle;

  String get displayTitle {
    final section = sectionTitle?.trim();
    if (section == null || section.isEmpty) return title;
    return '$section / $title';
  }
}

class CourseImportDocument {
  const CourseImportDocument({
    required this.requestedUri,
    required this.resolvedUri,
    required this.statusCode,
    required this.headers,
    required this.body,
  });

  final Uri requestedUri;
  final Uri resolvedUri;
  final int statusCode;
  final Map<String, List<String>> headers;
  final String body;
}

abstract class CourseImportFetcher {
  Future<CourseImportDocument> fetch(Uri uri);
}

class HttpCourseImportFetcher implements CourseImportFetcher {
  HttpCourseImportFetcher({
    HttpClient? client,
    this.timeout = const Duration(seconds: 15),
  }) : _client = client ?? HttpClient();

  final HttpClient _client;
  final Duration timeout;

  @override
  Future<CourseImportDocument> fetch(Uri uri) async {
    try {
      final request = await _client.getUrl(uri).timeout(timeout);
      request.followRedirects = true;
      request.maxRedirects = 5;
      request.headers.set(
        HttpHeaders.userAgentHeader,
        'FocusFlow/1.0 (course outline importer)',
      );
      request.headers.set(
        HttpHeaders.acceptHeader,
        'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
      );

      final response = await request.close().timeout(timeout);
      final bytes = await response
          .fold<BytesBuilder>(BytesBuilder(copy: false), (builder, data) {
            builder.add(data);
            return builder;
          })
          .timeout(timeout);

      if (response.statusCode >= 400) {
        throw CourseImportException(
          'Could not open the course URL (HTTP ${response.statusCode}).',
        );
      }

      var resolvedUri = uri;
      for (final redirect in response.redirects) {
        resolvedUri = resolvedUri.resolveUri(redirect.location);
      }

      final headers = <String, List<String>>{};
      response.headers.forEach((name, values) {
        headers[name] = values;
      });

      final charset = response.headers.contentType?.charset;
      final encoding = charset == null
          ? utf8
          : Encoding.getByName(charset) ?? utf8;
      final rawBytes = bytes.takeBytes();
      late final String body;
      try {
        body = encoding.decode(rawBytes);
      } catch (_) {
        body = utf8.decode(rawBytes, allowMalformed: true);
      }

      return CourseImportDocument(
        requestedUri: uri,
        resolvedUri: resolvedUri,
        statusCode: response.statusCode,
        headers: headers,
        body: body,
      );
    } on SocketException {
      throw const CourseImportException(
        'Could not reach that course URL. Check the internet connection and try again.',
      );
    } on HandshakeException {
      throw const CourseImportException(
        'The course site rejected a secure connection. Try again later or use a different source.',
      );
    } on HttpException catch (error) {
      throw CourseImportException(error.message);
    } on CourseImportException {
      rethrow;
    } catch (_) {
      throw const CourseImportException(
        'The course page could not be loaded right now.',
      );
    }
  }
}

abstract class CourseOutlineImporter {
  const CourseOutlineImporter();

  String get label;

  bool canHandle(Uri uri);

  CourseImportPreview? parse(CourseImportDocument document);
}

class YouTubePlaylistCourseImporter extends CourseOutlineImporter {
  const YouTubePlaylistCourseImporter();

  @override
  String get label => 'YouTube playlist';

  @override
  bool canHandle(Uri uri) {
    final host = uri.host.toLowerCase();
    return (host.contains('youtube.com') || host.contains('youtu.be')) &&
        (uri.queryParameters.containsKey('list') ||
            uri.path.contains('playlist'));
  }

  @override
  CourseImportPreview? parse(CourseImportDocument document) {
    final rawJson = _extractBalancedJsonAfterTokens(
      document.body,
      tokens: const [
        'var ytInitialData =',
        'window["ytInitialData"] =',
        'ytInitialData =',
      ],
    );
    if (rawJson == null) return null;

    final decoded = _safeJsonDecode(rawJson);
    if (decoded == null) return null;

    final playlistId = document.resolvedUri.queryParameters['list'];
    final renderers = _collectRendererMaps(decoded, 'playlistVideoRenderer');
    final items = <CourseImportItem>[];
    final seenVideoIds = <String>{};

    for (final renderer in renderers) {
      final videoId = _bestString(renderer, const ['videoId']);
      if (videoId != null && !seenVideoIds.add(videoId)) {
        continue;
      }

      final title = _bestString(renderer, const ['title', 'headline', 'name']);
      if (title == null || title.trim().isEmpty) continue;

      final durationSeconds = _firstDuration(renderer, const [
        'lengthSeconds',
        'lengthText',
        'duration',
      ]);

      final sourceUrl = videoId == null
          ? null
          : Uri.https('www.youtube.com', '/watch', {
              'v': videoId,
              if (playlistId != null) 'list': playlistId,
            }).toString();

      items.add(
        CourseImportItem(
          title: title,
          durationSeconds: durationSeconds,
          sourceUrl: sourceUrl,
        ),
      );
    }

    if (items.isEmpty) return null;

    return CourseImportPreview(
      sourceUrl: document.resolvedUri.toString(),
      title: _extractPageTitle(document.body) ?? 'YouTube playlist',
      provider: 'YouTube',
      thumbnailUrl: _extractThumbnailUrl(
        document.body,
        baseUri: document.resolvedUri,
      ),
      items: items,
      importerLabel: label,
    );
  }
}

class StructuredCourseImporter extends CourseOutlineImporter {
  const StructuredCourseImporter();

  @override
  String get label => 'Structured page data';

  @override
  bool canHandle(Uri uri) => uri.hasAuthority;

  @override
  CourseImportPreview? parse(CourseImportDocument document) {
    final candidates = <dynamic>[];

    for (final script in _extractJsonLdScripts(document.body)) {
      final decoded = _safeJsonDecode(script);
      if (decoded != null) {
        candidates.add(decoded);
      }
    }

    for (final script in _extractJsonScriptsById(document.body, const [
      '__NEXT_DATA__',
      '__NUXT_DATA__',
    ])) {
      final decoded = _safeJsonDecode(script);
      if (decoded != null) {
        candidates.add(decoded);
      }
    }

    for (final rawJson in [
      _extractBalancedJsonAfterTokens(
        document.body,
        tokens: const [
          'window.__INITIAL_STATE__ =',
          'window.__PRELOADED_STATE__ =',
          'window.__NUXT__ =',
          '__NEXT_DATA__ =',
        ],
      ),
    ]) {
      if (rawJson == null) continue;
      final decoded = _safeJsonDecode(rawJson);
      if (decoded != null) {
        candidates.add(decoded);
      }
    }

    if (candidates.isEmpty) {
      return null;
    }

    final items = <CourseImportItem>[];
    final seen = <String>{};
    String? title;
    String? provider;
    String? thumbnailUrl;

    for (final candidate in candidates) {
      title ??= _extractTitleFromStructuredData(candidate);
      provider ??= _extractProviderFromStructuredData(candidate);
      thumbnailUrl ??= _extractThumbnailFromStructuredData(
        candidate,
        baseUri: document.resolvedUri,
      );

      for (final item in _extractOutlineItems(candidate)) {
        final fingerprint =
            '${item.sectionTitle ?? ''}|${item.title}|${item.durationSeconds ?? ''}|${item.sourceUrl ?? ''}';
        if (seen.add(fingerprint)) {
          items.add(item);
        }
      }
    }

    if (items.isEmpty &&
        title == null &&
        provider == null &&
        thumbnailUrl == null) {
      return null;
    }

    return CourseImportPreview(
      sourceUrl: document.resolvedUri.toString(),
      title:
          title ??
          _extractPageTitle(document.body) ??
          _hostLabel(document.resolvedUri),
      provider: provider ?? _extractPageProvider(document.body),
      thumbnailUrl:
          thumbnailUrl ??
          _extractThumbnailUrl(document.body, baseUri: document.resolvedUri),
      items: items,
      importerLabel: label,
    );
  }
}

class CourseImportException implements Exception {
  const CourseImportException(this.message);

  final String message;

  @override
  String toString() => message;
}

const _sentinel = Object();

CourseImportPreview _pickBetterPreview(
  CourseImportPreview? current,
  CourseImportPreview candidate,
) {
  if (current == null) return candidate;

  if (candidate.items.length != current.items.length) {
    return candidate.items.length > current.items.length ? candidate : current;
  }

  final currentDurationScore = current.totalDuration ?? -1;
  final candidateDurationScore = candidate.totalDuration ?? -1;
  if (candidateDurationScore != currentDurationScore) {
    return candidateDurationScore > currentDurationScore ? candidate : current;
  }

  final currentMetadataScore = _metadataScore(current);
  final candidateMetadataScore = _metadataScore(candidate);
  if (candidateMetadataScore != currentMetadataScore) {
    return candidateMetadataScore > currentMetadataScore ? candidate : current;
  }

  return current;
}

CourseImportPreview _mergePreview({
  required CourseImportPreview primary,
  required CourseImportPreview fallback,
}) {
  return primary.copyWith(
    sourceUrl: primary.sourceUrl.isNotEmpty
        ? primary.sourceUrl
        : fallback.sourceUrl,
    title: primary.title.trim().isNotEmpty ? primary.title : fallback.title,
    provider: (primary.provider ?? '').trim().isNotEmpty
        ? primary.provider
        : fallback.provider,
    thumbnailUrl: (primary.thumbnailUrl ?? '').trim().isNotEmpty
        ? primary.thumbnailUrl
        : fallback.thumbnailUrl,
    warnings: _dedupeStrings([...fallback.warnings, ...primary.warnings]),
  );
}

int _metadataScore(CourseImportPreview preview) {
  var score = 0;
  if (preview.title.trim().isNotEmpty) score++;
  if ((preview.provider ?? '').trim().isNotEmpty) score++;
  if ((preview.thumbnailUrl ?? '').trim().isNotEmpty) score++;
  return score;
}

List<String> _dedupeStrings(List<String> values) {
  final seen = <String>{};
  final result = <String>[];
  for (final value in values) {
    final trimmed = value.trim();
    if (trimmed.isEmpty || !seen.add(trimmed)) continue;
    result.add(trimmed);
  }
  return result;
}

String _hostLabel(Uri uri) {
  final host = uri.host.replaceFirst(RegExp(r'^www\.'), '');
  final parts = host.split('.');
  if (parts.isEmpty || parts.first.trim().isEmpty) {
    return 'Online course';
  }
  return parts.first.replaceAll(RegExp(r'[_\-]+'), ' ').toTitleCase();
}

String? _extractPageTitle(String html) {
  return _extractMetaContent(html, const ['og:title', 'twitter:title']) ??
      _matchGroup(
        html,
        RegExp(r'<title[^>]*>([\s\S]*?)</title>', caseSensitive: false),
      );
}

String? _extractPageProvider(String html) {
  return _extractMetaContent(html, const [
        'og:site_name',
        'application-name',
        'author',
      ]) ??
      _extractMetaContent(html, const ['twitter:site']);
}

String? _extractThumbnailUrl(String html, {required Uri baseUri}) {
  final raw = _extractMetaContent(html, const ['og:image', 'twitter:image']);
  return raw == null ? null : _resolveUrl(raw, baseUri);
}

String? _extractMetaContent(String html, List<String> names) {
  for (final name in names) {
    final patterns = [
      RegExp(
        '<meta[^>]+(?:property|name)=["\']${RegExp.escape(name)}["\'][^>]+content=["\']([^"\']+)["\'][^>]*>',
        caseSensitive: false,
      ),
      RegExp(
        '<meta[^>]+content=["\']([^"\']+)["\'][^>]+(?:property|name)=["\']${RegExp.escape(name)}["\'][^>]*>',
        caseSensitive: false,
      ),
    ];
    for (final pattern in patterns) {
      final match = pattern.firstMatch(html);
      if (match == null) continue;
      final value = _cleanText(match.group(1));
      if (value != null) return value;
    }
  }
  return null;
}

String? _matchGroup(String value, RegExp pattern, [int group = 1]) {
  final match = pattern.firstMatch(value);
  if (match == null) return null;
  return _cleanText(match.group(group));
}

String? _cleanText(String? raw) {
  if (raw == null) return null;
  final stripped = raw
      .replaceAll(RegExp(r'<[^>]+>'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  if (stripped.isEmpty) return null;
  return stripped
      .replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&apos;', "'")
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&nbsp;', ' ');
}

List<String> _extractJsonLdScripts(String html) {
  final matches = RegExp(
    '<script[^>]+type=[\'"]application/ld\\+json[\'"][^>]*>([\\s\\S]*?)</script>',
    caseSensitive: false,
  ).allMatches(html);
  return matches
      .map((match) => match.group(1)?.trim() ?? '')
      .where((value) => value.isNotEmpty)
      .toList(growable: false);
}

List<String> _extractJsonScriptsById(String html, List<String> ids) {
  final results = <String>[];
  for (final id in ids) {
    final pattern = RegExp(
      '<script[^>]+id=["\']${RegExp.escape(id)}["\'][^>]*>([\\s\\S]*?)</script>',
      caseSensitive: false,
    );
    final match = pattern.firstMatch(html);
    final value = match?.group(1)?.trim();
    if (value != null && value.isNotEmpty) {
      results.add(value);
    }
  }
  return results;
}

String? _extractBalancedJsonAfterTokens(
  String html, {
  required List<String> tokens,
}) {
  for (final token in tokens) {
    final startIndex = html.indexOf(token);
    if (startIndex < 0) continue;
    final braceIndex = html.indexOf('{', startIndex + token.length);
    final bracketIndex = html.indexOf('[', startIndex + token.length);

    var openIndex = -1;
    if (braceIndex >= 0 && bracketIndex >= 0) {
      openIndex = braceIndex < bracketIndex ? braceIndex : bracketIndex;
    } else {
      openIndex = braceIndex >= 0 ? braceIndex : bracketIndex;
    }
    if (openIndex < 0) continue;

    final extracted = _extractBalancedJson(html, openIndex);
    if (extracted != null) return extracted;
  }
  return null;
}

String? _extractBalancedJson(String source, int openIndex) {
  if (openIndex < 0 || openIndex >= source.length) return null;

  final opening = source[openIndex];
  final closing = opening == '{' ? '}' : ']';
  var depth = 0;
  var inString = false;
  var quote = '';
  var isEscaped = false;

  for (var i = openIndex; i < source.length; i++) {
    final char = source[i];

    if (inString) {
      if (isEscaped) {
        isEscaped = false;
        continue;
      }
      if (char == r'\') {
        isEscaped = true;
        continue;
      }
      if (char == quote) {
        inString = false;
      }
      continue;
    }

    if (char == '"' || char == "'") {
      inString = true;
      quote = char;
      continue;
    }

    if (char == opening) {
      depth++;
    } else if (char == closing) {
      depth--;
      if (depth == 0) {
        return source.substring(openIndex, i + 1);
      }
    }
  }

  return null;
}

dynamic _safeJsonDecode(String raw) {
  try {
    return jsonDecode(raw);
  } catch (_) {
    return null;
  }
}

List<Map<String, dynamic>> _collectRendererMaps(dynamic node, String key) {
  final results = <Map<String, dynamic>>[];

  void visit(dynamic current) {
    if (current is Map) {
      final renderer = current[key];
      if (renderer is Map<String, dynamic>) {
        results.add(renderer);
      } else if (renderer is Map) {
        results.add(Map<String, dynamic>.from(renderer));
      }

      for (final value in current.values) {
        visit(value);
      }
    } else if (current is List) {
      for (final value in current) {
        visit(value);
      }
    }
  }

  visit(node);
  return results;
}

String? _extractTitleFromStructuredData(dynamic node) {
  for (final map in _walkMaps(node)) {
    final title = _bestString(map, const ['headline', 'title', 'name']);
    if (title == null) continue;

    final types = _normalizedTypes(map);
    if (types.contains('course') ||
        types.contains('itemlist') ||
        types.contains('collectionpage') ||
        map.containsKey('itemListElement') ||
        map.containsKey('hasPart')) {
      return title;
    }
  }
  return null;
}

String? _extractProviderFromStructuredData(dynamic node) {
  for (final map in _walkMaps(node)) {
    final provider = _bestString(map, const [
      'provider',
      'publisher',
      'author',
    ]);
    if (provider != null) return provider;
  }
  return null;
}

String? _extractThumbnailFromStructuredData(
  dynamic node, {
  required Uri baseUri,
}) {
  for (final map in _walkMaps(node)) {
    final raw = _bestString(map, const ['image', 'thumbnailUrl', 'thumbnail']);
    if (raw == null) continue;
    return _resolveUrl(raw, baseUri);
  }
  return null;
}

List<CourseImportItem> _extractOutlineItems(dynamic root) {
  final items = <CourseImportItem>[];
  final seen = <String>{};

  void visit(dynamic node, {String? currentSection}) {
    if (node is List) {
      for (final value in node) {
        visit(value, currentSection: currentSection);
      }
      return;
    }

    if (node is! Map) return;

    final map = Map<String, dynamic>.from(node);
    final title = _bestString(map, const [
      'title',
      'name',
      'headline',
      'label',
      'text',
    ]);
    final sectionTitle = _looksLikeSection(map) && title != null
        ? title
        : currentSection;
    final children = _childCollections(map);

    if (_looksLikeOutlineItem(map, title: title)) {
      final item = CourseImportItem(
        title: title!,
        durationSeconds: _firstDuration(map, const [
          'duration',
          'timeRequired',
          'lengthSeconds',
          'length',
          'runtime',
          'videoLength',
        ]),
        sourceUrl: _bestResolvedUrl(map, const [
          'url',
          'contentUrl',
          'canonicalUrl',
          'webUrl',
        ]),
        sectionTitle: currentSection,
      );
      final fingerprint =
          '${item.sectionTitle ?? ''}|${item.title}|${item.durationSeconds ?? ''}|${item.sourceUrl ?? ''}';
      if (seen.add(fingerprint)) {
        items.add(item);
      }
    }

    for (final child in children) {
      visit(child, currentSection: sectionTitle);
    }

    for (final entry in map.entries) {
      if (_knownChildKeys.contains(entry.key)) continue;
      if (entry.value is Map || entry.value is List) {
        visit(entry.value, currentSection: currentSection);
      }
    }
  }

  visit(root);
  return items;
}

Iterable<Map<String, dynamic>> _walkMaps(dynamic node) sync* {
  if (node is Map) {
    final map = Map<String, dynamic>.from(node);
    yield map;
    for (final value in map.values) {
      yield* _walkMaps(value);
    }
  } else if (node is List) {
    for (final value in node) {
      yield* _walkMaps(value);
    }
  }
}

Set<String> _normalizedTypes(Map<String, dynamic> map) {
  final raw = map['@type'];
  if (raw is String) {
    return {raw.toLowerCase()};
  }
  if (raw is List) {
    return raw.whereType<String>().map((value) => value.toLowerCase()).toSet();
  }
  return const <String>{};
}

bool _looksLikeSection(Map<String, dynamic> map) {
  final types = _normalizedTypes(map);
  if (types.contains('course') ||
      types.contains('chapter') ||
      types.contains('section')) {
    return _childCollections(map).isNotEmpty;
  }
  return _childCollections(map).isNotEmpty &&
      _firstDuration(map, const [
            'duration',
            'timeRequired',
            'lengthSeconds',
          ]) ==
          null;
}

bool _looksLikeOutlineItem(Map<String, dynamic> map, {required String? title}) {
  if (title == null || title.trim().isEmpty) return false;

  final normalized = title.trim().toLowerCase();
  if (normalized.length < 2) return false;

  final types = _normalizedTypes(map);
  if (types.intersection(const {
    'videoobject',
    'clip',
    'lesson',
    'lecture',
    'episode',
    'learningresource',
  }).isNotEmpty) {
    return true;
  }

  if (_firstDuration(map, const [
        'duration',
        'timeRequired',
        'lengthSeconds',
        'length',
        'runtime',
      ]) !=
      null) {
    return true;
  }

  if (_bestResolvedUrl(map, const [
            'contentUrl',
            'url',
            'canonicalUrl',
            'webUrl',
          ]) !=
          null &&
      _childCollections(map).isEmpty) {
    return true;
  }

  return _childCollections(map).isEmpty &&
      (map.containsKey('position') ||
          map.containsKey('item') ||
          map.containsKey('lesson') ||
          map.containsKey('lecture'));
}

List<dynamic> _childCollections(Map<String, dynamic> map) {
  final children = <dynamic>[];
  for (final key in _knownChildKeys) {
    final value = map[key];
    if (value is List && value.isNotEmpty) {
      children.addAll(value);
    } else if (value is Map) {
      children.add(value);
    }
  }

  final item = map['item'];
  if (item is Map || item is List) {
    children.add(item);
  }

  return children;
}

const _knownChildKeys = {
  '@graph',
  'itemListElement',
  'hasPart',
  'chapters',
  'lessons',
  'curriculum',
  'sections',
  'lectures',
  'entries',
  'items',
  'children',
  'results',
  'units',
  'content',
  'modules',
  'tracks',
  'videos',
};

String? _bestString(Map<String, dynamic> map, List<String> keys) {
  for (final key in keys) {
    final value = _readText(map[key]);
    if (value != null) return value;

    final nested = map[key];
    if (nested is Map) {
      final nestedValue = _bestString(Map<String, dynamic>.from(nested), const [
        'name',
        'title',
        'text',
        'label',
        'simpleText',
      ]);
      if (nestedValue != null) return nestedValue;
    }
  }
  return null;
}

String? _readText(dynamic value) {
  if (value == null) return null;
  if (value is String) return _cleanText(value);
  if (value is num) return value.toString();
  if (value is List) {
    final buffer = value
        .map(_readText)
        .whereType<String>()
        .where((item) => item.trim().isNotEmpty)
        .join(' ');
    return _cleanText(buffer);
  }
  if (value is Map) {
    final simpleText = _readText(value['simpleText']);
    if (simpleText != null) return simpleText;

    final runs = value['runs'];
    if (runs is List) {
      final joined = runs
          .map(
            (entry) =>
                entry is Map ? _readText(entry['text']) : _readText(entry),
          )
          .whereType<String>()
          .join();
      final cleaned = _cleanText(joined);
      if (cleaned != null) return cleaned;
    }

    for (final key in const ['text', 'label', 'name', 'title']) {
      final nested = _readText(value[key]);
      if (nested != null) return nested;
    }
  }
  return null;
}

int? _firstDuration(Map<String, dynamic> map, List<String> keys) {
  for (final key in keys) {
    final seconds = _parseDurationSeconds(map[key]);
    if (seconds != null) return seconds;
  }
  return null;
}

int? _parseDurationSeconds(dynamic raw) {
  if (raw == null) return null;
  if (raw is num) {
    final seconds = raw.round();
    return seconds > 0 ? seconds : null;
  }

  final text = _readText(raw);
  if (text == null) return null;
  final trimmed = text.trim();
  if (trimmed.isEmpty) return null;

  final iso = RegExp(
    r'^PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?$',
    caseSensitive: false,
  ).firstMatch(trimmed);
  if (iso != null) {
    final hours = int.tryParse(iso.group(1) ?? '0') ?? 0;
    final minutes = int.tryParse(iso.group(2) ?? '0') ?? 0;
    final seconds = int.tryParse(iso.group(3) ?? '0') ?? 0;
    final total = (hours * 3600) + (minutes * 60) + seconds;
    return total > 0 ? total : null;
  }

  final clock = RegExp(r'^(\d{1,2}):(\d{2})(?::(\d{2}))?$').firstMatch(trimmed);
  if (clock != null) {
    final first = int.parse(clock.group(1)!);
    final second = int.parse(clock.group(2)!);
    final third = int.tryParse(clock.group(3) ?? '');
    return third == null
        ? (first * 60) + second
        : (first * 3600) + (second * 60) + third;
  }

  final hoursMatch = RegExp(
    r'(\d+)\s*(?:h|hr|hrs|hour|hours)',
    caseSensitive: false,
  ).firstMatch(trimmed);
  final minutesMatch = RegExp(
    r'(\d+)\s*(?:m|min|mins|minute|minutes)',
    caseSensitive: false,
  ).firstMatch(trimmed);
  final secondsMatch = RegExp(
    r'(\d+)\s*(?:s|sec|secs|second|seconds)',
    caseSensitive: false,
  ).firstMatch(trimmed);
  if (hoursMatch != null || minutesMatch != null || secondsMatch != null) {
    final hours = int.tryParse(hoursMatch?.group(1) ?? '0') ?? 0;
    final minutes = int.tryParse(minutesMatch?.group(1) ?? '0') ?? 0;
    final seconds = int.tryParse(secondsMatch?.group(1) ?? '0') ?? 0;
    final total = (hours * 3600) + (minutes * 60) + seconds;
    return total > 0 ? total : null;
  }

  if (RegExp(r'^\d+$').hasMatch(trimmed)) {
    final seconds = int.tryParse(trimmed);
    return seconds == null || seconds <= 0 ? null : seconds;
  }

  return null;
}

String? _bestResolvedUrl(Map<String, dynamic> map, List<String> keys) {
  for (final key in keys) {
    final value = map[key];
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
        return trimmed;
      }
    }
    if (value is Map) {
      final nested = _bestResolvedUrl(Map<String, dynamic>.from(value), const [
        'url',
        'contentUrl',
        'canonicalUrl',
        'webUrl',
      ]);
      if (nested != null) return nested;
    }
  }
  return null;
}

String? _resolveUrl(String rawUrl, Uri baseUri) {
  final trimmed = rawUrl.trim();
  if (trimmed.isEmpty) return null;
  final parsed = Uri.tryParse(trimmed);
  if (parsed == null) return null;
  return parsed.hasScheme
      ? parsed.toString()
      : baseUri.resolveUri(parsed).toString();
}
