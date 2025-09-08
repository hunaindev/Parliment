// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/config/local_storage.dart';
import 'package:parliament_app/src/core/widgets/custom_input_field.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';
import 'package:parliament_app/src/core/widgets/svg_picture.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/dashboard/dashboard_bloc.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/dashboard/dashboard_event.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/dashboard/dashboard_state.dart';
import 'package:parliament_app/src/features/safety_tools/domain/entities/geofence_entity.dart';
import 'package:parliament_app/src/features/safety_tools/presentations/blocs/geofence_bloc.dart';
import 'package:parliament_app/src/features/safety_tools/presentations/blocs/geofence_event.dart';
import 'package:parliament_app/src/features/safety_tools/presentations/blocs/geofence_state.dart';
import 'package:parliament_app/src/features/safety_tools/presentations/widgets/custom_switch.dart';
import 'package:parliament_app/src/features/safety_tools/presentations/widgets/radius_slider.dart';
// import 'package:location/location.dart' as loc;

class GeoFenceSetupScreen extends StatefulWidget {
  const GeoFenceSetupScreen({super.key});

  @override
  State<GeoFenceSetupScreen> createState() => _GeoFenceSetupScreenState();
}

class _GeoFenceSetupScreenState extends State<GeoFenceSetupScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  double _radiusValue = 50.0; // Default radius in meters
  bool _alertOnEntry = true;
  bool _alertOnExit = true;
  final _zoneNameController = TextEditingController();
  bool _isLocationLoaded = false; // Flag to track if location is loaded

  @override
  void initState() {
    super.initState();
    _setInitialLocation();
  }

  Future<void> _setInitialLocation() async {
    // final loc.Location location = loc.Location();
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
              radius: _radiusValue * 10, // Convert slider value to meters
              fillColor: AppColors.primaryLightGreen.withOpacity(0.3),
              strokeColor: AppColors.primaryLightGreen,
              strokeWidth: 2,
            ),
          }
        : {};
  }

  void _showSetupBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(243, 246, 247, 252),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20.0)),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 25),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 5,
                            margin: const EdgeInsets.only(bottom: 16.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(2.5),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                setModalState(() {
                                  _zoneNameController.clear();
                                });
                                setState(() {});
                              },
                              icon: SvgPictureWidget(
                                  path: "assets/icons/delete.svg"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const TextWidget(
                          text: 'Zone Name',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        const SizedBox(height: 8),
                        CustomInputField(
                          controller: _zoneNameController,
                          hintText: 'Enter Zone Name',
                          label: "Zone",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Colors.black, width: 1),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const TextWidget(
                          text: 'Radius',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        CustomRadiusSlider(
                          value: _radiusValue,
                          onChanged: (value) {
                            setModalState(() {
                              _radiusValue = value;
                            });
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomSwitchTile(
                          title: "Alert on Entry",
                          value: _alertOnEntry,
                          onChanged: (value) {
                            setModalState(() {
                              _alertOnEntry = value;
                            });
                          },
                        ),
                        CustomSwitchTile(
                          title: 'Alert on Exit',
                          value: _alertOnExit,
                          onChanged: (value) {
                            setModalState(() {
                              _alertOnExit = value;
                            });
                            setState(() {});
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
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_selectedLocation != null) {
                                    context.read<GeofenceBloc>().add(
                                          CreateGeofenceEvent(
                                            GeofenceEntity(
                                              name: _zoneNameController.text,
                                              lat: _selectedLocation!.latitude,
                                              lng: _selectedLocation!.longitude,
                                              radius: _radiusValue * 10,
                                              alertOnEntry: _alertOnEntry,
                                              alertOnExit: _alertOnExit,
                                            ),
                                          ),
                                        );
                                  }
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
                                  text: 'Submit',
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

    for (var g in geofences) {
      final lat = g['center']['lat'];
      final lng = g['center']['lng'];
      final radius = (g['radius'] ?? 300).toDouble();
      circles.add(Circle(
        circleId: CircleId("geo_$lat$lng"),
        center: LatLng(lat, lng),
        radius: radius,
        fillColor: Colors.green.withOpacity(0.3),
        strokeColor: Colors.green,
        strokeWidth: 2,
      ));
    }

    setState(() => _zoneCircles = circles);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GeofenceBloc, GeofenceState>(
      listener: (context, state) async {
        if (state is GeofenceSuccess) {
          Navigator.pop(context); // close bottom sheet
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Geofence created successfully')),
          );
          final user = await LocalStorage.getUser();
          if (user != null) {
            context.read<DashboardBloc>().add(
                  FetchDasboard(parentId: user.userId.toString()),
                );
          }
        } else if (state is GeofenceErrorState) {
          Navigator.pop(context); // close bottom sheet
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
            text: 'GeoFence Setup',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
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
                        print('object');
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
      ),
    );
  }
}
