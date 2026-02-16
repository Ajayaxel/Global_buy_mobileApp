import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global/bloc/order/order_bloc.dart';
import 'package:global/bloc/order/order_event.dart';
import 'package:global/bloc/order/order_state.dart';
import 'package:global/theme/app_colors.dart';
import 'package:global/screens/home/home_screen.dart'; // To reuse HederSection
import 'package:global/screens/orders/order_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:global/widgets/custom_loading_indicator.dart';
import 'package:global/models/order_model.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(FetchOrders());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HederSection(),
              const SizedBox(height: 10),
              const Text(
                "Orders",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: BlocBuilder<OrderBloc, OrderState>(
                  builder: (context, state) {
                    if (state is OrderLoading) {
                      return const Center(child: CustomLoadingIndicator());
                    } else if (state is OrderError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (state is OrdersLoaded) {
                      if (state.orders.isEmpty) {
                        return const Center(child: Text("No orders found."));
                      }
                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<OrderBloc>().add(FetchOrders());
                        },
                        child: ListView.builder(
                          itemCount: state.orders.length,
                          itemBuilder: (context, index) {
                            final order = state.orders[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: OrderCard(order: order),
                            );
                          },
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(order.createdAt);
    final currencyFormat = NumberFormat.simpleCurrency(decimalDigits: 0);
    final formattedPrice = currencyFormat.format(
      double.tryParse(order.totalAmount) ?? 0.0,
    );

    // Get first item product name if available
    String productName = "Unknown Product";
    if (order.items.isNotEmpty) {
      productName =
          "${order.items[0].quantity}MT ${order.items[0].product.name}";
      // Use placeholder if image path is not available or handled by backend
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailScreen(orderId: order.id),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.orderNumber,
                        style: const TextStyle(
                          color: Color(0xFFA0A0A0),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        productName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF636363),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.lock, size: 12, color: Colors.white),
                            SizedBox(width: 6),
                            Text(
                              "ESCROW",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child:
                        (order.items.isNotEmpty &&
                            order.items.first.product.images.isNotEmpty)
                        ? Image.network(
                            order.items.first.product.images.first.imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                                  "assets/images/home/copper 1.png",
                                  fit: BoxFit.contain,
                                ),
                          )
                        : Image.asset(
                            "assets/images/home/copper 1.png",
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            OrderTimeline(
              currentStep: order.currentStep,
              statusText: order.statusText,
            ),
            const SizedBox(height: 8),
            const Divider(color: Color(0xFFEEEEEE), thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedDate,
                  style: const TextStyle(
                    color: Color(0xFFA0A0A0),
                    fontSize: 14,
                  ),
                ),
                Text(
                  formattedPrice,
                  style: const TextStyle(
                    color: AppColors.yellowColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OrderTimeline extends StatelessWidget {
  final int currentStep;
  final String statusText;

  const OrderTimeline({
    super.key,
    required this.currentStep,
    required this.statusText,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final slotWidth = totalWidth / 6;
        final linePadding = slotWidth / 2;

        return Column(
          children: [
            SizedBox(
              height: 32,
              child: Stack(
                children: [
                  // Lines
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: linePadding),
                        child: Row(
                          children: List.generate(5, (i) {
                            Color color = i < currentStep
                                ? Colors.green
                                : const Color(0xFFD0D0D0);
                            return Expanded(child: _buildDashedLine(color));
                          }),
                        ),
                      ),
                    ),
                  ),
                  // Icons
                  Row(
                    children: List.generate(6, (i) {
                      return Expanded(child: Center(child: _buildStepIcon(i)));
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Status Text
            Row(
              children: List.generate(6, (index) {
                bool isCurrent = index == currentStep;
                return Expanded(
                  child: isCurrent
                      ? Center(
                          child: FittedBox(
                            fit: BoxFit.none,
                            alignment: Alignment.center,
                            child: Text(
                              statusText,
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.visible,
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                );
              }),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStepIcon(int index) {
    bool isCompleted = index < currentStep;
    bool isCurrent = index == currentStep;

    if (isCompleted) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.green, width: 2),
        ),
        child: const Center(
          child: Icon(Icons.check, size: 18, color: Colors.green),
        ),
      );
    } else if (isCurrent) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.orange, width: 2),
        ),
        child: const Center(
          child: Icon(Icons.access_time, size: 18, color: Colors.orange),
        ),
      );
    } else {
      return Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFD0D0D0),
        ),
        child: Center(
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF707070),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildDashedLine(Color color) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 6.0;
        const dashHeight = 2.0;
        const dashSpace = 4.0;
        final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();
        if (dashCount <= 0) return const SizedBox();
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(dashCount, (index) {
            return Padding(
              padding: EdgeInsets.only(
                right: index == dashCount - 1 ? 0 : dashSpace,
              ),
              child: SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(decoration: BoxDecoration(color: color)),
              ),
            );
          }),
        );
      },
    );
  }
}
