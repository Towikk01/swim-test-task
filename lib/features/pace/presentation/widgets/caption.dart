import 'package:flutter/material.dart';
import 'package:test_task_swim/core/theme/app_theme.dart';

class Caption extends StatelessWidget {
  final String text;
  const Caption({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(letterSpacing: 2, color: AppColors.textSecondary),
    );
  }
}
