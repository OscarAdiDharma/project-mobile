import 'package:get_it/get_it.dart';
import 'package:talentintel_ai/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:talentintel_ai/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:talentintel_ai/features/auth/domain/repositories/auth_repository.dart';
import 'package:talentintel_ai/features/auth/domain/usecases/login_usecase.dart';
import 'package:talentintel_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:talentintel_ai/features/hrd_dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:talentintel_ai/features/hrd_dashboard/domain/repositories/dashboard_repository.dart';
import 'package:talentintel_ai/features/hrd_dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:talentintel_ai/features/employee_dashboard/data/repositories/performance_repository_impl.dart';
import 'package:talentintel_ai/features/employee_dashboard/domain/repositories/performance_repository.dart';
import 'package:talentintel_ai/features/employee_dashboard/presentation/bloc/performance_bloc.dart';

/// Global service locator.
///
/// Registration order: data sources → repositories → use cases → blocs.
/// All registrations are in one place for easy discoverability.
final sl = GetIt.instance;

void initDependencies() {
  // ── Auth ──────────────────────────────────────────────────
  sl.registerLazySingleton(() => AuthLocalDataSource());

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthLocalDataSource>()),
  );

  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));

  // AuthBloc is a factory — each creation gets a fresh instance.
  sl.registerFactory(
    () => AuthBloc(loginUseCase: sl<LoginUseCase>()),
  );

  // ── HRD Dashboard ────────────────────────────────────────
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(),
  );

  sl.registerFactory(
    () => DashboardBloc(repository: sl<DashboardRepository>()),
  );

  // ── Employee Dashboard ───────────────────────────────────
  sl.registerLazySingleton<PerformanceRepository>(
    () => PerformanceRepositoryImpl(),
  );

  sl.registerFactory(
    () => PerformanceBloc(repository: sl<PerformanceRepository>()),
  );
}
