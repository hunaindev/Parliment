import 'package:flutter/material.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';

class CustomSwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitchTile({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: TextWidget(
        text: title,
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        maxLines: 1,
        overflow: TextOverflow.visible,
      ),
      value: value,
      activeColor: AppColors.primaryLightGreen,
      activeTrackColor: AppColors.primaryLightGreen.withOpacity(0.5),
      inactiveThumbColor: AppColors.darkGray,
      inactiveTrackColor: Colors.white,
      onChanged: onChanged,
    );
  }
}