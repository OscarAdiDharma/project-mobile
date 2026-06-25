import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talentintel_ai/features/auth/domain/entities/user.dart';
import 'package:talentintel_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:talentintel_ai/features/auth/presentation/pages/login_page.dart';
import 'package:talentintel_ai/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:talentintel_ai/features/auth/presentation/pages/otp_verification_page.dart';
import 'package:talentintel_ai/features/auth/presentation/pages/reset_password_page.dart';
import 'package:talentintel_ai/features/hrd_dashboard/presentation/pages/hrd_shell_page.dart';
import 'package:talentintel_ai/features/employee_dashboard/presentation/pages/employee_shell_page.dart';
import 'package:talentintel_ai/features/employee_analysis/presentation/pages/employee_detail_page.dart';
import 'package:talentintel_ai/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:talentintel_ai/features/profile/presentation/pages/security_page.dart';
import 'package:talentintel_ai/features/profile/presentation/pages/help_page.dart';

/// App-wide router configuration.
///
/// Uses GoRouter's `redirect` to guard routes based on auth state.
/// - Not authenticated → /login (or other auth pages)
/// - Authenticated as HRD → /hrd
/// - Authenticated as Employee → /employee
class AppRouter {
  final AuthBloc authBloc;

  AppRouter({required this.authBloc});

  /// Auth-related paths that don't require login.
  static const _authPaths = [
    '/login',
    '/forgot-password',
    '/otp-verification',
    '/reset-password',
  ];

  late final GoRouter router = GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,

    // Redirect based on authentication state.
    redirect: (context, state) {
      final authState = authBloc.state;
      final currentPath = state.matchedLocation;
      final isOnAuthPage = _authPaths.any((p) => currentPath.startsWith(p));

      // Not logged in → allow auth pages, redirect others to login.
      if (authState is! AuthAuthenticated) {
        return isOnAuthPage ? null : '/login';
      }

      // Logged in but still on an auth page → redirect to the right portal.
      if (isOnAuthPage) {
        return authState.user.role == UserRole.hrd ? '/hrd' : '/employee';
      }

      return null; // no redirect needed
    },

    // Re-evaluate redirect whenever auth state changes.
    refreshListenable: GoRouterRefreshStream(authBloc.stream),

    routes: [
      // ── Auth routes ──
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/otp-verification',
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return OtpVerificationPage(email: email);
        },
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return ResetPasswordPage(email: email);
        },
      ),

      // ── Main app routes ──
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
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return EmployeeDetailPage(employeeId: id);
        },
      ),

      // ── Profile sub-pages (pushed via Navigator.push) ──
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: '/security',
        builder: (context, state) => const SecurityPage(),
      ),
      GoRoute(
        path: '/help',
        builder: (context, state) => const HelpPage(),
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
