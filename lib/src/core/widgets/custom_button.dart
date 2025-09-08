import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;
  final double? height;
  final double? borderRadius;
  final double? fontSize;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.color,
    this.textColor,
    this.height,
    this.borderRadius,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      // height: 60, // Default height 60 if not specified
      height: height ?? 60, // Default height 60 if not specified
      child: ElevatedButton(
        onPressed: onPressed ??
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Button "$text" Pressed!')),
              );
            },
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? const Color(0xFFA0B424), // Default color
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(borderRadius ?? 8.0), // Default radius
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize ?? 18,
            fontWeight: FontWeight.bold,
            color: textColor ?? Colors.white, // Default text color
          ),
        ),
      ),
    );
  }
}