/// Swimmer level derived from the fastest 100m freestyle time.
///
/// Boundaries (total seconds for 100m) — documented in the README:
///   Elite:        < 1:10  (< 70s)
///   Advanced:     1:10 – 1:29  (70–89s)
///   Intermediate: 1:30 – 1:59  (90–119s)
///   Beginner:     >= 2:00  (>= 120s)
enum SwimmerLevel {
  elite('Elite', 'Sub 1:10 — competitive speed'),
  advanced('Advanced', '1:10–1:29 — strong recreational'),
  intermediate('Intermediate', '1:30–1:59 — steady technique'),
  beginner('Beginner', '2:00+ — building endurance');

  const SwimmerLevel(this.title, this.description);

  final String title;
  final String description;

  /// Maps a total time in seconds to the corresponding level.
  static SwimmerLevel fromSeconds(int totalSeconds) {
    if (totalSeconds < 70) return SwimmerLevel.elite;
    if (totalSeconds < 90) return SwimmerLevel.advanced;
    if (totalSeconds < 120) return SwimmerLevel.intermediate;
    return SwimmerLevel.beginner;
  }
}
