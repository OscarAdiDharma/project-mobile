import 'package:talentintel_ai/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:talentintel_ai/features/auth/domain/entities/user.dart';
import 'package:talentintel_ai/features/auth/domain/repositories/auth_repository.dart';

/// Concrete implementation of [AuthRepository].
///
/// Currently delegates to [AuthLocalDataSource] (mock data).
/// When a real backend is ready, add a remote data source and
/// switch the delegation — no changes needed in domain or presentation.
class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource _localDataSource;

  const AuthRepositoryImpl(this._localDataSource);

  @override
  Future<User> login({
    required String email,
    required String password,
    required UserRole role,
  }) {
    return _localDataSource.login(
      email: email,
      password: password,
      role: role,
    );
  }

  @override
  Future<User?> getCurrentUser() {
    return _localDataSource.getCurrentUser();
  }

  @override
  Future<void> logout() {
    return _localDataSource.logout();
  }
}
