// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';
import 'package:parliament_app/src/features/safety_tools/presentations/widgets/add_member_modal.dart';
import 'package:parliament_app/src/features/safety_tools/presentations/widgets/card_contact.dart';
import 'package:parliament_app/src/features/safety_tools/presentations/widgets/custom_switch.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  bool _sendLiveLocation = true;
  bool _playLoudAlert = true;
  bool _autoCallPrimary = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              centerTitle: true,
              title: const TextWidget(
                text: 'Emergency Screen',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              backgroundColor: Colors.grey[200],
              elevation: 0,
              pinned: false,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextWidget(
                      text: 'Manage Contacts',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: "Museo-Bolder",
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AddMemberDialog(onCreate: (dummy) async {});
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(128, 234, 243, 151),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(
                            color: AppColors.primaryLightGreen,
                            width: 2,
                          ),
                        ),
                        elevation: 0,
                      ),
                      child: const TextWidget(
                        text: 'Add Contact +',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Museo-Bold",
                        color: AppColors.primaryLightGreen,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ContactCard(
                      name: 'Dad',
                      phone: '+123456789',
                      onEdit: () {
                        print("Edit button pressed");
                      },
                      onDelete: () {
                        print("Delete button pressed");
                      },
                    ),
                    const SizedBox(height: 8),
                    ContactCard(
                      name: 'Dad',
                      phone: '+123456789',
                      onEdit: () {
                        print("Edit button pressed");
                      },
                      onDelete: () {
                        print("Delete button pressed");
                      },
                    ),
                    const SizedBox(height: 34),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TextWidget(
                            text: 'SOS Settings',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: "Museo-Bolder",
                          ),
                          const SizedBox(height: 10),
                          CustomSwitchTile(
                            title: 'Send live location',
                            value: _sendLiveLocation,
                            onChanged: (value) {
                              setState(() {
                                _sendLiveLocation = value;
                              });
                            },
                          ),
                          CustomSwitchTile(
                            title: 'Play loud alert sound',
                            value: _playLoudAlert,
                            onChanged: (value) {
                              setState(() {
                                _playLoudAlert = value;
                              });
                            },
                          ),
                          CustomSwitchTile(
                            title: 'Auto-call primary contact',
                            value: _autoCallPrimary,
                            onChanged: (value) {
                              setState(() {
                                _autoCallPrimary = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
