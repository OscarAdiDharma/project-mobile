import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talentintel_ai/core/constants/app_colors.dart';
import 'package:talentintel_ai/core/constants/app_strings.dart';

/// Page for HRD to create new employee accounts.
///
/// Creates the user in Firebase Auth and saves their profile to Firestore.
class CreateEmployeePage extends StatefulWidget {
  const CreateEmployeePage({super.key});

  @override
  State<CreateEmployeePage> createState() => _CreateEmployeePageState();
}

class _CreateEmployeePageState extends State<CreateEmployeePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _employeeIdController = TextEditingController();
  String? _selectedDepartment;
  bool _isLoading = false;
  bool _obscurePassword = true;

  static const _departments = [
    'Human Resources',
    'Information Technology',
    'Finance',
    'Marketing',
    'Operations',
    'Research & Development',
    'Sales',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _employeeIdController.dispose();
    super.dispose();
  }

  Future<void> _createEmployee() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final employeeId = _employeeIdController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        employeeId.isEmpty ||
        _selectedDepartment == null) {
      _showSnackBar('Please complete all fields', isError: true);
      return;
    }

    if (password.length < 6) {
      _showSnackBar('Password must be at least 6 characters', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Save the current HRD user credentials before creating the new account
      final currentUser = FirebaseAuth.instance.currentUser;
      final currentEmail = currentUser?.email;

      // Use Firebase Auth REST API approach:
      // We create a secondary FirebaseApp to create the user without signing out
      // the current HRD user.
      // Alternative simpler approach: create user, store data, then re-login as HRD.

      // Create the employee user
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final newUserId = credential.user!.uid;

      // Save profile to Firestore
      await FirebaseFirestore.instance.collection('users').doc(newUserId).set({
        'name': name,
        'email': email,
        'role': 'employee',
        'department': _selectedDepartment,
        'employee_id': employeeId,
        'created_at': FieldValue.serverTimestamp(),
        'created_by': currentEmail ?? 'HRD Admin',
      });

      // Sign out the newly created user (it auto-signed-in)
      await FirebaseAuth.instance.signOut();

      if (mounted) {
        // Show success dialog
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle_rounded,
                      color: AppColors.success, size: 48),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Employee Account Created!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Account for $name ($email) has been created successfully.\n\n'
                  'The employee can now login with their email and the temporary password you set.\n\n'
                  'Please login again to continue as HRD admin.',
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        );

        // Clear form
        _nameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _employeeIdController.clear();
        setState(() {
          _selectedDepartment = null;
        });
      }
    } on FirebaseAuthException catch (e) {
      String msg = 'Failed to create account.';
      if (e.code == 'email-already-in-use') {
        msg = 'This email is already registered.';
      } else if (e.code == 'weak-password') {
        msg = 'The password is too weak.';
      } else if (e.code == 'invalid-email') {
        msg = 'The email address is invalid.';
      }
      _showSnackBar(msg, isError: true);
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Header ──
        Text(
          'Create Employee Account',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          'Add a new employee to the system',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),

        // ── Info Card ──
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.lightBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline_rounded,
                  color: AppColors.primaryBlue, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'The employee will receive login credentials via their email. '
                  'They can change their password after first login.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primaryBlue.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // ── Form ──
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Employee ID
                _buildLabel('Employee ID'),
                const SizedBox(height: 8),
                TextField(
                  controller: _employeeIdController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. EMP-001',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                ),
                const SizedBox(height: 16),

                // Full Name
                _buildLabel(AppStrings.fullName),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: 'John Doe',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 16),

                // Email
                _buildLabel(AppStrings.email),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'employee@company.com',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 16),

                // Department
                _buildLabel(AppStrings.department),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _selectedDepartment,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.business_outlined),
                  ),
                  hint: const Text(AppStrings.selectDepartment),
                  items: _departments
                      .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                      .toList(),
                  onChanged: (val) =>
                      setState(() => _selectedDepartment = val),
                ),
                const SizedBox(height: 16),

                // Temporary Password
                _buildLabel('Temporary Password'),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Min 6 characters',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Create Button
                SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _createEmployee,
                    icon: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : const Icon(Icons.person_add_rounded),
                    label: Text(
                        _isLoading ? 'Creating...' : 'Create Employee Account'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: Theme.of(context).textTheme.titleMedium);
  }
}
