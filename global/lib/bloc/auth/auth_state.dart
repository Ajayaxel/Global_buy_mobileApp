import 'package:equatable/equatable.dart';
import 'package:global/models/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User? user;
  final String message;

  const AuthSuccess(this.user, this.message);

  @override
  List<Object?> get props => [user, message];
}

class AuthAuthenticated extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class ForgotPasswordLoading extends AuthState {}

class ForgotPasswordSuccess extends AuthState {
  final String message;

  const ForgotPasswordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class OtpVerificationLoading extends AuthState {}

class OtpVerificationSuccess extends AuthState {
  final String message;
  final User? user;

  const OtpVerificationSuccess(this.message, {this.user});

  @override
  List<Object?> get props => [message, user];
}

class ResendOtpLoading extends AuthState {}

class ResendOtpSuccess extends AuthState {
  final String message;

  const ResendOtpSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class LogoutLoading extends AuthState {}

class LogoutSuccess extends AuthState {
  final String message;

  const LogoutSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
