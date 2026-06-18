import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:test_task_swim/features/pace/domain/pace_repository.dart';
import 'package:test_task_swim/features/pace/domain/pace_range.dart';
import 'package:test_task_swim/features/pace/domain/swimmer_level.dart';

part "pace_event.dart";
part "pace_state.dart";

EventTransformer<E> _debounce<E>(Duration d) =>
    (events, mapper) => events.debounce(d).switchMap(mapper);

class PaceBloc extends Bloc<PaceEvent, PaceState> {
  final PaceRepository _repository;
  PaceBloc(this._repository)
    : super(const PaceState(totalSeconds: PaceRange.defaultSeconds)) {
    on<PaceTotalChanged>(_onTotalChanged);
    on<PaceMinutesEntered>(_onMinutesEntered);
    on<PaceSecondsEntered>(_onSecondsEntered);
    on<PaceSubmitted>(
      _onSubmitted,
      transformer: _debounce(const Duration(milliseconds: 500)),
    );
  }

  void _emitClamped(Emitter<PaceState> emit, int seconds) {
    final clamped = seconds.clamp(PaceRange.minSeconds, PaceRange.maxSeconds);
    emit(state.copyWith(totalSeconds: clamped));
  }

  void _onTotalChanged(PaceTotalChanged e, Emitter<PaceState> emit) {
    _emitClamped(emit, e.totalSeconds);
    add(const PaceSubmitted()); // ← только в валидной ветке
  }

  void _onSecondsEntered(PaceSecondsEntered e, Emitter<PaceState> emit) {
    if (e.seconds < 0 || e.seconds > 59) return;
    _emitClamped(emit, state.minutes * 60 + e.seconds);
    add(const PaceSubmitted()); // ← только в валидной ветке
  }

  void _onMinutesEntered(PaceMinutesEntered e, Emitter<PaceState> emit) {
    _emitClamped(emit, e.minutes * 60 + state.seconds);
    add(const PaceSubmitted()); // ← только в валидной ветке
  }

  Future<void> _onSubmitted(PaceSubmitted e, Emitter<PaceState> emit) async {
    emit(state.copyWith(status: PaceSubmitStatus.loading));
    try {
      await _repository.submitPace(state.totalSeconds);
      emit(state.copyWith(status: PaceSubmitStatus.success));
    } catch (_) {
      emit(
        state.copyWith(
          status: PaceSubmitStatus.failure,
          error: 'Failed to save pace. Check your connection.',
        ),
      );
    }
  }
}
