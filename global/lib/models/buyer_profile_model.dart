class BuyerProfileResponse {
  final bool status;
  final BuyerProfile buyer;

  BuyerProfileResponse({required this.status, required this.buyer});

  factory BuyerProfileResponse.fromJson(Map<String, dynamic> json) {
    return BuyerProfileResponse(
      status: json['status'],
      buyer: BuyerProfile.fromJson(json['buyer']),
    );
  }
}

class BuyerProfile {
  final int id;
  final String fullName;
  final String? companyName;
  final String email;
  final String phone;
  final String? address;
  final String? address2;
  final String? avatarUrl;

  BuyerProfile({
    required this.id,
    required this.fullName,
    this.companyName,
    required this.email,
    required this.phone,
    this.address,
    this.address2,
    this.avatarUrl,
  });

  factory BuyerProfile.fromJson(Map<String, dynamic> json) {
    return BuyerProfile(
      id: json['id'],
      fullName: json['full_name'],
      companyName: json['company_name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      address2: json['address_2'],
      avatarUrl: json['avatar_url'],
    );
  }
}
