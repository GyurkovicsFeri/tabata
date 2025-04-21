import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/workout_template.dart';

// Events
abstract class TemplateEvent {}

class LoadTemplates extends TemplateEvent {}

class AddTemplate extends TemplateEvent {
  final WorkoutTemplate template;
  AddTemplate(this.template);
}

class UpdateTemplate extends TemplateEvent {
  final WorkoutTemplate template;
  UpdateTemplate(this.template);
}

class DeleteTemplate extends TemplateEvent {
  final String templateId;
  DeleteTemplate(this.templateId);
}

// State
class TemplateState {
  final List<WorkoutTemplate> templates;
  final bool isLoading;

  TemplateState({
    this.templates = const [],
    this.isLoading = false,
  });

  TemplateState copyWith({
    List<WorkoutTemplate>? templates,
    bool? isLoading,
  }) {
    return TemplateState(
      templates: templates ?? this.templates,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// BLoC
class TemplateBloc extends Bloc<TemplateEvent, TemplateState> {
  final Box<WorkoutTemplate> _templateBox;

  TemplateBloc(this._templateBox) : super(TemplateState()) {
    on<LoadTemplates>(_onLoadTemplates);
    on<AddTemplate>(_onAddTemplate);
    on<UpdateTemplate>(_onUpdateTemplate);
    on<DeleteTemplate>(_onDeleteTemplate);
  }

  void _onLoadTemplates(LoadTemplates event, Emitter<TemplateState> emit) {
    emit(state.copyWith(isLoading: true));
    final templates = _templateBox.values.toList();
    emit(state.copyWith(templates: templates, isLoading: false));
  }

  void _onAddTemplate(AddTemplate event, Emitter<TemplateState> emit) {
    _templateBox.add(event.template);
    final templates = _templateBox.values.toList();
    emit(state.copyWith(templates: templates));
  }

  void _onUpdateTemplate(UpdateTemplate event, Emitter<TemplateState> emit) {
    final index = _templateBox.values
        .toList()
        .indexWhere((t) => t.id == event.template.id);
    if (index != -1) {
      _templateBox.putAt(index, event.template);
      final templates = _templateBox.values.toList();
      emit(state.copyWith(templates: templates));
    }
  }

  void _onDeleteTemplate(DeleteTemplate event, Emitter<TemplateState> emit) {
    final index = _templateBox.values
        .toList()
        .indexWhere((t) => t.id == event.templateId);
    if (index != -1) {
      _templateBox.deleteAt(index);
      final templates = _templateBox.values.toList();
      emit(state.copyWith(templates: templates));
    }
  }
}
