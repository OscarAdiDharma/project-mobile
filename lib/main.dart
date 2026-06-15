import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentintel_ai/core/theme/app_theme.dart';
import 'package:talentintel_ai/core/router/app_router.dart';
import 'package:talentintel_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:talentintel_ai/injection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initDependencies();
  runApp(const TalentIntelApp());
}

class TalentIntelApp extends StatefulWidget {
  const TalentIntelApp({super.key});

  @override
  State<TalentIntelApp> createState() => _TalentIntelAppState();
}

class _TalentIntelAppState extends State<TalentIntelApp> {
  // Keep the AuthBloc alive for the entire app lifetime.
  // The router listens to it for redirect decisions.
  late final AuthBloc _authBloc;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>();
    _appRouter = AppRouter(authBloc: _authBloc);
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>.value(
      value: _authBloc,
      child: MaterialApp.router(
        title: 'TalentIntel AI',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: _appRouter.router,
      ),
    );
  }
}
