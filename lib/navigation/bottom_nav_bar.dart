import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final ValueNotifier<int> currentIndex;
  const CustomBottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 70,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, "Home", 0),
          _buildNavItem(Icons.emoji_events, "Service", 1),
          _buildNavItem(Icons.groups, "History", 2),
          _buildNavItem(Icons.more_horiz, "Profile", 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () {
        currentIndex.value = index;
      },
      child: ValueListenableBuilder<int>(
        valueListenable: currentIndex,
        builder: (context, selectedIndex, _) {
          final isSelected = selectedIndex == index;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? const Color(0xFFea0001) : Colors.white,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFFea0001) : Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
