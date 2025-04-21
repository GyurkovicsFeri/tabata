import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/workout_template.dart';
import '../models/active_workout.dart';
import '../services/audio_service.dart';

// Events
abstract class WorkoutEvent {}

class StartWorkout extends WorkoutEvent {
  final WorkoutTemplate template;
  StartWorkout(this.template);
}

class PauseWorkout extends WorkoutEvent {}

class ResumeWorkout extends WorkoutEvent {}

class StopWorkout extends WorkoutEvent {}

class TimerTick extends WorkoutEvent {}

// State
class WorkoutState {
  final ActiveWorkout? activeWorkout;
  final bool isRunning;

  WorkoutState({
    this.activeWorkout,
    this.isRunning = false,
  });

  WorkoutState copyWith({
    ActiveWorkout? activeWorkout,
    bool? isRunning,
  }) {
    return WorkoutState(
      activeWorkout: activeWorkout ?? this.activeWorkout,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}

// BLoC
class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  Timer? _timer;
  final AudioService _audioService = AudioService();

  WorkoutBloc() : super(WorkoutState()) {
    on<StartWorkout>(_onStartWorkout);
    on<PauseWorkout>(_onPauseWorkout);
    on<ResumeWorkout>(_onResumeWorkout);
    on<StopWorkout>(_onStopWorkout);
    on<TimerTick>(_onTimerTick);
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => add(TimerTick()),
    );
  }

  void _onStartWorkout(StartWorkout event, Emitter<WorkoutState> emit) {
    final activeWorkout = ActiveWorkout(template: event.template);
    emit(WorkoutState(activeWorkout: activeWorkout, isRunning: true));
    _audioService.playPhaseStart();
    _startTimer();
  }

  void _onPauseWorkout(PauseWorkout event, Emitter<WorkoutState> emit) {
    _timer?.cancel();
    if (state.activeWorkout != null) {
      state.activeWorkout!.isPaused = true;
      emit(state.copyWith(isRunning: false));
    }
  }

  void _onResumeWorkout(ResumeWorkout event, Emitter<WorkoutState> emit) {
    if (state.activeWorkout != null) {
      state.activeWorkout!.isPaused = false;
      emit(state.copyWith(isRunning: true));
      _audioService.playPhaseStart();
      _startTimer();
    }
  }

  void _onStopWorkout(StopWorkout event, Emitter<WorkoutState> emit) {
    _timer?.cancel();
    emit(WorkoutState());
  }

  void _onTimerTick(TimerTick event, Emitter<WorkoutState> emit) {
    if (state.activeWorkout == null || !state.isRunning) return;

    final workout = state.activeWorkout!;
    if (workout.remainingTime > 0) {
      if (workout.remainingTime <= 3) {
        _audioService.playCountdown();
      }
      workout.remainingTime--;
      emit(state.copyWith());
    } else {
      _audioService.playPhaseEnd();
      _moveToNextPhase(workout, emit);
    }
  }

  void _moveToNextPhase(ActiveWorkout workout, Emitter<WorkoutState> emit) {
    switch (workout.currentPhase) {
      case WorkoutPhase.warmup:
        workout.currentPhase = WorkoutPhase.work;
        workout.remainingTime = workout.template.workDuration;
        break;
      case WorkoutPhase.work:
        if (workout.currentRound < workout.template.rounds) {
          workout.currentPhase = WorkoutPhase.rest;
          workout.remainingTime = workout.template.restDuration;
        } else {
          workout.currentPhase = WorkoutPhase.cooldown;
          workout.remainingTime = workout.template.cooldownDuration;
        }
        break;
      case WorkoutPhase.rest:
        workout.currentRound++;
        workout.currentPhase = WorkoutPhase.work;
        workout.remainingTime = workout.template.workDuration;
        break;
      case WorkoutPhase.cooldown:
        workout.currentPhase = WorkoutPhase.completed;
        _timer?.cancel();
        break;
      case WorkoutPhase.completed:
        break;
    }
    emit(state.copyWith());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _audioService.dispose();
    return super.close();
  }
}
