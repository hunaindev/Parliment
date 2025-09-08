import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:geocoding/geocoding.dart';

class ChildStatusCard extends StatefulWidget {
  final String name;
  final String status;
  final LatLng location;
  final Color statusColor;
  final Color locationStatus;
  final String imageUrl;

  const ChildStatusCard({
    super.key,
    required this.name,
    required this.status,
    required this.location,
    required this.statusColor,
    required this.locationStatus,
    required this.imageUrl,
  });

  @override
  State<ChildStatusCard> createState() => _ChildStatusCardState();
}

class _ChildStatusCardState extends State<ChildStatusCard> {
  String? _address;

  @override
  void initState() {
    super.initState();
    _fetchAddress();
  }

  Future<void> _fetchAddress() async {
    final lat = widget.location.latitude;
    final long = widget.location.longitude;

    try {
      final placemarks = await placemarkFromCoordinates(lat, long);
      print("palcemarks: placemarks ");
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _address = '${place.street}, ${place.locality}';
        });
      } else {
        throw Exception("No placemarks found");
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _address = 'Loading Location...';
        });
        print("ERROR: -------------- ${e.toString()} ---------- ");
        print("📛 Geocoding failed: $e");
        // print("📛 Stack: $stack");

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text("Failed to get location: ${e.toString()}"),
        //     backgroundColor: Colors.red,
        //   ),
        // );
      }
    }
  }

  @override
  void didUpdateWidget(covariant ChildStatusCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.location != oldWidget.location) {
      _fetchAddress();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final circleRadius = screenWidth * 0.05;
    final fontSize = screenWidth * 0.04;
    final padding = screenWidth * 0.04;
    final spacing = screenWidth * 0.01;

    return Container(
      height: 120,
      width: 250,
      padding: EdgeInsets.symmetric(
          horizontal: padding * 0.4, vertical: screenWidth * 0.02),
      margin: EdgeInsets.only(
        left: 0,
        right: spacing * 2,
        top: spacing,
        bottom: spacing,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.darkBrown, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: circleRadius,
                backgroundImage: NetworkImage(widget.imageUrl),
              ),
              SizedBox(width: spacing * 2),
              Text(
                widget.name,
                style: TextStyle(
                  fontSize: fontSize * 1.1,
                  color: AppColors.darkBrown,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing * 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: circleRadius * 0.4,
                    backgroundColor: widget.locationStatus,
                  ),
                  SizedBox(width: spacing * 2),
                  Container(
                    width: 120,
                    child: AddressDisplay(
                      address: _address,
                      fontSize: fontSize,
                      textColor: AppColors.darkBrown,
                      width: 120,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: circleRadius * 0.4,
                    backgroundColor: widget.statusColor,
                  ),
                  SizedBox(width: spacing * 2),
                  Text(
                    widget.status,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: AppColors.darkBrown,
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

class AddressDisplay extends StatelessWidget {
  final String? address;
  final double fontSize;
  final Color textColor;
  final double width;

  const AddressDisplay({
    super.key,
    required this.address,
    required this.fontSize,
    required this.textColor,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Text(
        address ?? 'Loading...',
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          fontSize: fontSize,
          color: textColor,
        ),
      ),
    );
  }
}
