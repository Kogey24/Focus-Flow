import 'package:flutter/material.dart';

enum MaterialType {
  book,
  video,
  audio,
  course;

  String get value => name;

  String get label => switch (this) {
        MaterialType.book => 'Book',
        MaterialType.video => 'Video',
        MaterialType.audio => 'Audio',
        MaterialType.course => 'Course',
      };

  IconData get icon => switch (this) {
        MaterialType.book => Icons.menu_book_rounded,
        MaterialType.video => Icons.ondemand_video_rounded,
        MaterialType.audio => Icons.headphones_rounded,
        MaterialType.course => Icons.school_rounded,
      };

  static MaterialType fromValue(String value) {
    return MaterialType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => MaterialType.book,
    );
  }
}
