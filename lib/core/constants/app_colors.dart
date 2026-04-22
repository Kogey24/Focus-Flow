import 'package:flutter/material.dart';

import '../../domain/enums/material_type.dart' as study;

abstract final class AppColors {
  static const Color primary = Color(0xFF185FA5);
  static const Color book = Color(0xFF185FA5);
  static const Color video = Color(0xFF1D9E75);
  static const Color audio = Color(0xFFBA7517);
  static const Color course = Color(0xFF534AB7);
  static const Color darkBackground = Color(0xFF181A1F);
  static const Color darkSurface = Color(0xFF23262D);
  static const Color darkSurfaceAlt = Color(0xFF2C3038);
  static const Color lightSurfaceAlt = Color(0xFFF4F7FB);

  static Color accentForType(study.MaterialType type) {
    return switch (type) {
      study.MaterialType.book => book,
      study.MaterialType.video => video,
      study.MaterialType.audio => audio,
      study.MaterialType.course => course,
    };
  }
}
