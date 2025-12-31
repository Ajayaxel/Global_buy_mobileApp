import 'package:flutter/material.dart';
import 'package:global/screens/home/home_screen.dart';
import 'chat_screen.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> messages = [
      {
        "name": "Salta Lithium SA",
        "message": "We can offer \$44,000/MT for 100MT ..",
        "time": "09:18",
        "unread": 1,
        "image": "assets/images/home/cobalt.png", // Placeholder
      },
      {
        "name": "Andean Mining Co.",
        "message": "We can offer \$44,000/MT for 100MT ..",
        "time": "12/05/2025",
        "unread": 2,
        "image": "assets/images/home/cobalt.png",
      },
      {
        "name": "Jacob Mining Co.",
        "message": "We can offer \$44,000/MT for 100MT ..",
        "time": "12/05/2025",
        "unread": 3,
        "image": "assets/images/home/cobalt.png",
      },
      {
        "name": "Lamta Lithium SA",
        "message": "We can offer \$44,000/MT for 100MT ..",
        "time": "12/05/2025",
        "unread": 1,
        "image": "assets/images/home/cobalt.png",
      },
      {
        "name": "Salta Lithium SA",
        "message": "We can offer \$44,000/MT for 100MT ..",
        "time": "09:18",
        "unread": 1,
        "image": "assets/images/home/cobalt.png",
      },
      {
        "name": "Andean Mining Co.",
        "message": "We can offer \$44,000/MT for 100MT ..",
        "time": "12/05/2025",
        "unread": 2,
        "image": "assets/images/home/cobalt.png",
      },
      {
        "name": "Jacob Mining Co.",
        "message": "We can offer \$44,000/MT for 100MT ..",
        "time": "12/05/2025",
        "unread": 3,
        "image": "assets/images/home/cobalt.png",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: const HederSection(),
            ),
            const SizedBox(height: 10),

            // Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "Messages",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            // Messages List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: messages.length,
                separatorBuilder: (context, index) =>
                    const Divider(height: 1, color: Color(0xFFEEEEEE)),
                itemBuilder: (context, index) {
                  final item = messages[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            name: item['name'],
                            image: item['image'],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 20, // Size 40 diameter as requested
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: AssetImage(item['image']),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    if (item['unread'] > 0)
                                      Container(
                                        width: 20,
                                        height: 20,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                          color: Color(
                                            0xFFC5A03F,
                                          ), // Gold/Yellow color
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          item['unread'].toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item['message'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      item['time'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
