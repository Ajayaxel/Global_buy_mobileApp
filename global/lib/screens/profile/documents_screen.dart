import 'package:flutter/material.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, size: 18),
                    ),
                  ),
                  const Text(
                    "Documents",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 40), // To balance the back button
                ],
              ),
              const SizedBox(height: 24),
              // Document List
              Expanded(
                child: ListView(
                  children: [
                    _buildDocumentCard(
                      title: "Government ID",
                      subtitle: "Passport_scan.jpg(2.4 MB)",
                    ),
                    const SizedBox(height: 12),
                    _buildDocumentCard(
                      title: "Bank Statement",
                      subtitle: "Statement_Sept.pdf",
                    ),
                    const SizedBox(height: 12),
                    _buildDocumentCard(
                      title: "Government ID",
                      subtitle: "Passport_scan.jpg(2.4 MB)",
                    ),
                    const SizedBox(height: 12),
                    _buildDocumentCard(
                      title: "Bank Statement",
                      subtitle: "Statement_Sept.pdf",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentCard({required String title, required String subtitle}) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Icon Container
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF6F6F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/home/doucmanticon.png',
                width: 32,
                height: 22,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Title and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
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
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          // Download Icon
          Image.asset(
            'assets/images/home/Download.png',
            width: 22,
            height: 24,
            color: const Color(0xFF0082D3),
          ),
        ],
      ),
    );
  }
}
