import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'workout_template.g.dart';

@HiveType(typeId: 0)
class WorkoutTemplate extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int warmupDuration; // in seconds

  @HiveField(3)
  int workDuration;

  @HiveField(4)
  int restDuration;

  @HiveField(5)
  int rounds;

  @HiveField(6)
  int cooldownDuration;

  WorkoutTemplate({
    String? id,
    required this.name,
    required this.warmupDuration,
    required this.workDuration,
    required this.restDuration,
    required this.rounds,
    required this.cooldownDuration,
  }) : id = id ?? const Uuid().v4();

  factory WorkoutTemplate.defaultTemplate() {
    return WorkoutTemplate(
      name: 'Default Tabata',
      warmupDuration: 60,
      workDuration: 20,
      restDuration: 10,
      rounds: 8,
      cooldownDuration: 60,
    );
  }

  int get totalDuration {
    return warmupDuration +
        (workDuration + restDuration) * rounds +
        cooldownDuration;
  }
}

@HiveType(typeId: 1)
enum WorkoutPhase {
  @HiveField(0)
  warmup,
  @HiveField(1)
  work,
  @HiveField(2)
  rest,
  @HiveField(3)
  cooldown,
  @HiveField(4)
  completed
}

extension SumOfWorkout on WorkoutTemplate {
  int get totalDuration {
    return warmupDuration +
        (workDuration + restDuration) * rounds +
        cooldownDuration;
  }
}
