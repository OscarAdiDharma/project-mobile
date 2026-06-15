import 'package:equatable/equatable.dart';

/// Represents a user in the system.
///
/// This is a domain entity — it has no dependency on any framework
/// or serialization library. The data layer maps API/DB responses
/// into this class via [UserModel].
class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String department;
  final String employeeId;
  final String? avatarUrl;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.department,
    required this.employeeId,
    this.avatarUrl,
  });

  @override
  List<Object?> get props =>
      [id, name, email, role, department, employeeId, avatarUrl];
}

enum UserRole { hrd, employee }
