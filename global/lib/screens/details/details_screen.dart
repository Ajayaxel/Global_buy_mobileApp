import 'package:flutter/material.dart';
import 'package:global/screens/chat/chat_screen.dart';
import 'package:global/theme/app_colors.dart';
import 'package:global/widgets/gbtn.dart';
import 'package:global/models/buyer_home_model.dart';
import 'package:global/services/toast_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global/bloc/cart/cart_bloc.dart';
import 'package:global/bloc/cart/cart_state.dart';
import 'package:global/bloc/cart/cart_event.dart';

class DetailsScreen extends StatefulWidget {
  final Product? product;
  final String? name;
  final String? grade;
  final String? price;
  final String? unit;
  final String? rating;
  final String? image;
  final String? tag;

  const DetailsScreen({
    super.key,
    this.product,
    this.name,
    this.grade,
    this.price,
    this.unit,
    this.rating,
    this.image,
    this.tag = 'Featured',
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int quantity = 100;
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Helper to get values with fallback
    final productName = widget.product?.name ?? widget.name ?? "Unknown";
    final productCategory =
        widget.product?.category ?? widget.grade ?? "Standard Grade";
    final productPrice =
        widget.product?.pricePerUnit ??
        widget.price?.replaceAll('\$', '') ??
        "0.00";
    final productUnit = widget.product != null
        ? "/Unit"
        : (widget.unit ?? "/MT");
    final productRating = widget.rating ?? "4.8";
    final productDesc =
        widget.product != null && widget.product!.description.isNotEmpty
        ? widget.product!.description
        : "Responsibly sourced ${productName.toLowerCase()} for battery cathode production. High purity and ethically mined.";
    final productQuantity = widget.product?.quantity ?? "200 MT";
    final supplierName = widget.product != null
        ? widget.product!.supplier.companyName
        : "Katanga Resources";
    final supplierLocation = widget.product != null
        ? widget.product!.supplier.cityRegion
        : "Durban Bonded Warehouse";

    // Image handling
    Widget buildImage() {
      if (widget.product != null && widget.product!.images.isNotEmpty) {
        return SizedBox(
          height: 220,
          child: PageView.builder(
            itemCount: widget.product!.images.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(
                'http://192.168.0.145:8000/storage/${widget.product!.images[index].imagePath}',
                height: 220,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(
                    Icons.no_photography_rounded,
                    size: 80,
                    color: Colors.grey,
                  ),
                ),
              );
            },
          ),
        );
      } else if (widget.image != null) {
        return Image.asset(widget.image!, height: 220, fit: BoxFit.contain);
      } else {
        return const Center(
          child: Icon(
            Icons.no_photography_rounded,
            size: 80,
            color: Colors.grey,
          ),
        );
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          // Layer 1: Background Image and Dots
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.55,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20), // Reduced space
                  Center(
                    child: Hero(tag: productName, child: buildImage()),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      (widget.product != null &&
                              widget.product!.images.isNotEmpty)
                          ? widget.product!.images.length
                          : 1,
                      (index) => _buildDot(index == _currentImageIndex),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Layer 2: Draggable Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.55,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productName,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    productCategory,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  productRating,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Location Tag
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: Colors.black,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "DR Congo",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Price Section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F6F6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "\$$productPrice",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.yellowColor,
                                      ),
                                    ),
                                    TextSpan(
                                      text: productUnit,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.yellowColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "Available: $productQuantity",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Description
                        const Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          productDesc,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Bottom Action Bar
                        Container(
                          height: 46,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F6F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(Icons.remove, size: 18),
                                  onPressed: () {
                                    if (quantity > 0) {
                                      setState(() {
                                        quantity -= 50;
                                      });
                                    }
                                  },
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "${quantity}MT",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(Icons.add, size: 18),
                                  onPressed: () {
                                    setState(() {
                                      quantity += 50;
                                    });
                                  },
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        BlocConsumer<CartBloc, CartState>(
                          listener: (context, state) {
                            if (state is CartSuccess) {
                              ToastService.showTopToast(
                                context,
                                "Added to Cart",
                                state.message,
                              );
                            } else if (state is CartError) {
                              ToastService.showTopToast(
                                context,
                                "Failed",
                                state.error,
                                titleColor: Colors.red,
                              );
                            }
                          },
                          builder: (context, state) {
                            final isLoading = state is CartLoading;
                            return GBtn(
                              text: isLoading ? "ADDING..." : "ADD TO CART",
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      if (widget.product == null) {
                                        ToastService.showTopToast(
                                          context,
                                          "Error",
                                          "Product details not available",
                                          titleColor: Colors.red,
                                        );
                                        return;
                                      }

                                      // Parse available quantity
                                      final availableQtyStr =
                                          widget.product!.quantity.isNotEmpty
                                          ? widget.product!.quantity
                                          : "0";
                                      final availableQty =
                                          int.tryParse(
                                            availableQtyStr.replaceAll(
                                              RegExp(r'[^0-9]'),
                                              '',
                                            ),
                                          ) ??
                                          0;

                                      if (quantity > availableQty) {
                                        ToastService.showTopToast(
                                          context,
                                          "Unavailable Quantity",
                                          "Selected quantity ($quantity) exceeds available stock ($availableQty).",
                                          titleColor: Colors.red,
                                        );
                                        return;
                                      }

                                      if (quantity <= 0) {
                                        ToastService.showTopToast(
                                          context,
                                          "Invalid Quantity",
                                          "Please select a quantity greater than 0.",
                                          titleColor: Colors.red,
                                        );
                                        return;
                                      }

                                      // Parse price
                                      final price =
                                          double.tryParse(
                                            productPrice.replaceAll(
                                              RegExp(r'[^0-9.]'),
                                              '',
                                            ),
                                          ) ??
                                          0.0;

                                      context.read<CartBloc>().add(
                                        AddToCartEvent(
                                          productId: widget.product!.id,
                                          quantity: quantity,
                                          price: price,
                                        ),
                                      );
                                    },
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Specifications",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: 2.2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          padding: EdgeInsets.zero,
                          children:
                              (widget.product?.specifications.isNotEmpty ??
                                  false)
                              ? widget.product!.specifications.map((spec) {
                                  return _buildSpecItem(spec, "Yes");
                                }).toList()
                              : [_buildSpecItem("Grade / Purity", "N/A")],
                        ),
                        const SizedBox(height: 16),

                        // Certifications
                        const Text(
                          "Certifications",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children:
                              (widget.product?.certificates.isNotEmpty ?? false)
                              ? widget.product!.certificates.map((cert) {
                                  return _buildCertificationItem("Certified");
                                }).toList()
                              : [_buildCertificationItem("ISO 9001")],
                        ),
                        const SizedBox(height: 24),

                        // Supplier
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F6F6),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Supplier",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Row(
                                    children: const [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 18,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        "4.8",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const SizedBox(height: 8),
                              Text(
                                supplierName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                supplierLocation,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                height: 46,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                          name: supplierName,
                                          image:
                                              "assets/images/home/cobalt.png",
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF767772),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.chat_bubble_outline,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "Chat Supplier",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Layer 3: Back Button
          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    onPressed: () => Navigator.pop(context),
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 12 : 8,
      height: isActive ? 12 : 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.yellowColor : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildSpecItem(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificationItem(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified_user_outlined, size: 18),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
