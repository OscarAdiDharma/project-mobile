import 'package:talentintel_ai/features/auth/domain/entities/user.dart';

/// Data-layer model that knows how to serialize/deserialize.
///
/// Maps to the domain [User] entity. When you connect a real backend,
/// update [fromJson] to match the API response shape.
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    required super.department,
    required super.employeeId,
    super.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] == 'hrd' ? UserRole.hrd : UserRole.employee,
      department: json['department'] as String,
      employeeId: json['employee_id'] as String,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role == UserRole.hrd ? 'hrd' : 'employee',
      'department': department,
      'employee_id': employeeId,
      'avatar_url': avatarUrl,
    };
  }
}
