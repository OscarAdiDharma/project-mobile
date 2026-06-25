import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentintel_ai/features/auth/domain/entities/user.dart';
import 'package:talentintel_ai/features/auth/domain/usecases/login_usecase.dart';
import 'package:talentintel_ai/features/auth/domain/usecases/forgot_password_usecase.dart';

// ═══════════════════════════════════════════════════════════════
// Events
// ═══════════════════════════════════════════════════════════════

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Fired when the user taps the Login button.
class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  final UserRole role;

  const LoginRequested({
    required this.email,
    required this.password,
    required this.role,
  });

  @override
  List<Object?> get props => [email, password, role];
}

/// Fired when the user requests a password reset OTP.
class ForgotPasswordRequested extends AuthEvent {
  final String email;

  const ForgotPasswordRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

/// Fired when the user submits the OTP code.
class VerifyOtpRequested extends AuthEvent {
  final String email;
  final String otp;

  const VerifyOtpRequested({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];
}

/// Fired when the user submits a new password.
class ResetPasswordRequested extends AuthEvent {
  final String email;
  final String newPassword;

  const ResetPasswordRequested({
    required this.email,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [email, newPassword];
}

/// Fired when the user taps Logout.
class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

/// Fired on app startup to check for an existing session.
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Fired when the user's profile is updated locally.
class AuthUserUpdated extends AuthEvent {
  final User updatedUser;
  const AuthUserUpdated(this.updatedUser);

  @override
  List<Object?> get props => [updatedUser];
}

// ═══════════════════════════════════════════════════════════════
// States
// ═══════════════════════════════════════════════════════════════

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

/// OTP has been sent to the user's email.
class AuthOtpSent extends AuthState {
  final String email;

  const AuthOtpSent(this.email);

  @override
  List<Object?> get props => [email];
}

/// OTP has been verified successfully.
class AuthOtpVerified extends AuthState {
  final String email;

  const AuthOtpVerified(this.email);

  @override
  List<Object?> get props => [email];
}

/// Password has been reset successfully.
class AuthPasswordReset extends AuthState {
  const AuthPasswordReset();
}

// ═══════════════════════════════════════════════════════════════
// BLoC
// ═══════════════════════════════════════════════════════════════

/// Manages authentication state across the entire app.
///
/// Listens for [LoginRequested],
/// [ForgotPasswordRequested], [VerifyOtpRequested],
/// [ResetPasswordRequested], [LogoutRequested], and
/// [AuthCheckRequested] events and emits the corresponding state.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
  })  : _loginUseCase = loginUseCase,
        _forgotPasswordUseCase = forgotPasswordUseCase,
        super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthUserUpdated>(_onAuthUserUpdated);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _loginUseCase(
        email: event.email,
        password: event.password,
        role: event.role,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _forgotPasswordUseCase.sendOtp(email: event.email);
      emit(AuthOtpSent(event.email));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onVerifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final isValid = await _forgotPasswordUseCase.verifyOtp(
        email: event.email,
        otp: event.otp,
      );
      if (isValid) {
        emit(AuthOtpVerified(event.email));
      } else {
        emit(const AuthError('Invalid verification code. Try 1234.'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _forgotPasswordUseCase.resetPassword(
        email: event.email,
        newPassword: event.newPassword,
      );
      emit(const AuthPasswordReset());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthInitial());
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    // On app start, check if there's a cached session.
    // For now, always start at login.
    emit(const AuthInitial());
  }

  Future<void> _onAuthUserUpdated(
    AuthUserUpdated event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthAuthenticated) {
      emit(AuthAuthenticated(event.updatedUser));
    }
  }
}
