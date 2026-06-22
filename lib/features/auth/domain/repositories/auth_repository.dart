import 'package:talentintel_ai/features/auth/domain/entities/user.dart';

/// Contract for authentication operations.
///
/// The data layer provides the actual implementation.
/// This lives in domain so the business logic never depends
/// on Firebase, REST, or any other specific data source.
abstract class AuthRepository {
  /// Attempt login. Returns [User] on success, throws on failure.
  Future<User> login({
    required String email,
    required String password,
    required UserRole role,
  });

  // Removed register method since it's handled by HRD externally.

  /// Send a password reset OTP to the given email.
  Future<void> forgotPassword({required String email});

  /// Verify the OTP code. Returns true if valid.
  Future<bool> verifyOtp({required String email, required String otp});

  /// Reset password after OTP verification.
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  });

  /// Return the currently cached user, or null if not logged in.
  Future<User?> getCurrentUser();

  /// Clear session and sign out.
  Future<void> logout();
}
