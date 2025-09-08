import 'package:flutter/material.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/widgets/svg_picture.dart';

class ChildBottomNavigationWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final List<Map<String, dynamic>> _items = [
    {'label': 'Dashboard', 'icon': 'dashboard-tab'},
    {'label': 'Map', 'icon': 'location-tab'},
    {'label': 'Profile', 'icon': 'offenders'},
  ];

  ChildBottomNavigationWidget({
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: screenHeight * 0.095,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = selectedIndex == index;

          return Container(
            width: isSelected
                ? screenWidth * .4
                : screenWidth * .2, // Increase width for active tab
            child: GestureDetector(
              onTap: () => onTap(index),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryLightGreen
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPictureWidget(
                      path: 'assets/icons/${item['icon']!.toLowerCase()}.svg',
                      color: isSelected ? Colors.white : AppColors.darkBrown,
                      width: 20,
                      height: 20,
                    ),
                    if (isSelected && item['label']!.isNotEmpty) ...[
                      const SizedBox(width: 14),
                      Flexible(
                        child: Text(
                          item['label']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: "Museo-Bold",
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
