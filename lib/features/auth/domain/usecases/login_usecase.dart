import 'package:talentintel_ai/features/auth/domain/entities/user.dart';
import 'package:talentintel_ai/features/auth/domain/repositories/auth_repository.dart';

/// Encapsulates the login business rule.
///
/// Right now this is a thin pass-through, but it's where you'd add
/// validation, rate limiting, analytics, etc. without touching the UI.
class LoginUseCase {
  final AuthRepository _repository;

  const LoginUseCase(this._repository);

  Future<User> call({
    required String email,
    required String password,
    required UserRole role,
  }) {
    return _repository.login(email: email, password: password, role: role);
  }
}
