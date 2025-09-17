import 'package:flutter/foundation.dart'; // ✅ Add this
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  final List<LatLng> locations;
  final List<LatLng> offenderLocations;

  const GoogleMapScreen(
      {super.key, required this.locations, required this.offenderLocations});

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  GoogleMapController? mapController;

  Set<Marker> _markers = {};
  Set<Marker> _markers1 = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setMarkersFromLocations();
  }

  @override
  void didUpdateWidget(covariant GoogleMapScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.locations != oldWidget.locations) {
      _setMarkersFromLocations();
      _setMarkersFromOffenderLocations();
    }
  }

  void _setMarkersFromLocations() {
    final markers = widget.locations.asMap().entries.map((entry) {
      final index = entry.key;
      final location = entry.value;
      print("location to show marker: ${location}");
      return Marker(
        markerId: MarkerId('marker_$index'),
        position: location,
        infoWindow: InfoWindow(title: 'Location ${index + 1}'),
      );
    }).toSet();

    setState(() {
      _markers = markers;
    });
    // Animate camera to the first location if available
    if (widget.locations.isNotEmpty && mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLng(widget.locations.first),
      );
    }
  }

  void _setMarkersFromOffenderLocations() {
    final markers = widget.offenderLocations.asMap().entries.map((entry) {
      final index = entry.key;
      final location = entry.value;

      return Marker(
        markerId: MarkerId('offender_$index'),
        position: location,
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueMagenta), // Or use your own
        infoWindow: InfoWindow(
          title: 'Offender ${index + 1}',
          snippet: 'Suspicious activity area',
        ),
      );
    }).toSet();

    print(markers.length);

    setState(() {
      _markers1 = markers;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: widget.locations.isNotEmpty
              ? widget.locations.first
              : const LatLng(0, 0),
          zoom: 11.0,
        ),
        markers: {..._markers, ..._markers1},
        gestureRecognizers: {
          Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
        },
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        rotateGesturesEnabled: true,
        tiltGesturesEnabled: true,
        myLocationButtonEnabled: false,
      ),
    );
  }
}
