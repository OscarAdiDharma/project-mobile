import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talentintel_ai/core/constants/app_colors.dart';
import 'package:talentintel_ai/core/constants/app_strings.dart';
import 'package:talentintel_ai/features/auth/presentation/bloc/auth_bloc.dart';

/// Reset Password page — user sets a new password after OTP verification.
///
/// Includes password strength indicator and confirmation field.
class ResetPasswordPage extends StatefulWidget {
  final String email;

  const ResetPasswordPage({super.key, required this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage>
    with SingleTickerProviderStateMixin {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  late final AnimationController _animController;
  late final Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  /// Compute password strength: 0 = weak, 1 = medium, 2 = strong.
  int _passwordStrength(String password) {
    if (password.isEmpty) return 0;
    int score = 0;
    if (password.length >= 6) score++;
    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

    if (score <= 2) return 0; // weak
    if (score <= 3) return 1; // medium
    return 2; // strong
  }

  String _strengthLabel(int strength) {
    switch (strength) {
      case 0:
        return AppStrings.passwordStrengthWeak;
      case 1:
        return AppStrings.passwordStrengthMedium;
      case 2:
        return AppStrings.passwordStrengthStrong;
      default:
        return '';
    }
  }

  Color _strengthColor(int strength) {
    switch (strength) {
      case 0:
        return AppColors.error;
      case 1:
        return AppColors.warning;
      case 2:
        return AppColors.success;
      default:
        return AppColors.textHint;
    }
  }

  void _onResetPassword() {
    final newPw = _newPasswordController.text;
    final confirmPw = _confirmPasswordController.text;

    if (newPw.isEmpty || confirmPw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(AppStrings.pleaseCompleteAllFields)),
      );
      return;
    }

    if (newPw.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.passwordMinLength)),
      );
      return;
    }

    if (newPw != confirmPw) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.passwordsDoNotMatch)),
      );
      return;
    }

    context.read<AuthBloc>().add(
          ResetPasswordRequested(
            email: widget.email,
            newPassword: newPw,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthPasswordReset) {
            _showSuccessDialog();
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: FadeTransition(
                opacity: _fadeIn,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ── Icon ──
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.successLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.vpn_key_rounded,
                        color: AppColors.success,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Card ──
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              AppStrings.resetPassword,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppStrings.resetPasswordSubtitle,
                              style:
                                  Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 28),

                            // New Password
                            Text(
                              AppStrings.newPassword,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium,
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _newPasswordController,
                              obscureText: _obscureNew,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                hintText: '••••••••',
                                prefixIcon:
                                    const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureNew
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                  onPressed: () => setState(() =>
                                      _obscureNew = !_obscureNew),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Password Strength
                            if (_newPasswordController.text.isNotEmpty)
                              _buildStrengthIndicator(),

                            const SizedBox(height: 16),

                            // Confirm New Password
                            Text(
                              AppStrings.confirmNewPassword,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium,
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirm,
                              decoration: InputDecoration(
                                hintText: '••••••••',
                                prefixIcon:
                                    const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirm
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                  onPressed: () => setState(() =>
                                      _obscureConfirm =
                                          !_obscureConfirm),
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),

                            // Reset Button
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                final isLoading = state is AuthLoading;
                                return SizedBox(
                                  height: 50,
                                  child: ElevatedButton.icon(
                                    onPressed: isLoading
                                        ? null
                                        : _onResetPassword,
                                    icon: isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child:
                                                CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: AppColors.white,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.check_circle_outline),
                                    label: Text(isLoading
                                        ? ''
                                        : AppStrings.resetPasswordBtn),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStrengthIndicator() {
    final strength = _passwordStrength(_newPasswordController.text);
    final color = _strengthColor(strength);
    final label = _strengthLabel(strength);
    final progress = (strength + 1) / 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.divider,
            color: color,
            minHeight: 4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Password strength: $label',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Success!',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              AppStrings.passwordResetSuccess,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                context.go('/login');
              },
              child: const Text(AppStrings.backToLogin),
            ),
          ),
        ],
      ),
    );
  }
}
