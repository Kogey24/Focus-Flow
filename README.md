# Focus Flow

Focus Flow is a Flutter study companion for organizing learning material, breaking it into manageable sections, and running focused study sessions against that structure.

The app is designed around a local-first workflow. You can import books, videos, audio, and structured courses, track progress through sections, and view focus history and streaks over time. Courses can now also start from a pasted URL, with the app attempting to fetch public course metadata and outlines when the source exposes them.

## Core Features

- Library management for books, videos, audio, and structured courses
- Focus sessions with selectable duration, queued study targets, and progress tracking
- Hierarchical reading flow for books: part -> chapter -> topic -> start session
- Multi-item focus queues for book topics, video episodes, and audio tracks within one session
- Course URL import foundation for public course pages and playlist-style learning links
- Local progress tracking for chapters, topics, sessions, and completions
- Notes on book sections from the material detail view
- Home dashboard with streaks, today's focus time, and recommended materials
- Stats screen with focus totals, streaks, completed sessions, completed materials, and charts
- Settings for session length, break length, daily goals, reminder preferences, and local data reset

## Material Support

### Books

- Best experience is currently with PDF books
- The app attempts to extract a nested table of contents and convert it into parts, chapters, and topics
- Page ranges are stored per section when available
- If table-of-contents parsing fails, the app falls back to a coarse inferred split

### Video and Audio

- Import multiple files or scan a folder
- Each file becomes a track, lesson, or episode entry
- Duration is probed from the media file
- You can queue multiple episodes or tracks into one focus session and move through them without restarting the timer

### Courses

- Can still be structured manually inside the app
- Can now start from a pasted course URL using the course import flow
- Public course pages may provide:
  - course title
  - provider/site name
  - thumbnail
  - lesson/topic list
  - lesson durations
- The current import foundation works best with:
  - YouTube playlist-style pages
  - public pages that expose JSON-LD or similar structured page data
- If an online page exposes only partial data, the app falls back to page metadata and lets you finish the outline manually
- Useful for linking external material, online lessons, or custom study plans

## Online Course Import Behavior

The course URL flow is intentionally best-effort.

Current behavior:

1. Choose `Course` in `Add material`.
2. Paste a public course URL.
3. Tap `Fetch outline`.
4. The app tries provider-aware parsing first, then generic structured-page parsing.
5. If topics/episodes are found, they are previewed as course items with durations when available.
6. If only page metadata is available, the app can still save the course and you can add manual topics.

Important notes:

- Online import is metadata-first. It does not download or mirror the remote course content.
- Release Android builds must include `android.permission.INTERNET` in `android/app/src/main/AndroidManifest.xml` for course URL fetching to work.
- Some providers block bots, require JavaScript execution, or require an authenticated browser session before showing the real curriculum.
- Protected share links can fail even when they open normally in Chrome on the phone.
- Existing materials keep the type they were saved with. For example, an older item saved as a `Book` will remain a book even if its text contains a course URL.

## Book Hierarchy Behavior

For books, Focus Flow is built around nested study structure rather than a single flat chapter list.

The intended flow is:

1. Import a book.
2. Let the app detect the book structure from the table of contents when possible.
3. Open the book in the library to see its nested structure.
4. Start a focus session and drill down through the hierarchy.
5. Select one or more final readable nodes, such as topics or leaf chapters, to build the queue.
6. Begin one focus session that keeps advancing through the queued topics until the session time ends.

If a selected item still has children, the app shows the next level instead of adding it immediately. Queue entries are created only from final leaf sections in the hierarchy. During the session, marking the current topic done removes it from the queue and displays the next queued topic without ending the timer.

## Table of Contents Parsing

Book structure extraction is currently centered on Android and text-based PDFs.

The app uses a native Android bridge backed by `pdfbox-android` to:

- scan early pages for printed table-of-contents pages
- infer hierarchy levels from indentation and labels such as `Part` and `Chapter`
- resolve detected entries back to their actual PDF page numbers
- build nested chapter trees for the Flutter UI

Important notes:

- This works best for text-based PDFs with a readable printed table of contents
- It does not currently perform OCR for scanned image-only table-of-contents pages
- Imported materials keep the structure saved at import time
- If the parser improves later, already imported books will not update automatically; they need to be re-imported or re-indexed

