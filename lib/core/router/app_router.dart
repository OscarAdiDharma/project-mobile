import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talentintel_ai/features/auth/domain/entities/user.dart';
import 'package:talentintel_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:talentintel_ai/features/auth/presentation/pages/login_page.dart';
import 'package:talentintel_ai/features/hrd_dashboard/presentation/pages/hrd_shell_page.dart';
import 'package:talentintel_ai/features/employee_dashboard/presentation/pages/employee_shell_page.dart';
import 'package:talentintel_ai/features/employee_analysis/presentation/pages/employee_detail_page.dart';

/// App-wide router configuration.
///
/// Uses GoRouter's `redirect` to guard routes based on auth state.
/// - Not authenticated → /login
/// - Authenticated as HRD → /hrd
/// - Authenticated as Employee → /employee
class AppRouter {
  final AuthBloc authBloc;

  AppRouter({required this.authBloc});

  late final GoRouter router = GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,

    // Redirect based on authentication state.
    redirect: (context, state) {
      final authState = authBloc.state;
      final isOnLogin = state.matchedLocation == '/login';

      // Not logged in → must go to login.
      if (authState is! AuthAuthenticated) {
        return isOnLogin ? null : '/login';
      }

      // Logged in but still on login page → redirect to the right portal.
      if (isOnLogin) {
        return authState.user.role == UserRole.hrd ? '/hrd' : '/employee';
      }

      return null; // no redirect needed
    },

    // Re-evaluate redirect whenever auth state changes.
    refreshListenable: GoRouterRefreshStream(authBloc.stream),

    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/hrd',
        builder: (context, state) => const HrdShellPage(),
      ),
      GoRoute(
        path: '/employee',
        builder: (context, state) => const EmployeeShellPage(),
      ),
      GoRoute(
        path: '/employee-detail/:id',
        builder: (context, state) => const EmployeeDetailPage(),
      ),
    ],
  );
}

/// Converts a [Stream] into a [Listenable] so GoRouter can react to BLoC state changes.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream stream) {
    stream.listen((_) => notifyListeners());
  }
}
