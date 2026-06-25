import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talentintel_ai/features/auth/data/models/user_model.dart';
import 'package:talentintel_ai/features/auth/domain/entities/user.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSource({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<UserModel> login({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw Exception('Login failed: User not found.');
      }

      // Fetch user profile from Firestore: check 'users' first, then 'employees'
      var doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
      Map<String, dynamic>? data;
      
      if (doc.exists) {
        data = doc.data();
      } else {
        final qs = await _firestore.collection('employees').where('uid', isEqualTo: firebaseUser.uid).limit(1).get();
        if (qs.docs.isNotEmpty) {
          data = qs.docs.first.data();
        }
      }
      
      if (data == null) {
        // Fallback if document doesn't exist (e.g., manually created user without profile)
        return UserModel(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? 'Unknown User',
          email: firebaseUser.email ?? email,
          role: role, // Default to requested role
          department: 'Unknown Department',
          employeeId: 'TEMP-${firebaseUser.uid.substring(0, 5)}',
        );
      }

      final userRoleStr = data['role'] as String? ?? '';
      
      // Map string from Firestore to enum
      UserRole userRole = UserRole.employee;
      if (userRoleStr.toLowerCase() == 'hrd') {
        userRole = UserRole.hrd;
      }

      // Check if trying to login with correct role
      if (userRole != role) {
        // Optionally sign them out immediately
        await _firebaseAuth.signOut();
        throw Exception('Access denied. Invalid role for this user.');
      }

      return UserModel(
        id: firebaseUser.uid,
        name: data['name'] as String? ?? 'Unknown User',
        email: firebaseUser.email ?? email,
        role: userRole,
        department: data['department'] as String? ?? 'Unknown Department',
        employeeId: data['employee_id'] as String? ?? 'EMP-${firebaseUser.uid.substring(0, 5)}',
        avatarUrl: data['avatarUrl'] as String?,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      }
      throw Exception(e.message ?? 'An unknown error occurred.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Failed to send password reset email.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Firebase handles verification via deep link from email in reality,
  // but for keeping our UI intact, we will just simulate success if code is 1234
  // since Firebase doesn't support manual OTP code verification for email.
  Future<bool> verifyOtp({required String email, required String otp}) async {
    await Future.delayed(const Duration(seconds: 1));
    return otp == '1234';
  }

  // Firebase password reset is handled via the link sent to email,
  // so this UI flow is mostly a simulation or requires a custom backend.
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    // In a real scenario, the user clicks a link and resets password there,
    // or you use a custom Firebase Admin SDK backend to change it.
  }

  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;

    try {
      var doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
      Map<String, dynamic>? data;
      
      if (doc.exists) {
        data = doc.data();
      } else {
        final qs = await _firestore.collection('employees').where('uid', isEqualTo: firebaseUser.uid).limit(1).get();
        if (qs.docs.isNotEmpty) {
          data = qs.docs.first.data();
        }
      }
      
      if (data == null) return null;

      final userRoleStr = data['role'] as String? ?? '';
      UserRole userRole = userRoleStr.toLowerCase() == 'hrd' ? UserRole.hrd : UserRole.employee;

      return UserModel(
        id: firebaseUser.uid,
        name: data['name'] as String? ?? 'Unknown User',
        email: firebaseUser.email ?? '',
        role: userRole,
        department: data['department'] as String? ?? 'Unknown Department',
        employeeId: data['employee_id'] as String? ?? 'EMP-${firebaseUser.uid.substring(0, 5)}',
        avatarUrl: data['avatarUrl'] as String?,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
