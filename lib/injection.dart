import 'package:get_it/get_it.dart';
import 'package:talentintel_ai/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:talentintel_ai/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:talentintel_ai/features/auth/domain/repositories/auth_repository.dart';
import 'package:talentintel_ai/features/auth/domain/usecases/login_usecase.dart';
import 'package:talentintel_ai/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:talentintel_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:talentintel_ai/features/hrd_dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:talentintel_ai/features/hrd_dashboard/domain/repositories/dashboard_repository.dart';
import 'package:talentintel_ai/features/hrd_dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:talentintel_ai/features/employee_dashboard/data/repositories/performance_repository_impl.dart';
import 'package:talentintel_ai/features/employee_dashboard/domain/repositories/performance_repository.dart';
import 'package:talentintel_ai/features/employee_dashboard/presentation/bloc/performance_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:talentintel_ai/features/ml_evaluation/data/datasources/ml_remote_datasource.dart';
import 'package:talentintel_ai/features/ml_evaluation/data/repositories/ml_repository_impl.dart';
import 'package:talentintel_ai/features/ml_evaluation/domain/repositories/ml_repository.dart';
import 'package:talentintel_ai/features/ml_evaluation/presentation/bloc/ml_evaluation_bloc.dart';

/// Global service locator.
///
/// Registration order: data sources → repositories → use cases → blocs.
/// All registrations are in one place for easy discoverability.
final sl = GetIt.instance;

void initDependencies() {
  // ── Auth ──────────────────────────────────────────────────
  sl.registerLazySingleton(() => AuthRemoteDataSource());

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );

  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl<AuthRepository>()));

  // AuthBloc is a factory — each creation gets a fresh instance.
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl<LoginUseCase>(),
      forgotPasswordUseCase: sl<ForgotPasswordUseCase>(),
    ),
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

  // ── ML Evaluation ────────────────────────────────────────
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => MlRemoteDataSource(client: sl<http.Client>()));
  sl.registerLazySingleton<MlRepository>(
    () => MlRepositoryImpl(remoteDataSource: sl<MlRemoteDataSource>()),
  );
  sl.registerFactory(
    () => MlEvaluationBloc(repository: sl<MlRepository>()),
  );
}
