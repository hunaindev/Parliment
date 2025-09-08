import 'package:flutter/material.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/widgets/svg_picture.dart';

class RoleButton extends StatelessWidget {
  final String label;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleButton({
    super.key,
    required this.label,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: screenWidth * .35,
            height: screenHeight * .22,
            // height is determined by content (SVG + padding)
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryLightGreen.withOpacity(0.1)
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? AppColors.primaryLightGreen : Colors.grey,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPictureWidget(
                  path: imagePath,
                  height: screenHeight * 0.2,
                  width: screenWidth * 0.5,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8), // Spacing between card and label
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color:
                isSelected ? AppColors.primaryLightGreen : AppColors.darkBrown,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
