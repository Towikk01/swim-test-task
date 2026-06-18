import 'package:flutter/material.dart';

import '../../domain/swimmer_level.dart';

/// Presentation-only mapping of a swimmer level to an accent color.
/// Kept out of the domain enum so `SwimmerLevel` stays UI-agnostic.
///
/// The scale climbs from calm blue (Beginner) to premium gold (Elite) —
/// the faster the pace, the "cooler" the color.
extension SwimmerLevelColor on SwimmerLevel {
  Color get color => switch (this) {
        SwimmerLevel.beginner => const Color(0xFF60A5FA), // blue
        SwimmerLevel.intermediate => const Color(0xFF2DD4BF), // teal
        SwimmerLevel.advanced => const Color(0xFF34D399), // emerald
        SwimmerLevel.elite => const Color(0xFFFBBF24), // gold
      };
}
