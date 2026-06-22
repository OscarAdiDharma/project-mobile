import 'package:talentintel_ai/features/auth/domain/repositories/auth_repository.dart';

/// Encapsulates the forgot-password business rule.
class ForgotPasswordUseCase {
  final AuthRepository _repository;

  const ForgotPasswordUseCase(this._repository);

  Future<void> sendOtp({required String email}) {
    return _repository.forgotPassword(email: email);
  }

  Future<bool> verifyOtp({required String email, required String otp}) {
    return _repository.verifyOtp(email: email, otp: otp);
  }

  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) {
    return _repository.resetPassword(email: email, newPassword: newPassword);
  }
}
