import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talentintel_ai/core/constants/app_colors.dart';
import 'package:talentintel_ai/core/constants/app_strings.dart';
import 'package:talentintel_ai/features/auth/presentation/bloc/auth_bloc.dart';

/// OTP Verification page with 4-digit code input and countdown timer.
///
/// Receives email via query parameter. Auto-focuses next field.
/// Demo OTP code is always 1234.
class OtpVerificationPage extends StatefulWidget {
  final String email;

  const OtpVerificationPage({super.key, required this.email});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  late final AnimationController _animController;
  late final Animation<double> _fadeIn;

  Timer? _timer;
  int _countdown = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
    _startTimer();
  }

  void _startTimer() {
    _countdown = 60;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _animController.dispose();
    super.dispose();
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    // Auto-submit when all 4 digits entered
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length == 4) {
      _onVerify();
    }
  }

  void _onVerify() {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the 4-digit code')),
      );
      return;
    }

    context.read<AuthBloc>().add(
          VerifyOtpRequested(email: widget.email, otp: otp),
        );
  }

  void _onResend() {
    if (!_canResend) return;
    // Clear fields
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus();
    _startTimer();

    context.read<AuthBloc>().add(
          ForgotPasswordRequested(email: widget.email),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthOtpVerified) {
            context.go('/reset-password?email=${state.email}');
          } else if (state is AuthOtpSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(AppStrings.otpSentSuccess),
                backgroundColor: AppColors.success,
              ),
            );
          } else if (state is AuthError) {
            // Clear OTP fields on error
            for (final c in _controllers) {
              c.clear();
            }
            _focusNodes[0].requestFocus();

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
                        color: AppColors.lightBlue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.verified_user_rounded,
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
                              AppStrings.otpVerification,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppStrings.otpSubtitle,
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.email,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: AppColors.primaryBlue,
                                    fontWeight: FontWeight.w600,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            // Demo hint
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.warningLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                '💡 Demo: Use code 1234',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFE65100),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 28),

                            // OTP Input Fields
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                              children: List.generate(
                                4,
                                (index) => SizedBox(
                                  width: 56,
                                  height: 64,
                                  child: TextField(
                                    controller: _controllers[index],
                                    focusNode: _focusNodes[index],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    maxLength: 1,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: InputDecoration(
                                      counterText: '',
                                      filled: true,
                                      fillColor: AppColors.background,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            color: AppColors.divider),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: AppColors.primaryBlue,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    onChanged: (value) =>
                                        _onOtpChanged(index, value),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Verify Button
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                final isLoading = state is AuthLoading;
                                return SizedBox(
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed:
                                        isLoading ? null : _onVerify,
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child:
                                                CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: AppColors.white,
                                            ),
                                          )
                                        : const Text(
                                            AppStrings.verifyCode),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),

                            // Resend / Timer
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _canResend
                                      ? AppStrings.didntReceiveCode
                                      : '${AppStrings.resendCodeIn}${_countdown}s',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall,
                                ),
                                if (_canResend)
                                  GestureDetector(
                                    onTap: _onResend,
                                    child: const Text(
                                      AppStrings.resendCode,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryBlue,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Back to Login
                    TextButton.icon(
                      onPressed: () => context.go('/login'),
                      icon:
                          const Icon(Icons.arrow_back_rounded, size: 18),
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
    );
  }
}
