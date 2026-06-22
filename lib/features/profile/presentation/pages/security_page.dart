import 'package:flutter/material.dart';
import 'package:talentintel_ai/core/constants/app_colors.dart';
import 'package:talentintel_ai/core/constants/app_strings.dart';

/// Security page.
///
/// Change password form + Two-factor auth toggle + Login activity.
class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  final _currentPwController = TextEditingController();
  final _newPwController = TextEditingController();
  final _confirmPwController = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _twoFactorEnabled = false;

  @override
  void dispose() {
    _currentPwController.dispose();
    _newPwController.dispose();
    _confirmPwController.dispose();
    super.dispose();
  }

  void _onChangePassword() {
    final current = _currentPwController.text;
    final newPw = _newPwController.text;
    final confirm = _confirmPwController.text;

    if (current.isEmpty || newPw.isEmpty || confirm.isEmpty) {
      _showSnackBar(AppStrings.pleaseCompleteAllFields);
      return;
    }

    if (newPw.length < 6) {
      _showSnackBar(AppStrings.passwordMinLength);
      return;
    }

    if (newPw != confirm) {
      _showSnackBar(AppStrings.passwordsDoNotMatch);
      return;
    }

    _currentPwController.clear();
    _newPwController.clear();
    _confirmPwController.clear();

    _showSnackBar(AppStrings.passwordChanged, isSuccess: true);
  }

  void _showSnackBar(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? AppColors.success : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.security),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Change Password ──
          _sectionLabel(AppStrings.changePassword),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildPwField(
                    label: AppStrings.currentPassword,
                    controller: _currentPwController,
                    obscure: _obscureCurrent,
                    onToggle: () =>
                        setState(() => _obscureCurrent = !_obscureCurrent),
                  ),
                  const SizedBox(height: 16),
                  _buildPwField(
                    label: AppStrings.newPassword,
                    controller: _newPwController,
                    obscure: _obscureNew,
                    onToggle: () =>
                        setState(() => _obscureNew = !_obscureNew),
                  ),
                  const SizedBox(height: 16),
                  _buildPwField(
                    label: AppStrings.confirmNewPassword,
                    controller: _confirmPwController,
                    obscure: _obscureConfirm,
                    onToggle: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 46,
                    child: ElevatedButton(
                      onPressed: _onChangePassword,
                      child: const Text(AppStrings.changePassword),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ── Two-Factor Auth ──
          _sectionLabel(AppStrings.twoFactorAuth),
          const SizedBox(height: 12),
          Card(
            child: SwitchListTile(
              secondary: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.security_rounded,
                    color: AppColors.success, size: 20),
              ),
              title: const Text(AppStrings.twoFactorAuth),
              subtitle: const Text(AppStrings.twoFactorAuthDesc),
              value: _twoFactorEnabled,
              activeThumbColor: AppColors.primaryBlue,
              onChanged: (val) {
                setState(() => _twoFactorEnabled = val);
                _showSnackBar(
                  '2FA ${val ? 'enabled' : 'disabled'} (demo only)',
                  isSuccess: val,
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // ── Login Activity ──
          _sectionLabel(AppStrings.loginActivity),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                _loginEntry('Windows Desktop', 'Today, 15:00', true),
                const Divider(height: 1),
                _loginEntry('Android Phone', 'Yesterday, 09:30', false),
                const Divider(height: 1),
                _loginEntry('Chrome Browser', 'Jun 20, 14:22', false),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPwField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: '••••••••',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed: onToggle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _loginEntry(String device, String time, bool isCurrent) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isCurrent ? AppColors.successLight : AppColors.background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          isCurrent ? Icons.computer_rounded : Icons.phone_android_rounded,
          color: isCurrent ? AppColors.success : AppColors.textHint,
          size: 20,
        ),
      ),
      title: Text(device),
      subtitle: Text(time),
      trailing: isCurrent
          ? Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Current',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.success,
                ),
              ),
            )
          : null,
    );
  }
}
