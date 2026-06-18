part of 'pace_bloc.dart';

sealed class PaceEvent extends Equatable {
  const PaceEvent();

  @override
  List<Object?> get props => [];
}

class PaceTotalChanged extends PaceEvent {
  const PaceTotalChanged(this.totalSeconds);
  final int totalSeconds;
  @override
  List<Object?> get props => [totalSeconds];
}

class PaceMinutesEntered extends PaceEvent {
  const PaceMinutesEntered(this.minutes);
  final int minutes;
  @override
  List<Object?> get props => [minutes];
}

class PaceSecondsEntered extends PaceEvent {
  const PaceSecondsEntered(this.seconds);
  final int seconds;

  @override
  List<Object?> get props => [seconds];
}
