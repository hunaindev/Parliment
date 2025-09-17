import 'package:flutter/material.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';

class OffenderCard extends StatefulWidget {
  final String name;
  final String type;
  final String distance;
  final String lastSeen;

  const OffenderCard({
    super.key,
    required this.name,
    required this.type,
    required this.distance,
    required this.lastSeen,
  });

  @override
  State<OffenderCard> createState() => _OffenderCardState();
}

class _OffenderCardState extends State<OffenderCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            child: Icon(Icons.account_circle_rounded, size: 40),
            // backgroundImage: NetworkImage('https://via.placeholder.com/48'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: widget.name,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                const SizedBox(height: 6),
                TextWidget(
                  text: 'Gender: ${widget.type}',
                  fontSize: 14,
                  color: AppColors.darkGray,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 2),
                // TextWidget(
                //   text: widget.distance,
                //   fontSize: 14,
                //   color: AppColors.darkGray,
                //   fontWeight: FontWeight.bold,
                // ),
                // const SizedBox(height: 2),
                // TextWidget(
                //   text: 'Last seen: $lastSeen',
                //   fontSize: 14,
                //   color: AppColors.darkGray,
                //   fontWeight: FontWeight.bold,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
