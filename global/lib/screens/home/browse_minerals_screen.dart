import 'package:flutter/material.dart';
import 'package:global/screens/details/details_screen.dart';

class BrowseMineralsScreen extends StatelessWidget {
  const BrowseMineralsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> mineralItems = [
      {
        "name": "Lithium Carbonate",
        "grade": "Battery Grade (99.5%)",
        "price": "\$45,000",
        "unit": "/MT",
        "rating": "4.8",
        "image":
            "assets/images/home/copper 1.png", // Placeholder as per home_screen.dart
      },
      {
        "name": "Cobalt Hydroxide",
        "grade": "Battery Grade",
        "price": "\$32,000",
        "unit": "/MT",
        "rating": "4.8",
        "image": "assets/images/home/cobalt.png",
      },
      {
        "name": "Zinc Concentrate",
        "grade": "Premium (55%)",
        "price": "\$1,800",
        "unit": "/MT",
        "rating": "4.5",
        "image":
            "assets/images/home/iorn 1.png", // Placeholder as per home_screen.dart
      },
      {
        "name": "Manganese Ore",
        "grade": "High Grade (44%)",
        "price": "\$280",
        "unit": "/MT",
        "rating": "4.8",
        "image":
            "assets/images/home/copper 1.png", // Placeholder as per home_screen.dart
      },
      {
        "name": "Copper Ore",
        "grade": "Grade A (99.5%)",
        "price": "\$8,500",
        "unit": "/MT",
        "rating": "4.8",
        "image": "assets/images/home/copper 1.png",
      },
      {
        "name": "Iron Ore",
        "grade": "Grade B (62%)",
        "price": "\$120",
        "unit": "/MT",
        "rating": "4.6",
        "image": "assets/images/home/iorn 1.png",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Browse Minerals",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Search minerals, origins...",
                    hintStyle: TextStyle(color: Colors.black38, fontSize: 16),
                    prefixIcon: Icon(Icons.search, color: Colors.black54),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: mineralItems.length,
                  itemBuilder: (context, index) {
                    final item = mineralItems[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsScreen(
                              name: item["name"],
                              grade: item["grade"],
                              price: item["price"],
                              unit: item["unit"],
                              rating: item["rating"],
                              image: item["image"],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image Container
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF6F6F6),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    item["image"],
                                    height: 71,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item["name"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item["grade"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: item["price"],
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          TextSpan(
                                            text: item["unit"],
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Colors.amber,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      item["rating"],
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
      ),
    );
  }
}
