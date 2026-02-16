import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global/bloc/order/order_detail_bloc.dart';
import 'package:global/bloc/order/order_detail_event.dart';
import 'package:global/bloc/order/order_detail_state.dart';
import 'package:global/theme/app_colors.dart';
import 'package:global/widgets/gbtn.dart';
import 'package:global/services/toast_service.dart';
import 'package:global/widgets/custom_loading_indicator.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderDetailBloc>().add(FetchOrderDetails(widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F6F6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: BlocBuilder<OrderDetailBloc, OrderDetailState>(
          builder: (context, state) {
            if (state is OrderDetailLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.order.orderNumber,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy').format(state.order.createdAt),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              );
            }
            return const Text("Order Details");
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF636363),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.lock, size: 12, color: Colors.white),
                    SizedBox(width: 4),
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
            ),
          ),
        ],
      ),
      body: BlocBuilder<OrderDetailBloc, OrderDetailState>(
        builder: (context, state) {
          if (state is OrderDetailLoading) {
            return const Center(child: CustomLoadingIndicator());
          } else if (state is OrderDetailError) {
            return Center(child: Text(state.message));
          } else if (state is OrderDetailLoaded) {
            final order = state.order;
            bool isNegotiation = order.currentStep <= 1;
            final currencyFormat = NumberFormat.simpleCurrency(
              decimalDigits: 0,
            );
            final formattedPrice = currencyFormat.format(
              double.tryParse(order.totalAmount) ?? 0.0,
            );

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Order Summary",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        ...order.items.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF6F6F6),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: item.product.images.isNotEmpty
                                        ? Image.network(
                                            item.product.images.first.imageUrl,
                                            fit: BoxFit.contain,
                                            errorBuilder:
                                                (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) => Image.asset(
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
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.product.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${item.quantity} MT • CIF Shanghai", // Assuming CIF for now as per UI
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9F9F9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
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
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Shipment Timeline",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  VerticalTimeline(currentStep: order.currentStep),
                  const SizedBox(height: 24),
                  const Text(
                    "Documents",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (order.purchaseContractUrl == null &&
                      order.billOfLadingUrl == null &&
                      order.commercialInvoiceUrl == null)
                    const Text(
                      "No documents available yet",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    )
                  else ...[
                    if (order.purchaseContractUrl != null)
                      DocumentItem(
                        title: "Purchase Contract",
                        date: DateFormat('yyyy-MM-dd').format(order.updatedAt),
                        url: order.purchaseContractUrl!,
                      ),
                    const SizedBox(height: 8),
                    if (order.billOfLadingUrl != null)
                      DocumentItem(
                        title: "Bill of Lading",
                        date: DateFormat('yyyy-MM-dd').format(order.updatedAt),
                        url: order.billOfLadingUrl!,
                      ),
                    const SizedBox(height: 8),
                    if (order.commercialInvoiceUrl != null)
                      DocumentItem(
                        title: "Commercial Invoice",
                        date: DateFormat('yyyy-MM-dd').format(order.updatedAt),
                        url: order.commercialInvoiceUrl!,
                      ),
                  ],
                  const SizedBox(height: 24),
                  if (isNegotiation)
                    SizedBox(
                      height: 46,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ToastService.showTopToast(
                            context,
                            "Cancellation Requested",
                            "Your cancellation request has been submitted for review",
                            titleColor: Colors.red,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Cancel Order",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  else
                    GBtn(
                      text: "Confirm Delivery",
                      onPressed: () {
                        ToastService.showTopToast(
                          context,
                          "Delivery Confirmed",
                          "Thank you! Fund will be released from escrow",
                        );
                      },
                    ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 46,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ToastService.showTopToast(
                          context,
                          "Dispute Initiated",
                          "Our team will review your case within 24 hours.",
                          titleColor: Colors.orange,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF636363),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Raise Issue",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class VerticalTimeline extends StatefulWidget {
  final int currentStep;
  const VerticalTimeline({super.key, required this.currentStep});

  @override
  State<VerticalTimeline> createState() => _VerticalTimelineState();
}

class _VerticalTimelineState extends State<VerticalTimeline>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Animation<double>> _animations = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    for (int i = 0; i < 6; i++) {
      final start = i * 0.1;
      final end = (i + 1) * 0.1 + 0.4;
      _animations.add(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            start.clamp(0.0, 1.0),
            end.clamp(0.0, 1.0),
            curve: Curves.easeOutBack,
          ),
        ),
      );
    }

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTimelineItem(
          title: "Order Placed",
          date: "", // Could be fixed dates if available
          subtitle: "RFQ submitted",
          index: 0,
        ),
        _buildTimelineItem(
          title: "Contract Signed",
          date: "",
          subtitle: "E-signature completed",
          index: 1,
        ),
        _buildTimelineItem(
          title: "Payment Confirmed",
          date: "",
          subtitle: "Escrow locked",
          index: 2,
        ),
        _buildTimelineItem(
          title: "Shipped",
          date: "",
          subtitle: "Shipment recorded",
          index: 3,
        ),
        _buildTimelineItem(
          title: "In Transit",
          date: "",
          subtitle: "Current status",
          index: 4,
        ),
        _buildTimelineItem(
          title: "Delivered",
          date: "",
          subtitle: "Order complete",
          index: 5,
        ),
      ],
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String date,
    required String subtitle,
    required int index,
  }) {
    bool isCompleted = index < widget.currentStep;
    bool isCurrent = index == widget.currentStep;
    bool isLast = index == 5;

    return AnimatedBuilder(
      animation: _animations[index],
      builder: (context, child) {
        final value = _animations[index].value;
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Column(
                    children: [
                      _buildIndicator(isCompleted, isCurrent),
                      if (!isLast)
                        Expanded(
                          child: CustomPaint(
                            size: const Size(2, double.infinity),
                            painter: DashedLinePainter(
                              color: isCompleted
                                  ? Colors.green
                                  : (isCurrent
                                        ? Colors.orange
                                        : const Color(0xFFD0D0D0)),
                              progress: value,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05 * value),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (date.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  date,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 2),
                              Text(
                                subtitle,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIndicator(bool isCompleted, bool isCurrent) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: isCompleted
              ? Colors.green
              : (isCurrent ? Colors.orange : const Color(0xFFD0D0D0)),
          width: 2,
        ),
      ),
      child: Center(
        child: isCompleted
            ? const Icon(Icons.check, size: 16, color: Colors.green)
            : (isCurrent
                  ? const PulseIndicator()
                  : Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF707070),
                      ),
                    )),
      ),
    );
  }
}

class PulseIndicator extends StatefulWidget {
  const PulseIndicator({super.key});

  @override
  State<PulseIndicator> createState() => _PulseIndicatorState();
}

class _PulseIndicatorState extends State<PulseIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.8,
        end: 1.2,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
      child: const Icon(Icons.access_time, size: 16, color: Colors.orange),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;
  final double progress;
  DashedLinePainter({required this.color, this.progress = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5, dashSpace = 3, startY = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;

    final totalHeight = size.height * progress;

    while (startY < totalHeight) {
      double currentDashHeight = dashHeight;
      if (startY + dashHeight > totalHeight) {
        currentDashHeight = totalHeight - startY;
      }
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + currentDashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(DashedLinePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.progress != progress;
}

class DocumentItem extends StatelessWidget {
  final String title;
  final String date;
  final String url;

  const DocumentItem({
    super.key,
    required this.title,
    required this.date,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F6F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.description,
              color: Color(0xFFBA983F),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.file_download_outlined,
              color: Colors.blue,
              size: 24,
            ),
            onPressed: () {
              // TODO: Implement download
              ToastService.showTopToast(
                context,
                "Download",
                "Starting download...",
              );
            },
          ),
        ],
      ),
    );
  }
}
