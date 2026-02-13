import 'package:global/models/buyer_home_model.dart';

class OrderListResponse {
  final bool status;
  final List<OrderModel> orders;

  OrderListResponse({required this.status, required this.orders});

  factory OrderListResponse.fromJson(Map<String, dynamic> json) {
    return OrderListResponse(
      status: json['status'] ?? false,
      orders:
          (json['orders'] as List?)
              ?.map((e) => OrderModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class OrderDetailResponse {
  final bool status;
  final OrderModel order;

  OrderDetailResponse({required this.status, required this.order});

  factory OrderDetailResponse.fromJson(Map<String, dynamic> json) {
    return OrderDetailResponse(
      status: json['status'] ?? false,
      order: OrderModel.fromJson(json['order'] ?? {}),
    );
  }
}

class OrderModel {
  final int id;
  final String orderNumber;
  final int buyerId;
  final String totalAmount;
  final String status;
  final String? purchaseContract;
  final String? billOfLading;
  final String? commercialInvoice;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? purchaseContractUrl;
  final String? billOfLadingUrl;
  final String? commercialInvoiceUrl;
  final List<OrderItem> items;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.buyerId,
    required this.totalAmount,
    required this.status,
    this.purchaseContract,
    this.billOfLading,
    this.commercialInvoice,
    required this.createdAt,
    required this.updatedAt,
    this.purchaseContractUrl,
    this.billOfLadingUrl,
    this.commercialInvoiceUrl,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      orderNumber: json['order_number'] ?? '',
      buyerId: json['buyer_id'] ?? 0,
      totalAmount: json['total_amount'] ?? '0.00',
      status: json['status'] ?? '',
      purchaseContract: json['purchase_contract'],
      billOfLading: json['bill_of_lading'],
      commercialInvoice: json['commercial_invoice'],
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
      purchaseContractUrl: json['purchase_contract_url'],
      billOfLadingUrl: json['bill_of_lading_url'],
      commercialInvoiceUrl: json['commercial_invoice_url'],
      items:
          (json['items'] as List?)
              ?.map((e) => OrderItem.fromJson(e))
              .toList() ??
          [],
    );
  }

  int get currentStep {
    switch (status.toLowerCase()) {
      case 'order placed':
        if (purchaseContractUrl != null) return 1;
        return 0;
      case 'contract signed':
        return 1;
      case 'payment confirmed':
        return 2;
      case 'shipped':
        return 3;
      case 'in transit':
        return 4;
      case 'delivered':
        return 5;
      case 'completed':
        return 5;
      case 'cancelled':
        return 0;
      default:
        // Heuristic based on documents
        if (commercialInvoiceUrl != null) return 3;
        if (billOfLadingUrl != null) return 3;
        if (purchaseContractUrl != null) return 1;
        return 0;
    }
  }

  String get statusText {
    final step = currentStep;
    switch (step) {
      case 0:
        return "Order Placed";
      case 1:
        return "Negotiation";
      case 2:
        return "Payment Confirmed";
      case 3:
        return "Shipped";
      case 4:
        return "In Transit";
      case 5:
        return "Delivered";
      default:
        return "Processing";
    }
  }
}

class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final int supplierId;
  final int quantity;
  final String price;
  final String total;
  final Product product;
  final Supplier supplier;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.supplierId,
    required this.quantity,
    required this.price,
    required this.total,
    required this.product,
    required this.supplier,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? 0,
      orderId: json['order_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      supplierId: json['supplier_id'] ?? 0,
      quantity: json['quantity'] ?? 0,
      price: json['price'] ?? '0.00',
      total: json['total'] ?? '0.00',
      product: Product.fromJson(json['product'] ?? {}),
      supplier: Supplier.fromJson(json['supplier'] ?? {}),
    );
  }
}
