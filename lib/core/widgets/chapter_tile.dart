import 'package:flutter/material.dart';

import '../../core/constants/app_dimensions.dart';

class ChapterTile extends StatelessWidget {
  const ChapterTile({
    super.key,
    required this.title,
    required this.isCompleted,
    required this.onToggle,
    this.subtitle,
    this.indentLevel = 0,
    this.isActive = false,
    this.onTap,
    this.onLongPress,
  });

  final String title;
  final String? subtitle;
  final bool isCompleted;
  final bool isActive;
  final int indentLevel;
  final VoidCallback onToggle;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isActive ? theme.colorScheme.primary.withOpacity(0.12) : Colors.transparent;

    return Padding(
      padding: EdgeInsets.only(left: indentLevel * 18.0),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        child: ListTile(
          onTap: onTap,
          onLongPress: onLongPress,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          leading: Checkbox(
            value: isCompleted,
            onChanged: (_) => onToggle(),
          ),
          title: Text(
            title,
            style: theme.textTheme.bodyLarge?.copyWith(
              decoration: isCompleted ? TextDecoration.lineThrough : null,
              color: isCompleted
                  ? theme.colorScheme.onSurfaceVariant
                  : theme.colorScheme.onSurface,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          subtitle: subtitle == null
              ? null
              : Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
        ),
      ),
    );
  }
}
