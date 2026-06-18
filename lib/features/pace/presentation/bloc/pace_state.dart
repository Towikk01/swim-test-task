part of 'pace_bloc.dart';

enum PaceSubmitStatus { idle, loading, success, failure }

class PaceState extends Equatable {
  const PaceState({
    required this.totalSeconds,
    this.status = PaceSubmitStatus.idle,
    this.error,
  });

  final int totalSeconds;
  final PaceSubmitStatus status;
  final String? error;

  int get minutes => totalSeconds ~/ 60;
  int get seconds => totalSeconds % 60;
  SwimmerLevel get level => SwimmerLevel.fromSeconds(totalSeconds);

  PaceState copyWith({
    int? totalSeconds,
    PaceSubmitStatus? status,
    String? error,
  }) {
    return PaceState(
      totalSeconds: totalSeconds ?? this.totalSeconds,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [totalSeconds, status, error];
}
