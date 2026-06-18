import 'package:flutter/material.dart';
import 'package:test_task_swim/core/di/service_locator.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  runApp(const SwimApp());
}
