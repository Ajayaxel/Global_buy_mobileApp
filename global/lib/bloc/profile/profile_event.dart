import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class FetchProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String fullName;
  final String companyName;
  final String email;
  final String phone;
  final String? address;
  final String? address2;
  final String? avatarPath;

  const UpdateProfile({
    required this.fullName,
    required this.companyName,
    required this.email,
    required this.phone,
    this.address,
    this.address2,
    this.avatarPath,
  });

  @override
  List<Object?> get props => [
    fullName,
    companyName,
    email,
    phone,
    address,
    address2,
    avatarPath,
  ];
}
