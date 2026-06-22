import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talentintel_ai/core/constants/app_colors.dart';
import 'package:talentintel_ai/core/constants/app_strings.dart';
import 'package:talentintel_ai/features/auth/domain/entities/user.dart';
import 'package:talentintel_ai/features/auth/presentation/bloc/auth_bloc.dart';

/// The login screen matching the mockup design.
///
/// Layout:
/// - Top section: Logo + app name + tagline
/// - Role selector: two icon cards (HRD / Employee)
/// - Email & Password fields
/// - Remember me + Forgot password
/// - Login button
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  UserRole _selectedRole = UserRole.hrd;
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    context.read<AuthBloc>().add(
          LoginRequested(email: email, password: password, role: _selectedRole),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
          // Navigation is handled by GoRouter's redirect, not here.
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ── Logo & Title ────────────────────────────
                  _buildLogo(),
                  const SizedBox(height: 32),

                  // ── Login Card ──────────────────────────────
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
                            AppStrings.welcome,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppStrings.loginSubtitle,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),

                          // ── Role Selector ───────────────────
                          Text(
                            AppStrings.selectRole,
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          _buildRoleSelector(),
                          const SizedBox(height: 24),

                          // ── Email Field ─────────────────────
                          Text(
                            AppStrings.email,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: 'name@company.com',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // ── Password Field ──────────────────
                          Text(
                            AppStrings.password,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // ── Remember Me & Forgot ────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: Checkbox(
                                      value: _rememberMe,
                                      onChanged: (val) {
                                        setState(() {
                                          _rememberMe = val ?? false;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    AppStrings.rememberMe,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () => context.go('/forgot-password'),
                                child: const Text(
                                  AppStrings.forgotPassword,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // ── Login Button ────────────────────
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              final isLoading = state is AuthLoading;
                              return SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : _onLogin,
                                  child: isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.white,
                                          ),
                                        )
                                      : const Text(AppStrings.login),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Footer ──────────────────────────────────
                  Text(
                    '© 2024 AI Talent Intelligence System. Data Science Edition.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          color: AppColors.textHint,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// App logo and title at the top of the page.
  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.psychology_rounded,
            color: AppColors.white,
            size: 36,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          AppStrings.appName,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.primaryBlue,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          AppStrings.appTagline,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Two cards for HRD vs Employee role selection.
  Widget _buildRoleSelector() {
    return Row(
      children: [
        Expanded(
          child: _RoleCard(
            icon: Icons.admin_panel_settings_rounded,
            label: AppStrings.loginAsHrd,
            isSelected: _selectedRole == UserRole.hrd,
            onTap: () => setState(() => _selectedRole = UserRole.hrd),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _RoleCard(
            icon: Icons.person_rounded,
            label: AppStrings.loginAsEmployee,
            isSelected: _selectedRole == UserRole.employee,
            onTap: () => setState(() => _selectedRole = UserRole.employee),
          ),
        ),
      ],
    );
  }
}

/// A selectable card for choosing the login role.
class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryBlue.withValues(alpha: 0.08)
              : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? AppColors.primaryBlue : AppColors.textHint,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? AppColors.primaryBlue
                    : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