## Tech Stack

- Flutter
- Riverpod and `riverpod_annotation` for state management
- GoRouter for app navigation
- Drift for local database persistence
- SharedPreferences for lightweight settings
- `pdfx` for PDF handling in Flutter
- `pdfbox-android` for Android table-of-contents extraction
- `ffmpeg_kit_audio_flutter` for media duration probing
- `dart:io` HTTP fetching for public course metadata and outline import

## Project Structure

```text
lib/
  core/        shared widgets, utilities, constants, providers
  data/        Drift database tables and repositories
  domain/      models and enums
  features/    feature-oriented UI and state modules

android/
  app/src/main/kotlin/com/example/focus_flow/
    MainActivity.kt
    PdfTableOfContentsExtractor.kt
```

Key feature modules:

- `lib/features/home` for the dashboard
- `lib/features/library` for browsing materials
- `lib/features/add_material` for import and structure editing
- `lib/features/material_detail` for material-specific views
- `lib/features/focus_session` for session setup and timer flow
- `lib/features/stats` for progress analytics
- `lib/features/settings` for user preferences and local reset

## Getting Started

### Prerequisites

- Flutter SDK with Dart `3.9.2` or newer
- Android development environment if you want the full PDF table-of-contents parsing workflow

### Install

```bash
flutter pub get
```

### Run the app

```bash
flutter run
```

### Regenerate code after schema or annotation changes

If you modify Drift tables or Riverpod annotated classes, regenerate code with:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Build a release APK

```bash
flutter build apk --release --split-per-abi
```

This produces the ABI-split APK pattern used for testing:

- `app-arm64-v8a-release.apk`
- `app-armeabi-v7a-release.apk`
- `app-x86_64-release.apk`

## Typical Usage

### Add a book

1. Open `Library`
2. Tap `Add material`
3. Choose `Book`
4. Upload a PDF
5. Review the detected structure
6. Save it to the library

### Start a queued focus session for a book

1. Open `Focus session`
2. Select a book
3. Choose a part
4. Choose a chapter if the part contains chapters
5. Choose one or more final topics or leaf chapters to add to the queue
6. Set the session length
7. Start the session
8. Mark each topic done to advance to the next queued topic while the same session keeps running

### Start a queued focus session for video or audio

1. Open a video or audio material from the library
2. Enter the focus-session flow from that material
3. Add multiple episodes or tracks to the queue
4. Start one session for the full queue
5. Mark the current item done to move to the next queued item without restarting the session

### Add a course from a URL

1. Open `Library`
2. Tap `Add material`
3. Choose `Course`
4. Paste a course URL into `Course URL`
5. Tap `Fetch outline`
6. Review the imported title, provider, topics, and durations if available
7. Add or edit manual topics if the source exposes only partial data
8. Save the course to the library

### Track progress

- Mark sections, topics, episodes, or tracks complete from within the running session
- Let the queue advance automatically to the next selected item in the same session
- Return to the material detail view to continue from the next incomplete leaf
- Review streaks and summaries from `Home` and `Stats`

## Data and Storage

Focus Flow is currently local-first.

- Imported source files are copied into the app's documents directory
- Online course imports store fetched metadata and remote source URLs locally, but not the remote media itself
- Material metadata, chapters, notes, sessions, snapshots, and streaks are stored locally
- Clearing app data from settings removes local materials, sessions, notes, and stats from the device

## Current Limitations

- Automatic nested table-of-contents extraction is Android-focused
- Text-based PDFs work much better than scanned PDFs
- Existing imported books do not auto-refresh when parsing logic changes
- Book workflows are the most advanced path in the app right now
- Online course imports currently work only for sources that expose public metadata or structured page data
- Sites protected by JavaScript challenges, anti-bot pages, or login walls may return no course title and no outline
- Udemy-style share links may require a provider-specific integration beyond the current public-page importer foundation

## Repository Purpose

This repository tracks the ongoing development of Focus Flow as a structured study tracker for reading, listening, and lesson-based learning. The current direction is to make book study feel natural by preserving the hierarchy from the source material and using that hierarchy all the way through the focus-session flow.
