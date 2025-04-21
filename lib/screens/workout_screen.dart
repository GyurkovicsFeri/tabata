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
        return Colors.blue.withOpacity(0.1);
      case WorkoutPhase.work:
        return Colors.red.withOpacity(0.1);
      case WorkoutPhase.rest:
        return Colors.green.withOpacity(0.1);
      case WorkoutPhase.cooldown:
        return Colors.blue.withOpacity(0.1);
      case WorkoutPhase.completed:
        return Colors.grey.withOpacity(0.1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.8),
              ],
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.template.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: Icon(
                _audioService.isMuted ? Icons.volume_off : Icons.volume_up,
                color: Colors.white,
              ),
              onPressed: () {
                _audioService.toggleMute();
                setState(() {});
              },
            ),
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

          return Container(
            color: phaseColor,
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          workout.phaseName,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                color: Colors.black,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          workout.timeDisplay,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                color: Colors.black,
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
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (workout.isCompleted)
                          SizedBox(
                            width: 160,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                textStyle: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Finish'),
                            ),
                          )
                        else
                          SizedBox(
                            width: 160,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () {
                                if (state.isRunning) {
                                  context
                                      .read<WorkoutBloc>()
                                      .add(PauseWorkout());
                                } else {
                                  context
                                      .read<WorkoutBloc>()
                                      .add(ResumeWorkout());
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                textStyle: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(state.isRunning ? 'Pause' : 'Resume'),
                            ),
                          ),
                        if (!workout.isCompleted)
                          SizedBox(
                            width: 160,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () {
                                context.read<WorkoutBloc>().add(StopWorkout());
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                textStyle: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Stop'),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
