import 'package:flutter_test/flutter_test.dart';
import 'package:focus_flow/features/add_material/course_import_service.dart';

void main() {
  group('StructuredCourseImporter', () {
    test('extracts outline items from json-ld course data', () {
      const importer = StructuredCourseImporter();
      final preview = importer.parse(
        CourseImportDocument(
          requestedUri: Uri(
            scheme: 'https',
            host: 'example.com',
            path: '/course',
          ),
          resolvedUri: Uri(
            scheme: 'https',
            host: 'example.com',
            path: '/course',
          ),
          statusCode: 200,
          headers: {},
          body: '''
<html>
  <head>
    <meta property="og:title" content="System Design Masterclass">
    <meta property="og:site_name" content="Example Learning">
    <script type="application/ld+json">
      {
        "@context": "https://schema.org",
        "@type": "Course",
        "name": "System Design Masterclass",
        "provider": {
          "@type": "Organization",
          "name": "Example Learning"
        },
        "hasPart": [
          {
            "@type": "VideoObject",
            "name": "Introduction",
            "duration": "PT5M",
            "url": "https://example.com/course/intro"
          },
          {
            "@type": "VideoObject",
            "name": "Caching Basics",
            "duration": "PT12M30S",
            "url": "https://example.com/course/caching"
          }
        ]
      }
    </script>
  </head>
</html>
''',
        ),
      );

      expect(preview, isNotNull);
      expect(preview!.title, 'System Design Masterclass');
      expect(preview.provider, 'Example Learning');
      expect(preview.items, hasLength(2));
      expect(preview.items.first.title, 'Introduction');
      expect(preview.items.first.durationSeconds, 300);
      expect(preview.items.last.durationSeconds, 750);
      expect(preview.totalDuration, 1050);
    });
  });

  group('YouTubePlaylistCourseImporter', () {
    test('extracts playlist entries from ytInitialData payload', () {
      const importer = YouTubePlaylistCourseImporter();
      final preview = importer.parse(
        CourseImportDocument(
          requestedUri: Uri.parse(
            'https://www.youtube.com/playlist?list=PL123',
          ),
          resolvedUri: Uri.parse('https://www.youtube.com/playlist?list=PL123'),
          statusCode: 200,
          headers: {},
          body: '''
<html>
  <head>
    <meta property="og:title" content="Flutter Course Playlist">
  </head>
  <body>
    <script>
      var ytInitialData = {
        "contents": {
          "twoColumnBrowseResultsRenderer": {
            "tabs": [
              {
                "tabRenderer": {
                  "content": {
                    "sectionListRenderer": {
                      "contents": [
                        {
                          "itemSectionRenderer": {
                            "contents": [
                              {
                                "playlistVideoListRenderer": {
                                  "contents": [
                                    {
                                      "playlistVideoRenderer": {
                                        "videoId": "abc123",
                                        "title": {
                                          "runs": [
                                            {"text": "Setup"}
                                          ]
                                        },
                                        "lengthSeconds": "120"
                                      }
                                    },
                                    {
                                      "playlistVideoRenderer": {
                                        "videoId": "def456",
                                        "title": {
                                          "runs": [
                                            {"text": "Widgets"}
                                          ]
                                        },
                                        "lengthSeconds": "240"
                                      }
                                    }
                                  ]
                                }
                              }
                            ]
                          }
                        }
                      ]
                    }
                  }
                }
              }
            ]
          }
        }
      };
    </script>
  </body>
</html>
''',
        ),
      );

      expect(preview, isNotNull);
      expect(preview!.provider, 'YouTube');
      expect(preview.title, 'Flutter Course Playlist');
      expect(preview.items, hasLength(2));
      expect(preview.items.first.sourceUrl, contains('abc123'));
      expect(preview.items.last.durationSeconds, 240);
    });
  });

  group('CourseImportService', () {
    test('falls back to page metadata when no outline is exposed', () async {
      final service = CourseImportService(
        fetcher: _FakeCourseImportFetcher(
          CourseImportDocument(
            requestedUri: Uri.parse('https://example.com/course'),
            resolvedUri: Uri.parse('https://example.com/course'),
            statusCode: 200,
            headers: {},
            body: '''
<html>
  <head>
    <title>Public Course Landing Page</title>
    <meta property="og:site_name" content="Example Academy">
  </head>
</html>
''',
          ),
        ),
        importers: const [StructuredCourseImporter()],
      );

      final preview = await service.importFromUrl('example.com/course');

      expect(preview.title, 'Public Course Landing Page');
      expect(preview.provider, 'Example Academy');
      expect(preview.items, isEmpty);
      expect(preview.warnings, isNotEmpty);
    });
  });
}

class _FakeCourseImportFetcher implements CourseImportFetcher {
  const _FakeCourseImportFetcher(this.document);

  final CourseImportDocument document;

  @override
  Future<CourseImportDocument> fetch(Uri uri) async => document;
}
