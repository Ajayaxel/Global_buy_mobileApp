import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class RegisterRequested extends AuthEvent {
  final String fullName;
  final String companyName;
  final String email;
  final String phone;
  final String password;
  final String? address;

  const RegisterRequested({
    required this.fullName,
    required this.companyName,
    required this.email,
    required this.phone,
    required this.password,
    this.address,
  });

  @override
  List<Object?> get props => [
    fullName,
    companyName,
    email,
    phone,
    password,
    address,
  ];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthCheckRequested extends AuthEvent {}

class LogoutRequested extends AuthEvent {}

class ForgotPasswordRequested extends AuthEvent {
  final String emailOrNumber;

  const ForgotPasswordRequested({required this.emailOrNumber});

  @override
  List<Object?> get props => [emailOrNumber];
}
