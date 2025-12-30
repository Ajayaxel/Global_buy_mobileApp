import 'package:flutter/material.dart';
import 'package:global/services/cart_manager.dart';
import 'package:global/models/cart_item.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildNavItem(0, "assets/images/home/navicon1.png", "Home"),
          _buildNavItem(1, "assets/images/home/navicon2.png", "Message"),
          _buildNavItem(2, "assets/images/home/navicon3.png", "Cart"),
          _buildNavItem(3, "assets/images/home/navicon4.png", "Orders"),
          _buildNavItem(4, "assets/images/home/navicon5.png", "Profile"),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String iconPath, String label) {
    final isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            // Indicator
            Container(
              width: 20,
              height: 3,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFC69C38)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Content
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Image.asset(
                        iconPath,
                        width: 18,
                        height: 18,
                        color: isSelected
                            ? const Color(0xFFC69C38)
                            : Colors.black,
                      ),
                      if (index == 2) // Cart index
                        ValueListenableBuilder<List<CartItem>>(
                          valueListenable: CartManager().cartItemsNotifier,
                          builder: (context, items, child) {
                            if (items.isEmpty) return const SizedBox.shrink();
                            return Positioned(
                              top: -8,
                              right: -8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFBA983F),
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  '${items.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFFC69C38)
                          : Colors.black,
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
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
