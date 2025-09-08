// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/config/app_constants.dart';
import 'package:parliament_app/src/core/config/local_storage.dart';
import 'package:parliament_app/src/core/utils/headers.dart';
// import 'package:parliament_app/src/core/widgets/custom_button.dart';
import 'package:parliament_app/src/core/widgets/custom_input_field.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';
import 'package:parliament_app/src/features/home/data/model/children_model.dart';
import 'package:parliament_app/src/features/home/data/model/dashboard_data_model.dart';
// import 'package:parliament_app/src/features/home/data/model/children_model.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/dashboard/dashboard_bloc.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/dashboard/dashboard_event.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/dashboard/dashboard_state.dart';
import 'package:parliament_app/src/features/safety_tools/data/models/restricted_zone_model.dart';
import 'package:parliament_app/src/features/safety_tools/presentations/blocs/restricted_zone_bloc.dart';
import 'package:parliament_app/src/features/safety_tools/presentations/blocs/restricted_zone_event.dart';
import 'package:parliament_app/src/features/safety_tools/presentations/blocs/restricted_zone_state.dart';
import 'package:parliament_app/src/features/safety_tools/presentations/widgets/custom_switch.dart';
import 'package:parliament_app/src/features/safety_tools/presentations/widgets/radius_slider.dart';
// import 'package:parliament_app/src/core/widgets/svg_picture.dart';
// import 'package:location/location.dart' as loc;
import 'package:http/http.dart' as http;

class RestrictedZonesScreen extends StatefulWidget {
  const RestrictedZonesScreen({super.key});

  @override
  State<RestrictedZonesScreen> createState() => _RestrictedZonesScreenState();
}

