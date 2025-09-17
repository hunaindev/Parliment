// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/config/app_constants.dart';
import 'package:parliament_app/src/core/config/local_storage.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';
import 'package:parliament_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:parliament_app/src/features/home/data/data_source/offender_remote_source_impl.dart';
import 'package:parliament_app/src/features/home/data/model/offender_model.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/dashboard/dashboard_state.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/location/location_cubit.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/offender/offender_bloc.dart';
// import 'package:parliament_app/src/features/home/presentation/pages/home_screen.dart';
import 'package:parliament_app/src/features/home/presentation/widgets/google_map_screen.dart';
import 'package:parliament_app/src/features/safety_tools/presentations/widgets/ofender_card.dart';
import 'package:http/http.dart' as http;

class NearbyOffendersScreen extends StatefulWidget {
  const NearbyOffendersScreen({super.key});

  @override
  State<NearbyOffendersScreen> createState() => _NearbyOffendersScreenState();
}

class _NearbyOffendersScreenState extends State<NearbyOffendersScreen> {
  int _selectedTab =
      2; // Default to "ALL" (0 = VIOLENT, 1 = NON-VIOLENT, 2 = ALL)
  bool _notifyEnabled = true; // Toggle for notification

  List<Map<String, dynamic>> _offenders = [];
  List<LatLng> _childLocations = [];

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    try {
      final children = context.read<ChildLocationCubit>().state;

      // Collect child locations
      final childrenWithLocation =
          children.where((child) => child.location != null).toList();

      if (childrenWithLocation.isNotEmpty) {
        setState(() {
          _childLocations = childrenWithLocation
              .map((c) => LatLng(c.location!.latitude, c.location!.longitude))
              .toList();
        });

        // Example: use first child’s location to fetch offenders
        final firstChild = childrenWithLocation.first;
        final lat = firstChild.location!.latitude;
        final lng = firstChild.location!.longitude;

        final offenders = await fetchOffenders(
          lat: lat,
          lng: lng,
          page: 1,
          pageSize: 10,
        );

        setState(() {
          _offenders = offenders;
        });
      }
    } catch (e) {
      print("❌ Error in _loadData: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchOffenders({
    required double lat,
    required double lng,
    required int page,
    required int pageSize,
  }) async {
    UserEntity? parentId = await LocalStorage.getUser();
    final localUrl = Uri.parse(
        "$baseUrl/api/v1/offender/get/${parentId?.userId}?lat=$lat&lng=$lng");
    // Uri.parse("${baseUrl}/api/v1/offender/get?lat=$lat&lng=$lng&radius=1");
    try {
      final localResponse = await http.get(localUrl);
      if (localResponse.statusCode == 200) {
        final localData = jsonDecode(localResponse.body);
        print(localData);
        if (localData['data'] is List) {
          final offenders = List<Map<String, dynamic>>.from(localData['data']);
          print("✅ Got offenders from local DB");
          return offenders;
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        print("Offender API Hitted");

        throw Exception(
            'Failed to fetch offenders: ${localResponse.statusCode}');
      }
    } catch (e, stack) {
      print("Offender API Hitted");

      print('❌ Exception occurred in fetchOffenders: $e');
      print('🔍 Stack trace: $stack');
      throw Exception('Failed to fetch offenders. ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const TextWidget(
          text: 'Nearby Offenders',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        backgroundColor: Colors.grey[200],
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tab Navigation
                  OffenderTabSection(
                    selectedTab: _selectedTab,
                    onTabChanged: (index) {
                      setState(() {
                        _selectedTab = index;
                      });
                    },
                  ),
                  // Map Placeholder
                  Container(
                      height: 200, // Approximate height based on image
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[300], // Placeholder for map
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.black),
                      ),
                      child: GoogleMapScreen(
                        locations: _childLocations,
                        offenderLocations: _getFilteredOffenders()
                            .map((d) => LatLng(d['location']['coordinates'][1],
                                d['location']['coordinates'][0]))
                            .toList(),
                      )),

                  SizedBox(height: 10),
                  // Filtered List of Offenders
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextWidget(
                          text: 'List of Offenders',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: "Museo-Bolder",
                        ),
                        const SizedBox(height: 8),
                        ..._getFilteredOffenders().map((offender) {
                          print(offender);
                          return Column(
                            children: [
                              OffenderCard(
                                name: offender["name"]!,
                                type: offender["gender"]!,
                                distance: "0km",
                                lastSeen: '',
                              ),
                              const SizedBox(height: 8),
                            ],
                          );
                        })
                      ],
                    ),
                  ),
                  // Notification Toggle
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SwitchListTile(
                      title: const TextWidget(
                        text: 'Notify me about new offenders',
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Museo-Bold",
                      ),
                      value: _notifyEnabled,
                      activeColor: AppColors.primaryLightGreen,
                      activeTrackColor:
                          AppColors.primaryLightGreen.withOpacity(0.5),
                      inactiveThumbColor: AppColors.darkGray,
                      inactiveTrackColor: Colors.white,
                      onChanged: (value) {
                        setState(() {
                          _notifyEnabled = value;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                      dense: true,
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

  List<Map<String, dynamic>> _getFilteredOffenders() {
    if (_selectedTab == 0) {
      // VIOLENT
      return _offenders.where((offender) {
        final record = offender['court_record'].toString().toLowerCase();
        bool isViolet = record.contains('rape') ||
            record.contains('assault') ||
            record.contains('molestation') ||
            record.contains('kidnapping') ||
            record.contains('homicide') ||
            record.contains('murder');
        return isViolet;
      }).toList();
    } else if (_selectedTab == 1) {
      return _offenders.where((offender) {
        final record = offender['court_record'].toString().toLowerCase();
        bool isViolet = record.contains('rape') ||
            record.contains('assault') ||
            record.contains('molestation') ||
            record.contains('kidnapping') ||
            record.contains('homicide') ||
            record.contains('murder');
        return !isViolet;
      }).toList();
    } else {
      // ALL
      return _offenders;
    }
  }
}

// Separate widget for tab section
class OffenderTabSection extends StatelessWidget {
  final int selectedTab;
  final Function(int) onTabChanged;

  const OffenderTabSection({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200, // Background color of the tab section
        borderRadius: BorderRadius.circular(30), // Rounded edges
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildTab('VIOLENT', 0),
          _buildTab('NON-VIOLENT', 1),
          _buildTab('ALL', 2),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    return GestureDetector(
      onTap: () => onTabChanged(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color:
              selectedTab == index ? AppColors.primaryLightGreen : Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.horizontal(
            left: index == 0 ? Radius.circular(4) : Radius.zero,
            right: index == 2 ? Radius.circular(4) : Radius.zero,
          ),
        ),
        child: TextWidget(
          text: label,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: selectedTab == index ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
