import 'package:flutter/material.dart';

class CustomBottomNav extends StatefulWidget {
  final Function(int) onTabChanged;
  final int currentIndex;

  CustomBottomNav({required this.onTabChanged, required this.currentIndex});

  @override
  _CustomBottomNavState createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  @override
  Widget build(BuildContext context) {
    int _currentIndex = widget.currentIndex;

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, "Home", 0),
              _buildNavItem(Icons.calendar_month_rounded, "Report", 1),
              GestureDetector(
                onTap: () {
                  widget.onTabChanged(0);
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.qr_code_scanner,
                      color: Colors.black, size: 28),
                ),
              ),
              _buildNavItem(Icons.history, "History", 3),
              _buildNavItem(Icons.settings_accessibility, "setting", 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = widget.currentIndex == index;
    return GestureDetector(
      onTap: () => widget.onTabChanged(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Colors.white : Colors.grey, size: 24),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
