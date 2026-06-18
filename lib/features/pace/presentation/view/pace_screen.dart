import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task_swim/core/di/service_locator.dart';
import 'package:test_task_swim/core/theme/app_theme.dart';
import 'package:test_task_swim/features/pace/domain/pace_repository.dart';
import 'package:test_task_swim/features/pace/presentation/bloc/pace_bloc.dart';
import 'package:test_task_swim/features/pace/presentation/widgets/caption.dart';
import 'package:test_task_swim/features/pace/presentation/widgets/level_badge.dart';
import 'package:test_task_swim/features/pace/presentation/widgets/pace_display.dart';
import 'package:test_task_swim/features/pace/presentation/widgets/pace_slider.dart';
import 'package:test_task_swim/features/pace/presentation/widgets/swimmer_level_color.dart';

class PaceScreen extends StatelessWidget {
  const PaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaceBloc(getIt<PaceRepository>()),
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
      bottomNavigationBar: BlocBuilder<PaceBloc, PaceState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              child: TweenAnimationBuilder<Color?>(
                duration: const Duration(milliseconds: 250),
                tween: ColorTween(end: state.level.color),
                builder: (context, color, child) => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: state.status == PaceSubmitStatus.loading
                      ? null
                      : () =>
                            context.read<PaceBloc>().add(const PaceSubmitted()),
                  child: state.status == PaceSubmitStatus.loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Continue  →',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          );
        },
      ),

      body: BlocConsumer<PaceBloc, PaceState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (state.status == PaceSubmitStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error ?? 'Something went wrong'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              spacing: 24,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PaceDisplay(state: state),
                const Caption(text: 'MIN : SEC / 100M'),
                const Caption(text: 'THAT PUTS YOU AT'),
                LevelBadge(level: state.level),
                PaceSlider(state: state),
                const Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }
}
