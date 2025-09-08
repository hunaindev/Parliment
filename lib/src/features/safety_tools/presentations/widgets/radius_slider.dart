import 'package:flutter/material.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';

class CustomRadiusSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const CustomRadiusSlider({
    Key? key,
    required this.value,
    this.min = 0,
    this.max = 100,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth, // Ensures full width from parent
          child: Slider(
            value: value,
            min: min,
            max: max,
            activeColor: AppColors.primaryLightGreen,
            inactiveColor: const Color.fromARGB(255, 161, 180, 36).withOpacity(.3),
            onChanged: onChanged,
            label: '${(value * 10).round()} m',
          ),
        );
      },
    );
  }
}
