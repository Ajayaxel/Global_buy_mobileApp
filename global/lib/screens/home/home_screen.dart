import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global/bloc/profile/profile_bloc.dart';
import 'package:global/bloc/profile/profile_event.dart';
import 'package:global/bloc/profile/profile_state.dart';
import 'package:global/repositories/profile_repository.dart';
import 'package:global/theme/app_colors.dart';
import 'package:global/screens/details/details_screen.dart';
import 'package:global/screens/notifications/notification_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProfileBloc(profileRepository: ProfileRepository())
            ..add(FetchProfile()),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  const HederSection(),
                  const SizedBox(height: 24),

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
                        hintStyle: TextStyle(
                          color: Colors.black38,
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(Icons.search, color: Colors.black54),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Order Status Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.yellowColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/home/cube-fill 1.png",
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "ORD-2025-004",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.lock,
                                          size: 10,
                                          color: Colors.green,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "ESCROW",
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "In Transit: ETA: Feb 15",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward, color: Colors.white),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Category",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  const CategoryBox(),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Featured",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "See all",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const FeaturedList(),
                  const SizedBox(height: 15),
                  const RecentListings(),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HederSection extends StatelessWidget {
  const HederSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        String userName = "User";
        String? avatarUrl;

        if (state is ProfileLoaded) {
          userName = state.profile.fullName.split(' ')[0]; // Use first name
          avatarUrl = state.profile.avatarUrl;
        }

        return Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: const Color(0xFFE0E0E0),
              backgroundImage: avatarUrl != null
                  ? NetworkImage(avatarUrl)
                  : const AssetImage('assets/images/home/cobalt.png')
                        as ImageProvider,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hey, $userName 👋",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Text(
                  "Welcome Back",
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationScreen(),
                    ),
                  );
                },
                color: Colors.black,
              ),
            ),
          ],
        );
      },
    );
  }
}

class CategoryBox extends StatelessWidget {
  const CategoryBox({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          // List of dummy data for the boxes
          final List<Map<String, String>> categories = [
            {
              "name": "Copper Ore",
              "icon": "assets/images/home/gold-ingot_529823 1.png",
            },
            {
              "name": "Lithium Carbonate",
              "icon": "assets/images/home/gold-ingot_529823 1.png",
            },
            {
              "name": "Zinc Concentrate",
              "icon": "assets/images/home/gold-ingot_529823 1.png",
            },
            {
              "name": "Cobalt Hydroxide",
              "icon": "assets/images/home/gold-ingot_529823 1.png",
            },
            {
              "name": "Nickel Ore",
              "icon": "assets/images/home/gold-ingot_529823 1.png",
            },
            {
              "name": "Iron Ore",
              "icon": "assets/images/home/gold-ingot_529823 1.png",
            },
            {
              "name": "Gold Bullion",
              "icon": "assets/images/home/gold-ingot_529823 1.png",
            },
          ];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(
                    name: categories[index]["name"]!,
                    image: categories[index]["icon"]!,
                  ),
                ),
              );
            },
            child: Container(
              width: 106,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    categories[index]["icon"]!,
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    categories[index]["name"]!,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class FeaturedList extends StatelessWidget {
  const FeaturedList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 215,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        separatorBuilder: (context, index) => const SizedBox(width: 15),
        itemBuilder: (context, index) {
          final List<Map<String, dynamic>> featuredItems = [
            {
              "name": "Copper Ore",
              "grade": "Grade A (99.5%)",
              "price": "\$8,500",
              "unit": "/MT",
              "rating": "4.8",
              "image": "assets/images/home/copper 1.png",
              "tag": "Featured",
            },
            {
              "name": "Iron Ore",
              "grade": "Grade B (62%)",
              "price": "\$120",
              "unit": "/MT",
              "rating": "4.6",
              "image": "assets/images/home/iorn 1.png",
              "tag": "Featured",
            },
            {
              "name": "Gold Bullion",
              "grade": "24K (99.9%)",
              "price": "\$65,000",
              "unit": "/kg",
              "rating": "4.9",
              "image": "assets/images/home/gold-ingot_529823 1.png",
              "tag": "Featured",
            },
            {
              "name": "Lithium",
              "grade": "Battery Grade",
              "price": "\$13,500",
              "unit": "/MT",
              "rating": "4.7",
              "image": "assets/images/home/copper 1.png", // Placeholder
              "tag": "Featured",
            },
            {
              "name": "Nickel",
              "grade": "Class 1",
              "price": "\$16,200",
              "unit": "/MT",
              "rating": "4.5",
              "image": "assets/images/home/iorn 1.png", // Placeholder
              "tag": "Featured",
            },
          ];

          final item = featuredItems[index];

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
                    tag: item["tag"],
                  ),
                ),
              );
            },
            child: Container(
              width: 171,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Container
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Image.asset(
                            item["image"],
                            height: 71,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          left: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFCD4A),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              item["tag"],
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
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
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  SizedBox(height: 10),
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
                          const Icon(Icons.star, size: 16, color: Colors.amber),
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
    );
  }
}

class RecentListings extends StatelessWidget {
  const RecentListings({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> recentItems = [
      {
        "name": "Lithium Carbonate",
        "grade": "Battery Grade (99.5%)",
        "price": "\$45,000",
        "unit": "/MT",
        "rating": "4.8",
        "image": "assets/images/home/copper 1.png", // Placeholder
      },
      {
        "name": "Cobalt Hydroxide",
        "grade": "Battery Grade",
        "price": "\$32,000",
        "unit": "/MT",
        "rating": "4.8",
        "image": "assets/images/home/cobalt.png", // Placeholder
      },
      {
        "name": "Manganese Ore",
        "grade": "High Grade (44%)",
        "price": "\$280",
        "unit": "/MT",
        "rating": "4.8",
        "image": "assets/images/home/copper 1.png", // Placeholder
      },
      {
        "name": "Zinc Concentrate",
        "grade": "Premium (55%)",
        "price": "\$1,800",
        "unit": "/MT",
        "rating": "4.5",
        "image": "assets/images/home/iorn 1.png", // Placeholder
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recent Listings",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 0.75,
          ),
          itemCount: recentItems.length,
          itemBuilder: (context, index) {
            final item = recentItems[index];
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
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
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
        SizedBox(height: 30),
      ],
    );
  }
}
