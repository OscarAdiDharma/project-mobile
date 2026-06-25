import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:talentintel_ai/core/constants/app_colors.dart';
import 'package:talentintel_ai/core/constants/app_strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentintel_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:talentintel_ai/features/auth/domain/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

/// Edit Profile page.
///
/// Editable fields: Name, Email, Department, Phone.
/// Avatar change (mock). Save button with snackbar feedback.
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  String? _selectedDepartment;
  String? _avatarUrl;
  bool _isLoading = false;

  final List<String> _departments = [
    'Technology',
    'Human Resources',
    'Marketing',
    'Finance',
    'Operations',
    'Product'
  ];

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      final user = authState.user;
      _nameController = TextEditingController(text: user.name);
      _emailController = TextEditingController(text: user.email);
      _phoneController = TextEditingController(text: '081234567890'); // mock
      
      _selectedDepartment = user.department;
      // Prevent dropdown crash by ensuring the current department exists in the list
      if (_selectedDepartment != null && !_departments.contains(_selectedDepartment)) {
        _departments.add(_selectedDepartment!);
      }
      
      _avatarUrl = user.avatarUrl;
    } else {
      _nameController = TextEditingController();
      _emailController = TextEditingController();
      _phoneController = TextEditingController();
      _selectedDepartment = _departments.first;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';
      setState(() {
        _avatarUrl = base64Image;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return;

    setState(() => _isLoading = true);
    try {
      final user = authState.user;
      await FirebaseFirestore.instance
          .collection('employees')
          .doc(user.employeeId)
          .update({
        'name': _nameController.text.trim(),
        'department': _selectedDepartment,
        'avatarUrl': _avatarUrl,
      });

      // Dispatch event to update the local AuthBloc state
      final updatedUser = User(
        id: user.id,
        name: _nameController.text.trim(),
        email: user.email,
        role: user.role,
        department: _selectedDepartment ?? user.department,
        employeeId: user.employeeId,
        avatarUrl: _avatarUrl,
      );
      if (mounted) {
        context.read<AuthBloc>().add(AuthUserUpdated(updatedUser));
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.profileUpdated),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.editProfile),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Avatar ──
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
                  backgroundImage: (_avatarUrl != null && _avatarUrl!.startsWith('data:image'))
                      ? MemoryImage(base64Decode(_avatarUrl!.split(',').last))
                      : null,
                  child: (_avatarUrl == null || !_avatarUrl!.startsWith('data:image'))
                      ? const Icon(Icons.person_rounded, size: 50, color: AppColors.primaryBlue)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: AppColors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // ── Form Fields ──
          _buildLabel(AppStrings.fullName),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 16),

          _buildLabel(AppStrings.email),
          const SizedBox(height: 8),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 16),

          _buildLabel(AppStrings.phoneNumber),
          const SizedBox(height: 8),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.phone_outlined),
            ),
          ),
          const SizedBox(height: 16),

          _buildLabel(AppStrings.department),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _selectedDepartment,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.business_outlined),
            ),
            items: _departments
                .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                .toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() => _selectedDepartment = val);
              }
            },
          ),
          const SizedBox(height: 32),

          // ── Save Button ──
          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _onSave,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: AppColors.white, strokeWidth: 2))
                  : const Icon(Icons.check_circle_outline),
              label: Text(
                  _isLoading ? 'Saving...' : AppStrings.saveChanges),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: Theme.of(context).textTheme.titleMedium);
  }
}
