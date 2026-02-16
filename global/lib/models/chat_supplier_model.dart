class ChatSupplier {
  final int id;
  final String companyName;
  final String? businessCategory;
  final String? businessEmail;
  final String? phone;
  final String? cityRegion;
  final String? status;
  final int unreadCount;
  final String? lastMessage;
  final String? lastMessageTime;

  ChatSupplier({
    required this.id,
    required this.companyName,
    this.businessCategory,
    this.businessEmail,
    this.phone,
    this.cityRegion,
    this.status,
    required this.unreadCount,
    this.lastMessage,
    this.lastMessageTime,
  });

  factory ChatSupplier.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return ChatSupplier(
      id: parseInt(json['id']),
      companyName: json['company_name'] ?? '',
      businessCategory: json['business_category'],
      businessEmail: json['business_email'],
      phone: json['phone'],
      cityRegion: json['city_region'],
      status: json['status'],
      unreadCount: parseInt(json['unread_count']),
      lastMessage: json['last_message'],
      lastMessageTime: json['last_message_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_name': companyName,
      'business_category': businessCategory,
      'business_email': businessEmail,
      'phone': phone,
      'city_region': cityRegion,
      'status': status,
      'unread_count': unreadCount,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime,
    };
  }
}

class ChatListResponse {
  final bool status;
  final List<ChatSupplier> suppliers;

  ChatListResponse({required this.status, required this.suppliers});

  factory ChatListResponse.fromJson(Map<String, dynamic> json) {
    return ChatListResponse(
      status: json['status'],
      suppliers: (json['suppliers'] as List)
          .map((s) => ChatSupplier.fromJson(s))
          .toList(),
    );
  }
}
