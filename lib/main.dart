import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:go_router/go_router.dart';
import 'models/workout_template.dart';
import 'blocs/workout_bloc.dart';
import 'blocs/template_bloc.dart';
import 'screens/home_screen.dart';
import 'screens/workout_screen.dart';
import 'screens/template_editor_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(WorkoutTemplateAdapter());
  Hive.registerAdapter(WorkoutPhaseAdapter());
  await Hive.openBox<WorkoutTemplate>('templates');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => TemplateBloc(
                Hive.box<WorkoutTemplate>('templates'),
              )..add(LoadTemplates()),
            ),
            BlocProvider(
              create: (context) => WorkoutBloc(),
            ),
          ],
          child: MaterialApp.router(
            title: 'Tabata Timer',
            theme: ThemeData(
              colorScheme: lightDynamic,
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: darkDynamic,
              useMaterial3: true,
            ),
            routerConfig: GoRouter(
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => const HomeScreen(),
                ),
                GoRoute(
                  path: '/workout/:id',
                  builder: (context, state) {
                    final templateId = state.pathParameters['id']!;
                    final template = Hive.box<WorkoutTemplate>('templates')
                        .values
                        .firstWhere((t) => t.id == templateId);
                    return WorkoutScreen(template: template);
                  },
                ),
                GoRoute(
                  path: '/template/new',
                  builder: (context, state) => const TemplateEditorScreen(),
                ),
                GoRoute(
                  path: '/template/:id',
                  builder: (context, state) => TemplateEditorScreen(
                    templateId: state.pathParameters['id'],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
