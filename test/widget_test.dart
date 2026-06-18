import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:test_task_swim/app.dart';

void main() {
  testWidgets('App boots into the Pace tab', (tester) async {
    await tester.pumpWidget(const SwimApp());

    expect(find.text('Pace Selector'), findsOneWidget);
    expect(find.byIcon(Icons.pool), findsOneWidget);
  });
}