class _RestrictedZonesScreenState extends State<RestrictedZonesScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  double _radiusValue = 50.0; // Default radius in meters
  bool _alertEnabled = true;
  String _selectedPerson = 'John Doe'; // Default dropdown value
  final _zoneNameController = TextEditingController();
  bool _isLocationLoaded = false; // Flag to track if location is loaded
  List<dynamic> allChildren = [];
  @override
  void initState() {
    super.initState();
    final children = context.read<DashboardBloc>().allChildren;
    print("All Children: ${children.length}");
    allChildren.assignAll(children);
    if (children.isNotEmpty) {
      _selectedPerson = children.first.id;
    }

    fetchDasboard();
    _setInitialLocation();
  }

  Future<void> fetchDasboard() async {
    final user = await LocalStorage.getUser();
    String parentId = user!.userId.toString();
    print("get dashoard data parent $parentId");
    final url = Uri.parse("$baseUrl/api/v1/user/get-dashboard");

    try {
      final response = await http.get(
        url,
        headers: await Headers().authHeaders(),
      );
      print("decoded: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        print("decoded: ${decoded}");
        if (decoded is Map && decoded['data'] is Map) {
          setState(() {
            allChildren = (decoded['data']['children'] as List)
                .map((e) => ChildrenModel.fromJson(e))
                .toList();
          });
        } else {
          print('Unexpected response format');
        }
      } else {
        print('Failed to fetch dashboard data: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Failed to fetch dashboard data: $e');
    }
  }

  Future<void> _setInitialLocation() async {
    try {
      final dashboardBloc = context.read<DashboardBloc>();

      double lat = dashboardBloc.currentLat;
      double lng = dashboardBloc.currentLng;

      print('Current lat: $lat, lng: $lng');

      setState(() {
        _selectedLocation = LatLng(
          dashboardBloc.currentLat,
          dashboardBloc.currentLng,
        );
        _isLocationLoaded = true;
      });
      print('State updated: $_selectedLocation, $_isLocationLoaded');

      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(_selectedLocation!, 14.0),
        );
      }
    } catch (e) {
      print("Error fetching location: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get location: $e')),
      );
    }
  }

  @override
  void dispose() {
    _zoneNameController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _onMapTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
    _showSetupBottomSheet(); // Open bottom sheet on map tap
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_selectedLocation != null && _isLocationLoaded) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_selectedLocation!, 14.0),
      );
    }
  }

  Set<Circle> _getCircles() {
    return _selectedLocation != null
        ? {
            Circle(
              circleId: const CircleId('geofence'),
              center: _selectedLocation!,
              radius: _radiusValue *
                  10, // Convert slider value (0-100) to meters (50-1000)
              fillColor: AppColors.primaryLightGreen.withOpacity(0.3),
              strokeColor: AppColors.primaryLightGreen,
              strokeWidth: 2,
            ),
          }
        : {};
  }

  void _showSetupBottomSheet() {
    // final allChildren = context.read<DashboardBloc>().allChildren;
    print("Laldfje uerur: ${allChildren.length}");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(243, 246, 247, 252),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          margin: const EdgeInsets.only(bottom: 16.0),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 121, 116, 126),
                            borderRadius: BorderRadius.circular(2.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      const TextWidget(
                        text: 'Zone Name',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 8),
                      CustomInputField(
                        label: "Zone",
                        hintText: "Enter Zone name",
                        controller: _zoneNameController,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const TextWidget(
                        text: 'Radius',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 8),
                      CustomRadiusSlider(
                        value: _radiusValue,
                        onChanged: (value) {
                          setModalState(() {
                            _radiusValue = value;
                          });
                          setState(() {}); // Update parent state
                        },
                      ),
                      const SizedBox(height: 16),
                      const TextWidget(
                        text: 'Assign to',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedPerson,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: (60 - 24) / 2,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          // labelText: 'Assign To',
                          labelStyle: const TextStyle(
                            fontFamily: 'Museo-Bolder',
                            color: Color.fromARGB(255, 124, 139, 160),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.primaryLightGreen,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        dropdownColor: Colors.white,
                        iconEnabledColor: AppColors.primaryLightGreen,
                        style: const TextStyle(
                          fontFamily: 'Museo',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        items: allChildren.map((child) {
                          return DropdownMenuItem<String>(
                            value: child.id,
                            child: Text(child.name),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setModalState(() {
                            _selectedPerson = newValue!;
                          });
                          setState(() {}); // Update parent state
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomSwitchTile(
                        title: 'Alert if child enters this area',
                        value: _alertEnabled,
                        onChanged: (value) {
                          setModalState(() {
                            _alertEnabled = value;
                          });
                          setState(() {}); // Update parent state
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: AppColors.primaryLightGreen),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 15.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              child: const TextWidget(
                                text: 'Cancel',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryLightGreen,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                if (_selectedLocation != null &&
                                    _zoneNameController.text
                                        .trim()
                                        .isNotEmpty) {
                                  final model = RestrictedZoneModel(
                                    name: _zoneNameController.text.trim(),
                                    lat: _selectedLocation!.latitude,
                                    lng: _selectedLocation!.longitude,
                                    location: _selectedLocation.toString(),
                                    radius:
                                        _radiusValue * 10, // Convert to meters
                                    assignTo: _selectedPerson,
                                    alertOnEntry: _alertEnabled,
                                  );
                                  // Navigator.pop(context);

                                  context.read<RestrictedZoneBloc>().add(
                                        CreateRestrictedZoneEvent(model),
                                      );
                                  // Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Please enter a zone name and select a location.")),
                                  );
                                }
                                print('Zone Name: ${_zoneNameController.text}, '
                                    'Radius: ${(_radiusValue * 10).round()}m, ');
                                // Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryLightGreen,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 15.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: const TextWidget(
                                text: 'Save',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Set _zoneCircles = {};

  void _renderZones(List geofences, List zones) {
    final circles = <Circle>{};

    // for (var g in geofences) {
    //   final lat = g['center']['lat'];
    //   final lng = g['center']['lng'];
    //   final radius = (g['radius'] ?? 300).toDouble();
    //   circles.add(Circle(
    //     circleId: CircleId("geo_$lat$lng"),
    //     center: LatLng(lat, lng),
    //     radius: radius,
    //     fillColor: Colors.green.withOpacity(0.3),
    //     strokeColor: Colors.green,
    //     strokeWidth: 2,
    //   ));
    // }

    for (var z in zones) {
      final lat = z['latitude'];
      final lng = z['longitude'];
      final radius = (z['radius'] ?? 300).toDouble();
      circles.add(Circle(
        circleId: CircleId("zone_$lat$lng"),
        center: LatLng(lat, lng),
        radius: radius,
        fillColor: Colors.red.withOpacity(0.3),
        strokeColor: Colors.red,
        strokeWidth: 2,
      ));
    }

    setState(() => _zoneCircles = circles);
  }

  void _zoomToFitCircles(GoogleMapController controller) {
    if (_zoneCircles.isEmpty) return;

    double minLat = _zoneCircles.first.center.latitude;
    double maxLat = _zoneCircles.first.center.latitude;
    double minLng = _zoneCircles.first.center.longitude;
    double maxLng = _zoneCircles.first.center.longitude;

    for (var circle in _zoneCircles) {
      final center = circle.center;
      // Circle को approx cover करने के लिए radius को lat/lng degree में बदलो
      final radiusInDegrees = circle.radius / 111000.0; // 1 degree ≈ 111km

      minLat = (center.latitude - radiusInDegrees).clamp(-90.0, 90.0);
      maxLat = (center.latitude + radiusInDegrees).clamp(-90.0, 90.0);
      minLng = (center.longitude - radiusInDegrees).clamp(-180.0, 180.0);
      maxLng = (center.longitude + radiusInDegrees).clamp(-180.0, 180.0);
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 100), // 100 = padding
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RestrictedZoneBloc, RestrictedZoneState>(
        listener: (context, state) async {
          if (state is RestrictedZoneSuccess) {
            Navigator.pop(context); // Close bottom sheet
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Restricted Zone created successfully")),
            );
            final user = await LocalStorage.getUser();
            if (user != null) {
              context.read<DashboardBloc>().add(
                    FetchDasboard(parentId: user.userId.toString()),
                  );
            }
          } else if (state is RestrictedZoneError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            automaticallyImplyLeading: true,
            centerTitle: true,
            title: TextWidget(
              text: 'Restricted Zones',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            backgroundColor: Colors.white, // White background
          ),
          body: _isLocationLoaded && _selectedLocation != null
              ? MultiBlocListener(
                  listeners: [
                    // ✅ Geofence listener
                    BlocListener<DashboardBloc, DashboardState>(
                      listenWhen: (previous, current) {
                        // sirf tab chale jab geofences change ho
                        if (previous is DashboardLoaded &&
                            current is DashboardLoaded) {
                          return (previous.geofences != current.geofences ||
                              previous.redZone != current.redZone);
                        }
                        return false;
                      },
                      listener: (context, state) {
                        if (state is DashboardLoaded) {
                          _renderZones(state.geofences, state.redZone);
                        }
                      },
                    ),
                  ],
                  child: GoogleMap(
                    onMapCreated: (c) {
                      _onMapCreated(c);
                      final dashboardState = context.read<DashboardBloc>();
                      print(dashboardState.redzone);
                      _renderZones(
                          dashboardState.allGeofences, dashboardState.redzone);
                      // Future.delayed(const Duration(milliseconds: 500), () {
                      //   _zoomToFitCircles(c);
                      // });
                    },
                    initialCameraPosition: CameraPosition(
                      target: _selectedLocation!,
                      zoom: 11.0,
                    ),
                    onTap: _onMapTap,
                    markers: _selectedLocation != null
                        ? {
                            Marker(
                              markerId: const MarkerId('selected'),
                              position: _selectedLocation!,
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueRed),
                            ),
                          }
                        : {},
                    circles: {..._zoneCircles, ..._getCircles()},
                    zoomGesturesEnabled: true,
                    scrollGesturesEnabled: true,
                    rotateGesturesEnabled: true,
                    tiltGesturesEnabled: true,
                    myLocationButtonEnabled: true,
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryLightGreen,
                  ),
                ),
        ));
  }
}
