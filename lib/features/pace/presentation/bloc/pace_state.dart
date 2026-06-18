part of 'pace_bloc.dart';





class PaceState extends Equatable {
  const PaceState({required this.totalSeconds});

  /// Currently selected pace, in seconds (always within [PaceRange]).
  final int totalSeconds;

  int get minutes => totalSeconds ~/ 60;
  int get seconds => totalSeconds % 60;
  SwimmerLevel get level => SwimmerLevel.fromSeconds(totalSeconds);

  PaceState copyWith({int? totalSeconds}) {
    return PaceState(totalSeconds: totalSeconds ?? this.totalSeconds);
  }

  @override
  List<Object?> get props => [totalSeconds];
}
