// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';

class TermsCheckboxRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const TermsCheckboxRow({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  void _navigateToTerms() {
    // Placeholder navigation logic for Terms of Service
    print('Navigating to Terms of Service');
  }

  void _navigateToPrivacy() {
    // Placeholder navigation logic for Privacy Policy
    print('Navigating to Privacy Policy');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return AppColors.primaryLightGreen;
            }
            return Colors.white;
          }),
          activeColor: AppColors.primaryLightGreen,
          checkColor: Colors.white,
          side: BorderSide.none,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(!value), // Toggle state when text is tapped
            child: Text.rich(
              TextSpan(
                style: const TextStyle(fontSize: 12),
                children: [
                  TextSpan(
                    text: "I’m agree to The ",
                    style: TextStyle(color: AppColors.darkBrown),
                  ),
                  TextSpan(
                    text: "Terms of Service",
                    style: TextStyle(
                      color: AppColors.primaryLightGreen,
                      fontWeight: FontWeight.bold,
                    ),
                    // recognizer can be added later
                  ),
                  TextSpan(
                    text: " and ",
                    style: TextStyle(color: AppColors.darkBrown),
                  ),
                  TextSpan(
                    text: "Privacy Policy",
                    style: TextStyle(
                      color: AppColors.primaryLightGreen,
                      fontWeight: FontWeight.bold,
                    ),
                    // recognizer can be added later
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
