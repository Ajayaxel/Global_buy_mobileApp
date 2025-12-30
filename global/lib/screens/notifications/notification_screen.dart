import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                      color: Colors.white,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                      onPressed: () => Navigator.pop(context),
                      color: Colors.black,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      "Notification",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // To balance the back button
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SectionHeader(title: "Today"),
                  const NotificationItem(
                    icon: Icons.chat_bubble_outline,
                    iconColor: Color(0xFF679CFF),
                    title: "Counter-offer Received",
                    subtitle: "Salta Lithium SA has responded",
                    time: "04:25",
                  ),
                  const NotificationItem(
                    imagePath: "assets/images/home/notififctioncube.png",
                    iconColor: Color(0xFFFFB900),
                    title: "Shipment Update",
                    subtitle: "Your copper ore shipment has passed",
                    time: "04:25",
                  ),
                  const SizedBox(height: 16),
                  const SectionHeader(title: "Yesterday"),
                  const NotificationItem(
                    icon: Icons.description_outlined,
                    iconColor: Color(0xFFFFCE54),
                    title: "Document Uploaded",
                    subtitle: "Bill of Lading is now available.",
                    time: "01/02/2025",
                  ),
                  const NotificationItem(
                    icon: Icons.credit_card_outlined,
                    iconColor: Color(0xFF008D3F),
                    title: "Payment Confirmed",
                    subtitle:
                        "Your payment of \$8,500,000 has been secured in escrow.",
                    time: "04:25",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;

  const NotificationItem({
    super.key,
    this.icon,
    this.imagePath,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: imagePath != null
                    ? Image.asset(
                        imagePath!,
                        color: Colors.white,
                        width: 24,
                        height: 24,
                      )
                    : Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
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
                        Text(
                          time,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFEEEEEE)),
      ],
    );
  }
}
