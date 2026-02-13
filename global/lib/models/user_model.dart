class User {
  final int id;
  final String fullName;
  final String? companyName;
  final String email;
  final String phone;
  final String? address;
  final String? otp;

  User({
    required this.id,
    required this.fullName,
    this.companyName,
    required this.email,
    required this.phone,
    this.address,
    this.otp,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['full_name'],
      companyName: json['company_name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      otp: json['otp']?.toString(),
    );
  }
}
