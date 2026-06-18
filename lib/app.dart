import 'package:flutter/material.dart';

import 'core/home/home_shell.dart';
import 'core/theme/app_theme.dart';

class SwimApp extends StatelessWidget {
  const SwimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swim',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const HomeShell(),
    );
  }
}
