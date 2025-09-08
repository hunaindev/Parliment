import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:parliament_app/src/core/services/child_location_service.dart';
import 'package:parliament_app/src/features/child-home/data/remote_data_source/remote_data_source.dart';
import 'package:parliament_app/src/core/widgets/map_search_bar.dart';
import 'package:parliament_app/src/features/child-home/presentation/blocs/dashboard/child_dashboard_bloc.dart';
import 'package:parliament_app/src/features/child-home/presentation/widgets/child_google_map.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChildMapScreen extends StatefulWidget {
  final List geofences;
  final List restrictedZones;

  const ChildMapScreen({
    super.key,
    required this.geofences,
    required this.restrictedZones,
  });

  @override
  State<ChildMapScreen> createState() => _ChildMapScreenState();
}

class _ChildMapScreenState extends State<ChildMapScreen> {
  final ChildLocationService _locationService = ChildLocationService();
  final OffenderService _offenderService = OffenderService();
  late StreamSubscription<LocationData> _locationSubscription;

  GoogleMapController? _mapController;
  Marker? _childLocationMarker;
  Set<Marker> _offenderMarkers = {};
  Set<Circle> _zoneCircles = {};

  LatLng? _currentLocation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startListeningToLocation(); // 👈 Add this

    _initializeLocationAndMap();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _locationService.stopTracking(); // 👈 Cancel the stream properly

    super.dispose();
  }

  Future<void> _initializeLocationAndMap() async {
    final granted = await _locationService.initialize();
    if (!granted) {
      _showSnackbar("Location permission is required.");
      return;
    }
    final dashboardBloc = context.read<ChildDashboardBloc>();

    double lat = dashboardBloc.currentLat;
    double lng = dashboardBloc.currentLng;

    // final location = await _locationService.getLocation();
    final latLng = LatLng(lat, lng);
    print(" 📥widget.geofences ${widget.geofences}");
    print("latLng:  ${latLng}");
    setState(() {
      _currentLocation = latLng;
    });

    _updateChildMarker(latLng);
    _renderZones(widget.geofences, widget.restrictedZones);
    // _fetchNearbyOffenders(latLng);
  }

  DateTime? _lastUpdateTime;

  void _startListeningToLocation() {
    _locationSubscription =
        _locationService.onLocationChanged.listen((locationData) {
      if (!mounted) return; // ✅ prevent setState after dispose
      if (locationData.latitude != null && locationData.longitude != null) {
        final updatedLatLng = LatLng(
          locationData.latitude!,
          locationData.longitude!,
        );

        // ✅ Always update map and marker immediately
        setState(() {
          _currentLocation = updatedLatLng;
          _updateChildMarker(updatedLatLng);
        });

        // ✅ Always move camera to follow child
        _mapController?.animateCamera(
          CameraUpdate.newLatLng(updatedLatLng),
        );

        // 🕒 Only fetch offenders every 2 minutes
        final now = DateTime.now();
        if (_lastUpdateTime == null ||
            now.difference(_lastUpdateTime!).inMinutes >= 2) {
          _lastUpdateTime = now;
          _fetchNearbyOffenders(updatedLatLng);
        }

        print("Live location: $updatedLatLng");
      }
    });
  }

  Future<void> _fetchNearbyOffenders(LatLng location) async {
    setState(() => _isLoading = true);
    try {
      final offenders = await _offenderService.getNearbyOffenders(
        lat: location.latitude,
        lng: location.longitude,
      );
      final markers = offenders.map((offender) {
        return Marker(
          markerId: MarkerId(offender.id),
          position: LatLng(offender.latitude, offender.longitude),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
          infoWindow: InfoWindow(title: offender.name),
        );
      }).toSet();
      setState(() => _offenderMarkers = markers);
    } catch (e) {
      _showSnackbar("Failed to load nearby offenders.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _updateChildMarker(LatLng position) {
    setState(() {
      _childLocationMarker = Marker(
        markerId: const MarkerId("child_location"),
        position: position,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: const InfoWindow(title: "Your Location"),
      );
    });
  }

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

  void _showSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top + 40.0;
    final markers = {
      if (_childLocationMarker != null) _childLocationMarker!,
      ..._offenderMarkers
    };

    return Scaffold(
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : Stack(
              children: [
                ChildGoogleMapWidget(
                  onMapCreated: (controller) {
                    _mapController = controller;
                    controller.animateCamera(
                        CameraUpdate.newLatLngZoom(_currentLocation!, 14));
                  },
                  onLocationSelected: (_) {},
                  markers: markers,
                  circles: _zoneCircles,
                  initialPosition: _currentLocation!,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, topPadding, 16.0, 0),
                  child: MapSearchBar(onResult: (latLng) {
                    _mapController
                        ?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 14));
                  }),
                ),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(color: Colors.green),
                  ),
              ],
            ),
    );
  }
}
