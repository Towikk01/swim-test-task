import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/swimmer_level.dart';

/// Big current-level title plus a legend of all levels with the active
/// one highlighted.
class LevelBadge extends StatelessWidget {
  const LevelBadge({super.key, required this.level});

  final SwimmerLevel level;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          level.title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final l in SwimmerLevel.values)
              Text(
                l.title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: l == level ? FontWeight.bold : FontWeight.normal,
                  color: l == level
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
