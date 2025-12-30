class CartItem {
  final String name;
  final String grade;
  final String origin;
  final String price;
  final String unit;
  final String image;
  int quantity;
  final String status;
  final String shippingTerm;

  CartItem({
    required this.name,
    required this.grade,
    required this.origin,
    required this.price,
    required this.unit,
    required this.image,
    required this.quantity,
    this.status = 'QA Pending',
    this.shippingTerm = 'CIF',
  });

  double get priceValue {
    // Extract numeric value from price string like "$8,500"
    final cleanPrice = price.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleanPrice) ?? 0.0;
  }

  double get totalItemPrice => priceValue * quantity;
}
