// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:parliament_app/src/core/widgets/main_scaffold.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';

class EmergencyNumberScreen extends StatefulWidget {
  @override
  State<EmergencyNumberScreen> createState() => _EmergencyNumberScreenState();
}

class _EmergencyNumberScreenState extends State<EmergencyNumberScreen> {
  String _selectedEmergency = 'Medical';

  final List<Map<String, dynamic>> _emergencyTypes = [
    {
      'label': 'Medical',
      'icon': Icons.medical_services,
      'color': AppColors.primaryLightGreen,
    },
    {
      'label': 'Fire',
      'icon': Icons.local_fire_department,
      'color': Colors.orange,
    },
    {
      'label': 'Police',
      'icon': Icons.local_police,
      'color': Colors.red,
    },
  ];

  @override
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            // Scrollable content
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  _buildLocationInfo(),
                  const SizedBox(height: 24),
                  _buildAlertInstructions(),
                  const SizedBox(height: 12),
                  _buildEmergencyChips(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .1,
            ),

            // Sticky Bottom Actions
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: const [
          SizedBox(height: 24),
          Text(
            'Emergency number',
            style: TextStyle(
              color: AppColors.darkBrown,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: "Museo-Bolder",
            ),
          ),
          SizedBox(height: 8),
          Text(
            'HD 00:08',
            style: TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLocationInfo() {
    const locationTextStyle =
        TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'YOU ARE HERE',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: "Museo-Bolder",
          ),
        ),
        SizedBox(height: 4),
        Text('Lincoln Hwy, Pollock Pines, CA', style: locationTextStyle),
        Text('95726', style: locationTextStyle),
        Text('Plus code: 84CXQGM+4J', style: locationTextStyle),
        Text('38.775945, -120.469544', style: locationTextStyle),
      ],
    );
  }

  Widget _buildAlertInstructions() {
    return Column(
      children: [
        Divider(color: Colors.grey[400], thickness: 1),
        const SizedBox(height: 6),
        const Text(
          'ALERT OPERATOR WITHOUT SPEAKING',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: "Museo-Bolder",
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Silently share location & emergency type',
          style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Divider(color: Colors.grey[400], thickness: 1),
      ],
    );
  }

  Widget _buildEmergencyChips() {
    return Center(
      child: Wrap(
        spacing: 12,
        children: _emergencyTypes.map((type) {
          final String label = type['label'] as String;
          final IconData icon = type['icon'] as IconData;
          final Color color = type['color'] as Color;

          final bool isSelected = _selectedEmergency == label;

          return ChoiceChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon,
                    size: 18, color: isSelected ? Colors.white : Colors.black),
                const SizedBox(width: 6),
                Text(label),
              ],
            ),
            selectedColor: color,
            backgroundColor: Colors.grey.shade300,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            selected: isSelected,
            onSelected: (_) {
              setState(() {
                _selectedEmergency = label;
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: const Icon(Icons.dialpad),
          color: Colors.black,
          onPressed: () {},
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
          ),
          child: const Icon(Icons.phone, color: Colors.white),
        ),
        IconButton(
          icon: const Icon(Icons.speaker_phone),
          color: Colors.black,
          onPressed: () {},
        ),
      ],
    );
  }
}
