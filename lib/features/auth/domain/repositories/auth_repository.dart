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

  /// Return the currently cached user, or null if not logged in.
  Future<User?> getCurrentUser();

  /// Clear session and sign out.
  Future<void> logout();
}
