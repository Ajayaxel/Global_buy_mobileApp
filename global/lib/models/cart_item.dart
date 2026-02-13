class CartItem {
  final int id;
  final int productId;
  final String name;
  final String grade;
  final String origin;
  final String price;
  final String unit;
  final String image;
  int quantity;
  final int availableQuantity;
  final String status;
  final String shippingTerm;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.grade,
    required this.origin,
    required this.price,
    required this.unit,
    required this.image,
    required this.quantity,
    required this.availableQuantity,
    this.status = 'QA Pending',
    this.shippingTerm = 'CIF',
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final product = json['product'] ?? {};
    final images = product['images'] as List?;
    String imageUrl = '';
    if (images != null && images.isNotEmpty) {
      imageUrl = images[0]['image_url'] ?? '';
    }

    // Parse available quantity from product.quantity (which is a String in the JSON snippet "500")
    int available = 0;
    if (product['quantity'] != null) {
      available = int.tryParse(product['quantity'].toString()) ?? 0;
    }

    return CartItem(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      name: product['name'] ?? '',
      grade: product['category'] ?? '',
      origin: 'Unknown',
      price: json['price']?.toString() ?? '0.00',
      unit: 'MT',
      image: imageUrl,
      quantity: json['quantity'] ?? 0,
      availableQuantity: available,
      status: product['status'] ?? 'active',
      shippingTerm: 'CIF',
    );
  }

  double get priceValue {
    final cleanPrice = price.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleanPrice) ?? 0.0;
  }

  double get totalItemPrice => priceValue * quantity;
}
