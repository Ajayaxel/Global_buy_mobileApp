import 'package:flutter/material.dart';
import 'package:global/theme/app_colors.dart';
import 'package:global/widgets/gbtn.dart';
import 'package:global/services/toast_service.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;
  final String date;
  final int currentStep;

  const OrderDetailScreen({
    super.key,
    required this.orderId,
    required this.date,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    bool isNegotiation = currentStep <= 1;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F6F6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              orderId,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              date,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
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
      body: SingleChildScrollView(
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
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F6F6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/images/home/copper 1.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Copper Ore",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "1000 MT • CIF Shanghai",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                      children: const [
                        Text(
                          "Total",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        Text(
                          "\$8,500,000",
                          style: TextStyle(
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
            VerticalTimeline(currentStep: currentStep),
            const SizedBox(height: 24),
            const Text(
              "Documents",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (isNegotiation)
              const Text(
                "No documents available yet",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              )
            else ...[
              const DocumentItem(
                title: "Purchase Contract",
                date: "2024-02-05",
              ),
              const SizedBox(height: 8),
              const DocumentItem(title: "Bill of Lading", date: "2024-02-05"),
              const SizedBox(height: 8),
              const DocumentItem(
                title: "Commercial Invoice",
                date: "2024-02-05",
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
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class VerticalTimeline extends StatelessWidget {
  final int currentStep;
  const VerticalTimeline({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTimelineItem(
          title: "Order Placed",
          date: "2024-01-15",
          subtitle: "RFQ submitted",
          index: 0,
        ),
        _buildTimelineItem(
          title: "Contract Signed",
          date: "2024-01-18",
          subtitle: "E-signature completed",
          index: 1,
        ),
        _buildTimelineItem(
          title: "Payment Confirmed",
          date: "2024-01-20",
          subtitle: "Escrow locked",
          index: 2,
        ),
        _buildTimelineItem(
          title: "Shipped",
          date: "2024-01-25",
          subtitle: "Left Santiago Port",
          index: 3,
        ),
        _buildTimelineItem(
          title: "In Transit",
          date: "2024-02-01",
          subtitle: "ETA: Feb 15",
          index: 4,
        ),
        _buildTimelineItem(
          title: "Delivered",
          date: "2024-02-05",
          subtitle: "Shipment delivered",
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
    bool isCompleted = index < currentStep;
    bool isCurrent = index == currentStep;
    bool isLast = index == 5;
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
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
                            ? const Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.orange,
                              )
                            : Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF707070),
                                ),
                              )),
                ),
              ),
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
                      const SizedBox(height: 2),
                      Text(
                        date,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
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
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;
  DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5, dashSpace = 3, startY = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class DocumentItem extends StatelessWidget {
  final String title;
  final String date;

  const DocumentItem({super.key, required this.title, required this.date});

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
          const Icon(
            Icons.file_download_outlined,
            color: Colors.blue,
            size: 24,
          ),
        ],
      ),
    );
  }
}
