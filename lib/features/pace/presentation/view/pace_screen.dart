import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task_swim/features/pace/presentation/bloc/pace_bloc.dart';
import 'package:test_task_swim/features/pace/presentation/widgets/caption.dart';
import 'package:test_task_swim/features/pace/presentation/widgets/level_badge.dart';
import 'package:test_task_swim/features/pace/presentation/widgets/pace_display.dart';
import 'package:test_task_swim/features/pace/presentation/widgets/pace_slider.dart';

/// Placeholder — the pace selector UI is implemented in a later commit.
class PaceScreen extends StatelessWidget {
  const PaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaceBloc(),
      child: const PaceView(),
    );
  }
}

class PaceView extends StatelessWidget {
  const PaceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your pace')),
      body: BlocBuilder<PaceBloc, PaceState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              spacing: 24,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PaceDisplay(state: state), // шаг 3.3
                const Caption(text: 'MIN : SEC / 100M'),
                const Caption(text: 'THAT PUTS YOU AT'),
                LevelBadge(level: state.level), // позже
                PaceSlider(state: state), // позже
                const Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }
}
