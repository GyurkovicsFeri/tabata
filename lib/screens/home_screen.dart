import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/template_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabata Timer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/template/new'),
          ),
        ],
      ),
      body: BlocBuilder<TemplateBloc, TemplateState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.templates.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No templates yet'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.push('/template/new'),
                    child: const Text('Create Template'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: state.templates.length,
            itemBuilder: (context, index) {
              final template = state.templates[index];
              return ListTile(
                title: Text(template.name),
                subtitle: Text(
                  '${template.rounds} rounds • ${template.workDuration}s work • ${template.restDuration}s rest',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => context.push('/template/${template.id}'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Template'),
                            content: Text(
                                'Are you sure you want to delete ${template.name}?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  context
                                      .read<TemplateBloc>()
                                      .add(DeleteTemplate(template.id));
                                  Navigator.pop(context);
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                onTap: () => context.push('/workout/${template.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
