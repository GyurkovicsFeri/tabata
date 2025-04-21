import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../blocs/template_bloc.dart';
import '../models/workout_template.dart';

class TemplateEditorScreen extends StatefulWidget {
  final String? templateId;

  const TemplateEditorScreen({super.key, this.templateId});

  @override
  State<TemplateEditorScreen> createState() => _TemplateEditorScreenState();
}

class _TemplateEditorScreenState extends State<TemplateEditorScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _warmupController;
  late final TextEditingController _workController;
  late final TextEditingController _restController;
  late final TextEditingController _roundsController;
  late final TextEditingController _cooldownController;

  @override
  void initState() {
    super.initState();
    final template = widget.templateId != null
        ? Hive.box<WorkoutTemplate>('templates')
            .values
            .firstWhere((t) => t.id == widget.templateId)
        : WorkoutTemplate.defaultTemplate();

    _nameController = TextEditingController(text: template.name);
    _warmupController =
        TextEditingController(text: template.warmupDuration.toString());
    _workController =
        TextEditingController(text: template.workDuration.toString());
    _restController =
        TextEditingController(text: template.restDuration.toString());
    _roundsController = TextEditingController(text: template.rounds.toString());
    _cooldownController =
        TextEditingController(text: template.cooldownDuration.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _warmupController.dispose();
    _workController.dispose();
    _restController.dispose();
    _roundsController.dispose();
    _cooldownController.dispose();
    super.dispose();
  }

  void _saveTemplate() {
    final template = WorkoutTemplate(
      id: widget.templateId,
      name: _nameController.text,
      warmupDuration: int.parse(_warmupController.text),
      workDuration: int.parse(_workController.text),
      restDuration: int.parse(_restController.text),
      rounds: int.parse(_roundsController.text),
      cooldownDuration: int.parse(_cooldownController.text),
    );

    if (widget.templateId != null) {
      context.read<TemplateBloc>().add(UpdateTemplate(template));
    } else {
      context.read<TemplateBloc>().add(AddTemplate(template));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
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
          widget.templateId != null ? 'Edit Template' : 'New Template',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: _saveTemplate,
              icon: Icon(Icons.save,
                  color: Theme.of(context).colorScheme.onSecondaryContainer),
              label: Text('Save',
                  style: TextStyle(
                      color:
                          Theme.of(context).colorScheme.onSecondaryContainer)),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Template Name',
                border: OutlineInputBorder(),
              ),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
            const SizedBox(height: 16),
            _buildDurationField(
              controller: _warmupController,
              label: 'Warm Up Duration (seconds)',
            ),
            const SizedBox(height: 16),
            _buildDurationField(
              controller: _workController,
              label: 'Work Duration (seconds)',
            ),
            const SizedBox(height: 16),
            _buildDurationField(
              controller: _restController,
              label: 'Rest Duration (seconds)',
            ),
            const SizedBox(height: 16),
            _buildDurationField(
              controller: _roundsController,
              label: 'Number of Rounds',
            ),
            const SizedBox(height: 16),
            _buildDurationField(
              controller: _cooldownController,
              label: 'Cool Down Duration (seconds)',
            ),
            const SizedBox(height: 16),
            Text(
              'Total Duration: ${_calculateTotalDuration()} seconds (${_calculateTotalDuration() ~/ 60} minutes)',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
      ),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
      keyboardType: TextInputType.number,
    );
  }

  int _calculateTotalDuration() {
    final template = WorkoutTemplate(
      id: widget.templateId,
      name: _nameController.text,
      warmupDuration: int.parse(_warmupController.text),
      workDuration: int.parse(_workController.text),
      restDuration: int.parse(_restController.text),
      rounds: int.parse(_roundsController.text),
      cooldownDuration: int.parse(_cooldownController.text),
    );

    return template.warmupDuration +
        (template.workDuration + template.restDuration) * template.rounds +
        template.cooldownDuration;
  }
}
