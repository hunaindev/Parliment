import 'package:flutter/foundation.dart'; // ✅ Add this
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  final List<LatLng> locations;

  const GoogleMapScreen({super.key, required this.locations});

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  GoogleMapController? mapController;

  Set<Marker> _markers = {};

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
        markers: _markers,
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
