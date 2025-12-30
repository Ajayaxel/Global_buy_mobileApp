import 'package:flutter/material.dart';
import 'package:global/screens/main_screen.dart';
import 'package:global/theme/app_colors.dart';
import 'package:global/widgets/gbtn.dart';

class VerificationPendingScreen extends StatelessWidget {
  const VerificationPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header Icon
                Icon(
                  Icons.hourglass_empty_rounded,
                  size: 80,
                  color: AppColors.yellowColor,
                ),
                const SizedBox(height: 24),
                // Title
                const Text(
                  'Verification Under\nReview',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.2,
                  ),
                ),

                // Subtitle
                Text(
                  'We are Currently reviewing your\ndocuments. this usually tames 1-24 hours',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 15),
                // Process Timeline Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Process Timeline',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildTimelineItem(
                        title: 'Documents Submitted',
                        subtitle: 'today, 9:41 AM',
                        status: TimelineStatus.completed,
                      ),
                      _buildTimelineItem(
                        title: 'In Review',
                        subtitle: 'Estimated time:1 - 2 hours',
                        status: TimelineStatus.active,
                      ),
                      _buildTimelineItem(
                        title: 'Verified',
                        subtitle: 'Pending approval',
                        status: TimelineStatus.pending,
                        isLast: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Documents Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Documents',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _buildDocumentCard(
                  title: 'Government ID',
                  fileName: 'Passport_scan.jpg(2.4 MB)',
                  status: 'Reviewing',
                  statusColor: Colors.orange[100]!,
                  textColor: Colors.orange[800]!,
                ),
                const SizedBox(height: 10),
                _buildDocumentCard(
                  title: 'Bank Statement',
                  fileName: 'Statement_Sept.pdf',
                  status: 'Accepted',
                  statusColor: Colors.green[100]!,
                  textColor: Colors.green[800]!,
                ),
                const SizedBox(height: 10),
                // Continue Button
                GBtn(
                  text: 'Continue',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainScreen(),
                      ),
                    );
                    // Handle continue
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String subtitle,
    required TimelineStatus status,
    bool isLast = false,
  }) {
    Color iconColor;
    Widget icon;
    Color lineColor;

    switch (status) {
      case TimelineStatus.completed:
        iconColor = Colors.green;
        icon = const Icon(Icons.check_circle, color: Colors.green, size: 30);
        lineColor = AppColors.yellowColor;
        break;
      case TimelineStatus.active:
        iconColor = AppColors.yellowColor;
        icon = Icon(Icons.access_time_filled, color: iconColor, size: 30);
        lineColor = Colors.grey[400]!;
        break;
      case TimelineStatus.pending:
        iconColor = Colors.grey[300]!;
        icon = Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
        lineColor = Colors.grey[300]!;
        break;
    }

    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              icon,
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: CustomPaint(
                      painter: DashLinePainter(color: lineColor),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: status == TimelineStatus.active
                        ? AppColors.yellowColor
                        : Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard({
    required String title,
    required String fileName,
    required String status,
    required Color statusColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[50]!,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.featured_play_list_outlined,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 12,
                          color: textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  fileName,
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum TimelineStatus { completed, active, pending }

class DashLinePainter extends CustomPainter {
  final Color color;
  DashLinePainter({required this.color});

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
