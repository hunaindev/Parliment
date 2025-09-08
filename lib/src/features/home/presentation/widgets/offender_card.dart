import 'package:flutter/material.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';

class OffenderCard extends StatelessWidget {
  final Map<String, String> offender;

  const OffenderCard({Key? key, required this.offender}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Use NetworkImage if you're loading from URL
            CircleAvatar(
              radius: 30,
              backgroundImage: offender['image']!.startsWith('http')
                  ? NetworkImage(offender['image']!)
                  : AssetImage(offender['image']!) as ImageProvider,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Prevents infinite height
                children: [
                  TextWidget(
                    text: offender['name'] ?? '',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBrown,
                  ),
                  const SizedBox(height: 5),
                  TextWidget(
                    text: offender['age'] ?? '',
                    fontSize: 14,
                    color: AppColors.darkBrown,
                    fontWeight: FontWeight.bold,
                  ),
                  TextWidget(
                    text: offender['location'] ?? '',
                    fontSize: 14,
                    color: AppColors.darkBrown,
                    fontWeight: FontWeight.bold,
                  ),
                  Text(
                    offender['conviction'] ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.darkBrown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
