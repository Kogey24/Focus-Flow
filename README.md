# Focus Flow

Focus Flow is a Flutter study companion for organizing learning material, breaking it into manageable sections, and running focused study sessions against that structure.

The app is designed around a local-first workflow. You can import books, videos, audio, and manually structured courses, track progress through sections, and view focus history and streaks over time.

## Core Features

- Library management for books, videos, audio, and manually structured courses
- Focus sessions with selectable duration and progress tracking
- Hierarchical reading flow for books: part -> chapter -> topic -> start session
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

### Courses

- Structured manually inside the app
- Useful for linking external material, online lessons, or custom study plans

## Book Hierarchy Behavior

For books, Focus Flow is built around nested study structure rather than a single flat chapter list.

The intended flow is:

1. Import a book.
2. Let the app detect the book structure from the table of contents when possible.
3. Open the book in the library to see its nested structure.
4. Start a focus session and drill down through the hierarchy.
5. Select the final readable node, such as a topic or leaf chapter, and begin the session.

If a selected item still has children, the app shows the next level instead of starting immediately. A session only starts once the selected item is a final leaf in the hierarchy.

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
flutter build apk --release
```

## Typical Usage

### Add a book

1. Open `Library`
2. Tap `Add material`
3. Choose `Book`
4. Upload a PDF
5. Review the detected structure
6. Save it to the library

### Start a focus session for a book

1. Open `Focus session`
2. Select a book
3. Choose a part
4. Choose a chapter if the part contains chapters
5. Choose a topic if the chapter contains topics
6. Set the session length
7. Start the session

### Track progress

- Mark sections complete
- Return to the material detail view to continue from the next incomplete leaf
- Review streaks and summaries from `Home` and `Stats`

## Data and Storage

Focus Flow is currently local-first.

- Imported source files are copied into the app's documents directory
- Material metadata, chapters, notes, sessions, snapshots, and streaks are stored locally
- Clearing app data from settings removes local materials, sessions, notes, and stats from the device

## Current Limitations

- Automatic nested table-of-contents extraction is Android-focused
- Text-based PDFs work much better than scanned PDFs
- Existing imported books do not auto-refresh when parsing logic changes
- Book workflows are the most advanced path in the app right now

## Repository Purpose

This repository tracks the ongoing development of Focus Flow as a structured study tracker for reading, listening, and lesson-based learning. The current direction is to make book study feel natural by preserving the hierarchy from the source material and using that hierarchy all the way through the focus-session flow.
