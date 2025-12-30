import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      "Help & Support",
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
                const Text(
                  "How can we help?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                // Support Options Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildSupportItem(
                        icon: Icons.chat_bubble_outline,
                        title: "Live Chat",
                        subtitle: "Chat with our support team",
                      ),
                      _buildDivider(),
                      _buildSupportItem(
                        icon: Icons.phone_outlined,
                        title: "Phone Support",
                        subtitle: "+971 5524 55232",
                      ),
                      _buildDivider(),
                      _buildSupportItem(
                        icon: Icons.email_outlined,
                        title: "Email Support",
                        subtitle: "support@goe.com",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Frequently Asked Questions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // FAQ Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildFAQItem(
                        question: "How does escrow protection work?",
                        answer:
                            "When you place an order, your payment is held securely in escrow until you confirm receipt and satisfaction with the minerals. This protects both buyers and sellers throughout the transaction.",
                        isExpanded: false,
                      ),
                      _buildDivider(),
                      _buildFAQItem(
                        question: "What is the minimum order quantity?",
                        answer: "The minimum order quantity varies by product.",
                      ),
                      _buildDivider(),
                      _buildFAQItem(
                        question: "How do I track my order?",
                        answer:
                            "You can track your order in the Orders section.",
                      ),
                      _buildDivider(),
                      _buildFAQItem(
                        question: "What if there's a dispute with my order?",
                        answer:
                            "Contact our support team for dispute resolution.",
                      ),
                      _buildDivider(),
                      _buildFAQItem(
                        question: "How do I get certified documents?",
                        answer:
                            "Documents are available in the Documents section.",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSupportItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFF6F6F6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.black, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
      onTap: () {},
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
    bool isExpanded = false,
  }) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: isExpanded,
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Text(
              answer,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: Color(0xFFEEEEEE),
    );
  }
}
