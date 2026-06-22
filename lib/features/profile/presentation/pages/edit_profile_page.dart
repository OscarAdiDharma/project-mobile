import 'package:flutter/material.dart';
import 'package:talentintel_ai/core/constants/app_colors.dart';
import 'package:talentintel_ai/core/constants/app_strings.dart';

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
  final _nameController = TextEditingController(text: 'Budi Santoso');
  final _emailController =
      TextEditingController(text: 'budi@talentintel.com');
  final _phoneController = TextEditingController(text: '+62 812 3456 7890');
  String _selectedDepartment = 'Information Technology';

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
    _phoneController.dispose();
    super.dispose();
  }

  void _onSave() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppStrings.profileUpdated),
        backgroundColor: AppColors.success,
      ),
    );
    Navigator.of(context).pop();
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
                const CircleAvatar(
                  radius: 56,
                  backgroundColor: AppColors.lightBlue,
                  child: Icon(
                    Icons.person_rounded,
                    size: 56,
                    color: AppColors.primaryBlue,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Photo picker coming soon!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: AppColors.white,
                        size: 18,
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
              onPressed: _onSave,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text(AppStrings.saveChanges),
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
