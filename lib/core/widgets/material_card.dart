import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../domain/models/material.dart';
import 'progress_bar.dart';

class MaterialCard extends StatelessWidget {
  const MaterialCard({
    super.key,
    required this.material,
    required this.onTap,
  });

  final StudyMaterial material;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = AppColors.accentForType(material.type);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSheet),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withOpacity(0.35),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSheet),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacing16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Thumbnail(material: material, accent: accent),
              const SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            material.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spacing8),
                        _StatusChip(status: material.status),
                      ],
                    ),
                    if ((material.author ?? '').isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        material.author!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppDimensions.spacing12),
                    Row(
                      children: [
                        Expanded(
                          child: ProgressBar(
                            value: material.progress,
                            type: material.type,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spacing8),
                        Text(
                          '${(material.progress * 100).round()}%',
                          style: theme.textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({
    required this.material,
    required this.accent,
  });

  final StudyMaterial material;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final thumb = material.thumbnailPath;
    final isNetwork = thumb?.startsWith('http') ?? false;

    Widget child;
    if (thumb != null && thumb.isNotEmpty) {
      child = ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: isNetwork
            ? CachedNetworkImage(
                imageUrl: thumb,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              )
            : Image.file(
                File(thumb),
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fallback(theme),
              ),
      );
    } else {
      child = _fallback(theme);
    }

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: accent.withOpacity(0.14),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }

  Widget _fallback(ThemeData theme) {
    return Icon(
      material.type.icon,
      color: accent,
      size: 28,
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (label, color) = switch (status) {
      'completed' => ('Completed', Colors.green),
      'in_progress' => ('In progress', theme.colorScheme.primary),
      _ => ('Not started', theme.colorScheme.outline),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: color.withOpacity(0.12),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
