import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../bloc/pace_bloc.dart';
import 'number_stepper.dart';

/// The MIN : SEC display — two steppers around a colon.
class PaceDisplay extends StatelessWidget {
  const PaceDisplay({super.key, required this.state});

  final PaceState state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PaceBloc>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        NumberStepper(
          value: '${state.minutes}',
          label: 'MIN',
          onIncrement: () =>
              bloc.add(PaceTotalChanged(state.totalSeconds + 60)),
          onDecrement: () =>
              bloc.add(PaceTotalChanged(state.totalSeconds - 60)),
          onSubmitted: (m) => bloc.add(PaceMinutesEntered(m)),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            ':',
            style: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
        ),
        NumberStepper(
          value: state.seconds.toString().padLeft(2, '0'),
          label: 'SEC',
          onIncrement: () => bloc.add(PaceTotalChanged(state.totalSeconds + 1)),
          onDecrement: () => bloc.add(PaceTotalChanged(state.totalSeconds - 1)),
          onSubmitted: (s) => bloc.add(PaceSecondsEntered(s)),
        ),
      ],
    );
  }
}
