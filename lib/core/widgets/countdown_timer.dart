import 'package:flutter/material.dart';

import '../utils/duration_formatter.dart';

class CountdownTimer extends StatelessWidget {
  const CountdownTimer({
    super.key,
    required this.total,
    required this.remaining,
    this.onComplete,
  });

  final Duration total;
  final Duration remaining;
  final VoidCallback? onComplete;

  @override
  Widget build(BuildContext context) {
    final progress = total.inMilliseconds == 0
        ? 0.0
        : 1 - (remaining.inMilliseconds / total.inMilliseconds).clamp(0.0, 1.0);

    if (remaining <= Duration.zero && onComplete != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => onComplete?.call());
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      builder: (context, animatedProgress, _) {
        return SizedBox(
          width: 220,
          height: 220,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: animatedProgress,
                strokeWidth: 10,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DurationFormatter.asClock(remaining),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'remaining',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
