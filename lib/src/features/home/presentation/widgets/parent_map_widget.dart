import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ParentMapWidget extends StatelessWidget {
  final List<LatLng> locations;
  final Set<Circle> circles;
  final Set<Marker> offenderMarker;
  final void Function(GoogleMapController)? onMapCreated;

  const ParentMapWidget(
      {super.key,
      required this.locations,
      this.onMapCreated,
      required this.circles,
      required this.offenderMarker});

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = locations
        .map((loc) => Marker(markerId: MarkerId(loc.toString()), position: loc))
        .toSet();

    return GoogleMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: CameraPosition(
        target: locations.first,
        zoom: 13,
      ),
      circles: circles,
      markers: {...markers, ...offenderMarker},
      zoomGesturesEnabled: true,
      scrollGesturesEnabled: true,
      rotateGesturesEnabled: true,
      tiltGesturesEnabled: true,
      myLocationButtonEnabled: true,
    );
  }
}
