// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:parliament_app/src/core/config/app_routes.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';
import 'package:parliament_app/src/core/widgets/main_scaffold.dart';
import 'package:parliament_app/src/core/config/app_colors.dart'; // Ensure this import is present
import 'package:parliament_app/src/features/safety_tools/presentations/widgets/safety_tools_section.dart';
// import 'safety_tool_widgets.dart'; // Adjust the import path as needed
// import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SafetyTools extends StatefulWidget {
  const SafetyTools({super.key});

  @override
  State<SafetyTools> createState() => _SafetyToolsState();
}

class _SafetyToolsState extends State<SafetyTools> {
  // int _selectedIndex = 1; // Set to 1 for Safety Tools as per drawer index

  // Callback to update the selected index
  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  //   if (index == 5) {
  //     Navigator.pop(context); // Handle logout
  //   }
  //   // Add navigation logic for other indices if needed
  // }

  @override
  Widget build(BuildContext context) {
    // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return MainScaffold(
      // key: _scaffoldKey,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header or greeting (mimicking the image)
            const SizedBox(height: 10.0),
            TextWidget(
              text: 'Safety Tools',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBrown,
              fontFamily: "Museo-Bolder",
              // padding: const EdgeInsets.symmetric(horizontal: 16.0),
            ),
            // const SizedBox(height: 5.0),
            // Safety Tool Sections
            SafetyToolSection(
              title: 'Geofence Setup',
              items: [
                'Define Safe Zones (Home, School, etc.)',
                'Alert when child enters or leaves a zone',
              ],
              onTap: () {
                context.push(AppRoutes.geofenceSetup);
              },
            ),
            SafetyToolSection(
              title: 'Track Offenders Nearby',
              items: [
                'View sex offenders within a set radius',
                'Toggle violent/non-violent filters',
              ],
              onTap: () {
                context.push(AppRoutes.nearbyOffenders);
              },
            ),
            SafetyToolSection(
              title: 'Restricted Zones',
              items: [
                'Manually mark areas to avoid',
                'Alert if child enters any of those zones',
              ],
              onTap: () {
                context.push(AppRoutes.restrictedZone);
              },
            ),
            SafetyToolSection(
              title: 'SOS & Emergency Contact',
              items: [
                'Sends real-time location + alert to parent',
                'Setup of trusted emergency contacts',
              ],
              onTap: () {
                context.push(AppRoutes.emergencyContact);
              },
            ),
          ],
        ),
      ),
      // selectedIndex: _selectedIndex,
      // onTap: _onItemTapped,
    );
  }
}
