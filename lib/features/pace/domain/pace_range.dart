/// Bounds for the fastest-100m-freestyle pace, in seconds.
///
/// The slider and the MIN:SEC stepper are both clamped to this range.
abstract final class PaceRange {
  static const int minSeconds = 30; // 0:30
  static const int maxSeconds = 240; // 4:00
  static const int defaultSeconds = 90; // 1:30

  /// Tick marks shown under the slider, aligned with the level boundaries.
  static const List<int> tickSeconds = [30, 70, 90, 120, 240];
}
