import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/pace_range.dart';
import '../bloc/pace_bloc.dart';

/// Horizontal slider over the pace range plus labelled tick marks.
class PaceSlider extends StatelessWidget {
  const PaceSlider({super.key, required this.state});

  final PaceState state;

  static String _format(int seconds) =>
      '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PaceBloc>();

    return Column(
      children: [
        Slider(
          min: PaceRange.minSeconds.toDouble(),
          max: PaceRange.maxSeconds.toDouble(),
          // one division per second → integer-only values
          divisions: PaceRange.maxSeconds - PaceRange.minSeconds,
          value: state.totalSeconds.toDouble(),
          activeColor: AppColors.accent,
          inactiveColor: AppColors.surfaceVariant,
          onChanged: (v) => bloc.add(PaceTotalChanged(v.round())),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final tick in PaceRange.tickSeconds)
                Text(
                  _format(tick),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
