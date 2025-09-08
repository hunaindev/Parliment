import 'package:flutter/material.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';

class CustomOutlinedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String title;
  final double width;
  final double height;

  const CustomOutlinedButton({
    super.key,
    required this.onPressed,
    required this.title,
    required this.width,
    required this.height,
  });

  @override
  State<CustomOutlinedButton> createState() => _CustomOutlinedButtonState();
}

class _CustomOutlinedButtonState extends State<CustomOutlinedButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: widget.onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(widget.width, widget.height),
        side: BorderSide(
            color: AppColors
                .primaryLightGreen), // optional: customize border color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6), // 6px radius
        ),
      ),
      child: TextWidget(
        text: widget.title,
        color: AppColors.primaryLightGreen,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}