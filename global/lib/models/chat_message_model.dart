class ChatMessage {
  final int id;
  final int buyerId;
  final int supplierId;
  final String message;
  final String senderType;
  final int isRead;
  final int isNegotiation;
  final String createdAt;
  final String updatedAt;

  ChatMessage({
    required this.id,
    required this.buyerId,
    required this.supplierId,
    required this.message,
    required this.senderType,
    required this.isRead,
    required this.isNegotiation,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isMe => senderType == 'buyer';

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    int parseId(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    int parseIntValue(dynamic value) {
      if (value is int) return value;
      if (value is bool) return value ? 1 : 0;
      if (value is String) {
        if (value.toLowerCase() == 'true') return 1;
        if (value.toLowerCase() == 'false') return 0;
        return int.tryParse(value) ?? 0;
      }
      return 0;
    }

    return ChatMessage(
      id: parseId(json['id']),
      buyerId: parseId(json['buyer_id']),
      supplierId: parseId(json['supplier_id']),
      message: json['message'] ?? '',
      senderType: json['sender_type'] ?? '',
      isRead: parseIntValue(json['is_read']),
      isNegotiation: parseIntValue(json['is_negotiation']),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyer_id': buyerId,
      'supplier_id': supplierId,
      'message': message,
      'sender_type': senderType,
      'is_read': isRead,
      'is_negotiation': isNegotiation,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class ChatMessagesResponse {
  final bool status;
  final List<ChatMessage> chats;

  ChatMessagesResponse({required this.status, required this.chats});

  factory ChatMessagesResponse.fromJson(Map<String, dynamic> json) {
    return ChatMessagesResponse(
      status: json['status'],
      chats: (json['chats'] as List)
          .map((c) => ChatMessage.fromJson(c))
          .toList(),
    );
  }
}
