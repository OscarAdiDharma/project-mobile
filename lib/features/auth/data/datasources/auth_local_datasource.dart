import 'package:talentintel_ai/features/auth/data/models/user_model.dart';
import 'package:talentintel_ai/features/auth/domain/entities/user.dart';

/// Mock data source that simulates a backend.
///
/// Replace this with a real API call or Firebase Auth later.
/// The repository doesn't care — it only knows the interface.
class AuthLocalDataSource {
  /// Hardcoded users for demo purposes.
  static final _mockUsers = <String, UserModel>{
    'admin@talentintel.com': const UserModel(
      id: 'usr-001',
      name: 'Sarah Anderson',
      email: 'admin@talentintel.com',
      role: UserRole.hrd,
      department: 'Human Resources',
      employeeId: 'HRD-0001',
    ),
    'budi@talentintel.com': const UserModel(
      id: 'usr-002',
      name: 'Budi Santoso',
      email: 'budi@talentintel.com',
      role: UserRole.employee,
      department: 'Information Technology',
      employeeId: 'EMP-0824',
    ),
  };

  UserModel? _currentUser;

  Future<UserModel> login({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final user = _mockUsers[email.toLowerCase()];
    if (user == null) {
      throw Exception('User not found. Try admin@talentintel.com or budi@talentintel.com');
    }

    // For demo, any password works — just check the email exists.
    _currentUser = user;
    return user;
  }

  Future<UserModel?> getCurrentUser() async {
    return _currentUser;
  }

  Future<void> logout() async {
    _currentUser = null;
  }
}
