import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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

  _initializeAudioPlayer();

  runApp(const MyApp());
}

void _initializeAudioPlayer() {
  AudioPlayer.global.setAudioContext(AudioContextConfig(
    route: AudioContextConfigRoute.system,
    duckAudio: false,
    respectSilence: false,
    stayAwake: false,
  ).build());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        final baseTheme = ThemeData(
          useMaterial3: true,
          typography: Typography.material2021(),
        );

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
            debugShowCheckedModeBanner: false,
            theme: baseTheme.copyWith(
              colorScheme: lightDynamic,
              textTheme:
                  GoogleFonts.interTextTheme(baseTheme.textTheme).copyWith(
                displayLarge: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
                displayMedium: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
                displaySmall: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                ),
                titleLarge: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                titleMedium: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                bodyLarge: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                bodyMedium: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            darkTheme: baseTheme.copyWith(
              colorScheme: darkDynamic,
              textTheme:
                  GoogleFonts.interTextTheme(baseTheme.textTheme).copyWith(
                displayLarge: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
                displayMedium: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
                displaySmall: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                ),
                titleLarge: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                titleMedium: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                bodyLarge: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                bodyMedium: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
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
