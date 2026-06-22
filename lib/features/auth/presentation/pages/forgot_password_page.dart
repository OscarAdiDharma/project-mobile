import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talentintel_ai/core/constants/app_colors.dart';
import 'package:talentintel_ai/core/constants/app_strings.dart';
import 'package:talentintel_ai/features/auth/presentation/bloc/auth_bloc.dart';

/// Forgot Password page — user enters email to receive OTP.
///
/// On success, navigates to OTP verification page.
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();

  late final AnimationController _animController;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onSendOtp() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.emailRequired)),
      );
      return;
    }

    context.read<AuthBloc>().add(ForgotPasswordRequested(email: email));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthOtpSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(AppStrings.otpSentSuccess),
                backgroundColor: AppColors.success,
              ),
            );
            context.go('/otp-verification?email=${state.email}');
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
                child: SlideTransition(
                  position: _slideUp,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ── Icon ──
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.lightBlue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.lock_reset_rounded,
                          color: AppColors.primaryBlue,
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
                                AppStrings.forgotPasswordTitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                AppStrings.forgotPasswordSubtitle,
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 28),

                              // Email Field
                              Text(
                                AppStrings.email,
                                style:
                                    Theme.of(context).textTheme.titleMedium,
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
                              const SizedBox(height: 24),

                              // Send Button
                              BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, state) {
                                  final isLoading = state is AuthLoading;
                                  return SizedBox(
                                    height: 50,
                                    child: ElevatedButton.icon(
                                      onPressed:
                                          isLoading ? null : _onSendOtp,
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
                                          : const Icon(Icons.send_rounded),
                                      label: Text(isLoading
                                          ? ''
                                          : AppStrings
                                              .sendVerificationCode),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Back to Login ──
                      TextButton.icon(
                        onPressed: () => context.go('/login'),
                        icon: const Icon(Icons.arrow_back_rounded, size: 18),
                        label: const Text(AppStrings.backToLogin),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
