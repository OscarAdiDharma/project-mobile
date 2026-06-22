import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talentintel_ai/core/theme/app_theme.dart';
import 'package:talentintel_ai/core/router/app_router.dart';
import 'package:talentintel_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:talentintel_ai/features/hrd_dashboard/presentation/pages/settings_page.dart';
import 'package:talentintel_ai/injection.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }

  // Load saved theme preference
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('dark_mode') ?? false;

  initDependencies();
  runApp(TalentAchiveApp(initialThemeMode: isDark ? ThemeMode.dark : ThemeMode.light));
}

class TalentAchiveApp extends StatefulWidget {
  final ThemeMode initialThemeMode;

  const TalentAchiveApp({super.key, required this.initialThemeMode});

  @override
  State<TalentAchiveApp> createState() => _TalentAchiveAppState();
}

class _TalentAchiveAppState extends State<TalentAchiveApp> {
  late final AuthBloc _authBloc;
  late final AppRouter _appRouter;
  late final ValueNotifier<ThemeMode> _themeModeNotifier;

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>();
    _appRouter = AppRouter(authBloc: _authBloc);
    _themeModeNotifier = ValueNotifier<ThemeMode>(widget.initialThemeMode);
  }

  @override
  void dispose() {
    _authBloc.close();
    _themeModeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeModeNotifier(
      notifier: _themeModeNotifier,
      child: BlocProvider<AuthBloc>.value(
        value: _authBloc,
        child: ValueListenableBuilder<ThemeMode>(
          valueListenable: _themeModeNotifier,
          builder: (context, themeMode, _) {
            return MaterialApp.router(
              title: 'Talent Achive',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              routerConfig: _appRouter.router,
            );
          },
        ),
      ),
    );
  }
}
