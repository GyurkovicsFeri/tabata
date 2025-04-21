import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/workout_bloc.dart';
import '../models/workout_template.dart';
import '../services/audio_service.dart';

class WorkoutScreen extends StatefulWidget {
  final WorkoutTemplate template;

  const WorkoutScreen({super.key, required this.template});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  late final AudioService _audioService;

  @override
  void initState() {
    super.initState();
    _audioService = AudioService();
    context.read<WorkoutBloc>().add(StartWorkout(widget.template));
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  Color _getPhaseColor(WorkoutPhase phase) {
    switch (phase) {
      case WorkoutPhase.warmup:
        return Colors.blue;
      case WorkoutPhase.work:
        return Colors.red;
      case WorkoutPhase.rest:
        return Colors.green;
      case WorkoutPhase.cooldown:
        return Colors.blue;
      case WorkoutPhase.completed:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.template.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: () {
              _audioService.toggleMute();
              setState(() {});
            },
          ),
        ],
      ),
      body: BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          if (state.activeWorkout == null) {
            return const Center(child: Text('No active workout'));
          }

          final workout = state.activeWorkout!;
          final phaseColor = _getPhaseColor(workout.currentPhase);

          return Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        workout.phaseName,
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  color: phaseColor,
                                ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        workout.timeDisplay,
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  color: phaseColor,
                                ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Round ${workout.currentRound} of ${workout.template.rounds}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (workout.isCompleted)
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Finish'),
                      )
                    else
                      ElevatedButton(
                        onPressed: () {
                          if (state.isRunning) {
                            context.read<WorkoutBloc>().add(PauseWorkout());
                          } else {
                            context.read<WorkoutBloc>().add(ResumeWorkout());
                          }
                        },
                        child: Text(state.isRunning ? 'Pause' : 'Resume'),
                      ),
                    if (!workout.isCompleted)
                      ElevatedButton(
                        onPressed: () {
                          context.read<WorkoutBloc>().add(StopWorkout());
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Stop'),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
