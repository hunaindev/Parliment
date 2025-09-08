import 'package:flutter/material.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';

class CustomTextButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text;
  const CustomTextButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  State<CustomTextButton> createState() => _CustomTextButtonState();
}

class _CustomTextButtonState extends State<CustomTextButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(
          widget.text,
          style: TextStyle(
            color: AppColors.primaryLightGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}