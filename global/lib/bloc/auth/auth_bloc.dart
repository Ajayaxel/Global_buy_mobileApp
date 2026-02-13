import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global/bloc/auth/auth_event.dart';
import 'package:global/bloc/auth/auth_state.dart';
import 'package:global/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<RegisterRequested>(_onRegisterRequested);
    on<LoginRequested>(_onLoginRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
    on<ResendOtpRequested>(_onResendOtpRequested);
  }

  Future<void> _onResendOtpRequested(
    ResendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(ResendOtpLoading());
    try {
      final message = await authRepository.resendOtp(email: event.email);
      emit(ResendOtpSuccess(message));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onVerifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(OtpVerificationLoading());
    try {
      final response = await authRepository.verifyOtp(
        email: event.email,
        otp: event.otp,
      );
      emit(OtpVerificationSuccess(response['message'], user: response['user']));
      // After successful verification, we don't emit AuthAuthenticated here
      // because the user needs to upload documents first.
      // The navigation is handled in the UI listener of VerifyAccountScreen.
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(ForgotPasswordLoading());
    try {
      final message = await authRepository.forgotPassword(
        emailOrNumber: event.emailOrNumber,
      );
      emit(ForgotPasswordSuccess(message));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final (user, message) = await authRepository.register(
        fullName: event.fullName,
        companyName: event.companyName,
        email: event.email,
        phone: event.phone,
        password: event.password,
        address: event.address,
      );
      emit(AuthSuccess(user, message));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.login(
        email: event.email,
        password: event.password,
      );
      emit(AuthSuccess(user, "Login successful."));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final hasToken = await authRepository.hasToken();
    if (hasToken) {
      emit(AuthAuthenticated());
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await authRepository.logout();
    emit(AuthUnauthenticated());
  }
}
