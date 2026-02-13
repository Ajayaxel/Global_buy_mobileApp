class BuyerHomeResponse {
  final bool status;
  final List<String> productCategories;
  final List<Product> featuredProducts;
  final List<Product> recentListings;

  BuyerHomeResponse({
    required this.status,
    required this.productCategories,
    required this.featuredProducts,
    required this.recentListings,
  });

  factory BuyerHomeResponse.fromJson(Map<String, dynamic> json) {
    return BuyerHomeResponse(
      status: json['status'] ?? false,
      productCategories: List<String>.from(json['productCategories'] ?? []),
      featuredProducts:
          (json['featuredProducts'] as List?)
              ?.map((e) => Product.fromJson(e))
              .toList() ??
          [],
      recentListings:
          (json['recentListings'] as List?)
              ?.map((e) => Product.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Product {
  final int id;
  final int supplierId;
  final String name;
  final String category;
  final String description;
  final String quantity;
  final String pricePerUnit;
  final List<String> specifications;
  final String status;
  final List<ProductImage> images;
  final List<ProductCertificate> certificates;
  final Supplier supplier;

  Product({
    required this.id,
    required this.supplierId,
    required this.name,
    required this.category,
    required this.description,
    required this.quantity,
    required this.pricePerUnit,
    required this.specifications,
    required this.status,
    required this.images,
    required this.certificates,
    required this.supplier,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      supplierId: json['supplier_id'] ?? 0,
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      quantity: json['quantity'] ?? '',
      pricePerUnit: json['price_per_unit'] ?? '0.00',
      specifications: List<String>.from(json['specifications'] ?? []),
      status: json['status'] ?? '',
      images:
          (json['images'] as List?)
              ?.map((e) => ProductImage.fromJson(e))
              .toList() ??
          [],
      certificates:
          (json['certificates'] as List?)
              ?.map((e) => ProductCertificate.fromJson(e))
              .toList() ??
          [],
      supplier: Supplier.fromJson(json['supplier'] ?? {}),
    );
  }
}

class ProductImage {
  final int id;
  final int productId;
  final String imagePath;

  ProductImage({
    required this.id,
    required this.productId,
    required this.imagePath,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      imagePath: json['image_path'] ?? '',
    );
  }
}

class ProductCertificate {
  final int id;
  final int productId;
  final String certificatePath;

  ProductCertificate({
    required this.id,
    required this.productId,
    required this.certificatePath,
  });

  factory ProductCertificate.fromJson(Map<String, dynamic> json) {
    return ProductCertificate(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      certificatePath: json['certificate_path'] ?? '',
    );
  }
}

class Supplier {
  final int id;
  final String companyName;
  final String businessCategory;
  final String businessEmail;
  final String phone;
  final String cityRegion;

  Supplier({
    required this.id,
    required this.companyName,
    required this.businessCategory,
    required this.businessEmail,
    required this.phone,
    required this.cityRegion,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'] ?? 0,
      companyName: json['company_name'] ?? '',
      businessCategory: json['business_category'] ?? '',
      businessEmail: json['business_email'] ?? '',
      phone: json['phone'] ?? '',
      cityRegion: json['city_region'] ?? '',
    );
  }
}
