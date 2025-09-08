import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

typedef GoogleMapControllerCallback = void Function(GoogleMapController controller);
typedef OnLocationSelected = void Function(LatLng selectedLatLng);

class ChildGoogleMapWidget extends StatefulWidget {
  final GoogleMapControllerCallback onMapCreated;
  final LatLng initialPosition;
  final OnLocationSelected onLocationSelected;
  final Set<Marker> markers;
  final Set<Circle> circles;

  const ChildGoogleMapWidget({
    super.key,
    required this.onMapCreated,
    required this.initialPosition,
    required this.onLocationSelected,
    this.markers = const {},
    this.circles = const {},
  });

  @override
  State<ChildGoogleMapWidget> createState() => _ChildGoogleMapWidgetState();
}

class _ChildGoogleMapWidgetState extends State<ChildGoogleMapWidget> {
  LatLng? _selectedLatLng;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: widget.onMapCreated,
      initialCameraPosition: CameraPosition(
        target: widget.initialPosition,
        zoom: 13.0,
      ),
      markers: {...widget.markers, if (_selectedLatLng != null)
        Marker(
          markerId: const MarkerId("selected-location"),
          position: _selectedLatLng!,
        )
      },
      circles: widget.circles,
      onTap: (LatLng latLng) {
        setState(() {
          _selectedLatLng = latLng;
        });
        widget.onLocationSelected(latLng); // Pass the selected location to parent
      },
      zoomGesturesEnabled: true,
      scrollGesturesEnabled: true,
      rotateGesturesEnabled: true,
      tiltGesturesEnabled: true,
      myLocationButtonEnabled: true,
    );
  }
}