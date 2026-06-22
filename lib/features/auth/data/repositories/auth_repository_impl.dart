import 'package:talentintel_ai/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:talentintel_ai/features/auth/domain/entities/user.dart';
import 'package:talentintel_ai/features/auth/domain/repositories/auth_repository.dart';

/// Concrete implementation of [AuthRepository].
///
/// Currently delegates to [AuthRemoteDataSource] (mock data).
/// When a real backend is ready, add a remote data source and
/// switch the delegation — no changes needed in domain or presentation.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<User> login({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    return _remoteDataSource.login(
      email: email,
      password: password,
      role: role,
    );
  }

  @override
  Future<void> forgotPassword({required String email}) {
    return _remoteDataSource.forgotPassword(email: email);
  }

  @override
  Future<bool> verifyOtp({required String email, required String otp}) {
    return _remoteDataSource.verifyOtp(email: email, otp: otp);
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) {
    return _remoteDataSource.resetPassword(
      email: email,
      newPassword: newPassword,
    );
  }

  @override
  Future<User?> getCurrentUser() {
    return _remoteDataSource.getCurrentUser();
  }

  @override
  Future<void> logout() {
    return _remoteDataSource.logout();
  }
}
