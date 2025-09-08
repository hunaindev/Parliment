// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';

class DividerSection extends StatefulWidget {
  const DividerSection({super.key});

  @override
  State<DividerSection> createState() => _DividerSectionState();
}

class _DividerSectionState extends State<DividerSection> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[400], thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Or',
            style: TextStyle(color: AppColors.darkGray),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[400], thickness: 1)),
      ],
    );
  }
}
