class Negotiation {
  final int id;
  final int cartId;
  final int buyerId;
  final String originalPrice;
  final String negotiationPrice;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Negotiation({
    required this.id,
    required this.cartId,
    required this.buyerId,
    required this.originalPrice,
    required this.negotiationPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Negotiation.fromJson(Map<String, dynamic> json) {
    return Negotiation(
      id: json['id'],
      cartId: json['cart_id'],
      buyerId: json['buyer_id'],
      originalPrice: json['original_price'].toString(),
      negotiationPrice: json['negotiation_price'].toString(),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cart_id': cartId,
      'buyer_id': buyerId,
      'original_price': originalPrice,
      'negotiation_price': negotiationPrice,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class NegotiationResponse {
  final bool status;
  final String message;
  final Negotiation negotiation;

  NegotiationResponse({
    required this.status,
    required this.message,
    required this.negotiation,
  });

  factory NegotiationResponse.fromJson(Map<String, dynamic> json) {
    return NegotiationResponse(
      status: json['status'],
      message: json['message'],
      negotiation: Negotiation.fromJson(json['negotiation']),
    );
  }
}
