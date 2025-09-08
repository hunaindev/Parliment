import 'package:flutter/material.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';
import 'package:parliament_app/src/features/home/domain/entities/offender_entity.dart';

class HomeOffenderCard extends StatelessWidget {
  final List<Offender> offenders;

  const HomeOffenderCard({Key? key, required this.offenders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 93,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: offenders.length,
        itemBuilder: (context, index) {
          final offender = offenders[index];
          return Container(
            margin: EdgeInsets.only(right: 8),
            padding: EdgeInsets.all(10),
            width: screenWidth * 0.6,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image or avatar goes here, if available
                // If photoUrl is present in Offender
                CircleAvatar(
                  radius: 30,
                  backgroundImage: offender.photoUrl!.startsWith('http')
                      ? NetworkImage(offender.photoUrl!)
                      : AssetImage(offender.photoUrl!) as ImageProvider,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextWidget(
                        text: offender.name,
                        fontSize: 14,
                        color: AppColors.darkBrown,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 5),
                      TextWidget(
                        text: 'Age: ${offender.age}',
                        fontSize: 12,
                        color: AppColors.darkBrown,
                      ),
                      TextWidget(
                        text: 'Last near: ${offender.lastLocation}',
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                        color: AppColors.darkBrown,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Offender {
  final String name;
  final String age;
  final String lastLocation;
  // Optional
  final String? photoUrl;

  Offender({
    required this.name,
    required this.age,
    required this.lastLocation,
    this.photoUrl,
  });

  factory Offender.fromJson(Map<String, dynamic> json) {
    return Offender(
      name: json['name'] ?? '',
      age: json['age'] ?? '',
      lastLocation: json['lastLocation'] ?? '',
      photoUrl: json['photoUrl'],
    );
  }
  factory Offender.fromEntity(OffenderEntity entity) {
    return Offender(
      name: entity.name,
      age: entity.age,
      lastLocation: entity.location,
      photoUrl: entity.photoUrl,
    );
  }
}
