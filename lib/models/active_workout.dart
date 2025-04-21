import 'workout_template.dart';

class ActiveWorkout {
  final WorkoutTemplate template;
  WorkoutPhase currentPhase;
  int currentRound;
  int remainingTime;
  bool isPaused;

  ActiveWorkout({
    required this.template,
    this.currentPhase = WorkoutPhase.warmup,
    this.currentRound = 1,
    int? remainingTime,
    this.isPaused = false,
  }) : remainingTime = remainingTime ?? template.warmupDuration;

  bool get isCompleted => currentPhase == WorkoutPhase.completed;

  String get phaseName {
    switch (currentPhase) {
      case WorkoutPhase.warmup:
        return 'Warm Up';
      case WorkoutPhase.work:
        return 'Work';
      case WorkoutPhase.rest:
        return 'Rest';
      case WorkoutPhase.cooldown:
        return 'Cool Down';
      case WorkoutPhase.completed:
        return 'Completed';
    }
  }

  String get timeDisplay {
    final minutes = remainingTime ~/ 60;
    final seconds = remainingTime % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
