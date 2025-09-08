// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SafetyToolsMap extends StatefulWidget {
  const SafetyToolsMap({super.key});

  @override
  State<SafetyToolsMap> createState() => _SafetyToolsMapState();
}

class _SafetyToolsMapState extends State<SafetyToolsMap> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  double _radius = 100.0; // Default radius in meters
  final TextEditingController _zoneNameController = TextEditingController();
  bool _alertOnEntry = false;
  bool _alertOnExit = false;

  @override
  void dispose() {
    _zoneNameController.dispose();
    super.dispose();
  }

  void _onMapTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Set<Circle> _getCircles() {
    return _selectedLocation != null
        ? {
            Circle(
              circleId: const CircleId('geofence'),
              center: _selectedLocation!,
              radius: _radius,
              fillColor: Colors.green.withOpacity(0.3),
              strokeColor: Colors.green,
              strokeWidth: 2,
            ),
          }
        : {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Geofence Setup'),
        backgroundColor: Colors.blue[100],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(33.5186, -86.8104), // Birmingham, AL
                    zoom: 14.0,
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
                  circles: _getCircles(),
                  zoomGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  rotateGesturesEnabled: true,
                  tiltGesturesEnabled: true,
                  myLocationButtonEnabled: true,
                ),
                if (_selectedLocation != null)
                  Center(
                    child: Icon(
                      Icons.location_pin,
                      size: 40,
                      color: Colors.red.withOpacity(0.7),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Zone Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: _zoneNameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Zone Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Radius',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: _radius,
                    min: 50.0,
                    max: 500.0,
                    divisions: 9,
                    label: '${_radius.round()} m',
                    onChanged: (value) {
                      setState(() {
                        _radius = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Alert on Entry'),
                      Switch(
                        value: _alertOnEntry,
                        onChanged: (value) {
                          setState(() {
                            _alertOnEntry = value;
                          });
                        },
                        activeColor: Colors.green,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Alert on Exit'),
                      Switch(
                        value: _alertOnExit,
                        onChanged: (value) {
                          setState(() {
                            _alertOnExit = value;
                          });
                        },
                        activeColor: Colors.green,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Handle submit logic (e.g., save geofence data)
                          print('Zone Name: ${_zoneNameController.text}, Radius: $_radius, '
                              'Alert on Entry: $_alertOnEntry, Alert on Exit: $_alertOnExit');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}