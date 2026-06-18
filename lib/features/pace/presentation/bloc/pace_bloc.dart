import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task_swim/features/pace/domain/pace_range.dart';
import 'package:test_task_swim/features/pace/domain/swimmer_level.dart';

part "pace_event.dart";
part "pace_state.dart";

class PaceBloc extends Bloc<PaceEvent, PaceState> {
  PaceBloc() : super(const PaceState(totalSeconds: PaceRange.defaultSeconds)) {
    on<PaceTotalChanged>(_onTotalChanged);
    on<PaceMinutesEntered>(_onMinutesEntered);
    on<PaceSecondsEntered>(_onSecondsEntered);
  }

  void _emitClamped(Emitter<PaceState> emit, int seconds) {
    final clamped = seconds.clamp(PaceRange.minSeconds, PaceRange.maxSeconds);
    emit(state.copyWith(totalSeconds: clamped));
  }

  void _onTotalChanged(PaceTotalChanged e, Emitter<PaceState> emit) {
    _emitClamped(emit, e.totalSeconds);
  }

  void _onSecondsEntered(PaceSecondsEntered e, Emitter<PaceState> emit) {
    if (e.seconds < 0 || e.seconds > 59) return;
    _emitClamped(emit, state.minutes * 60 + e.seconds);
  }

  void _onMinutesEntered(PaceMinutesEntered e, Emitter<PaceState> emit) {
    _emitClamped(emit, e.minutes * 60 + state.seconds);
  }
}
