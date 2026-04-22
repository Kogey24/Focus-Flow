import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../domain/enums/material_type.dart' as study;

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    super.key,
    required this.value,
    required this.type,
    this.height = 6,
  });

  final double value;
  final study.MaterialType type;
  final double height;

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0, 1).toDouble();
    final accent = AppColors.accentForType(type);

    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: clamped),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
        builder: (context, animatedValue, _) {
          return LinearProgressIndicator(
            minHeight: height,
            value: animatedValue,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(accent),
          );
        },
      ),
    );
  }
}
