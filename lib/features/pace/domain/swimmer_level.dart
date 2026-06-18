enum SwimmerLevel {
  elite('Elite', 'Sub 1:10 — competitive speed'),
  advanced('Advanced', '1:10–1:29 — strong recreational'),
  intermediate('Intermediate', '1:30–1:59 — steady technique'),
  beginner('Beginner', '2:00+ — building endurance');

  const SwimmerLevel(this.title, this.description);

  final String title;
  final String description;

  static SwimmerLevel fromSeconds(int totalSeconds) {
    if (totalSeconds < 70) return SwimmerLevel.elite;
    if (totalSeconds < 90) return SwimmerLevel.advanced;
    if (totalSeconds < 120) return SwimmerLevel.intermediate;
    return SwimmerLevel.beginner;
  }
}
