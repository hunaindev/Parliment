// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:parliament_app/src/core/services/location_service.dart';
// import 'package:parliament_app/src/features/home/cubit/child_location_cubit.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/location/location_cubit.dart';
import 'package:parliament_app/src/features/home/presentation/widgets/google_map_screen.dart';

class LiveLocationWidget extends StatefulWidget {
  const LiveLocationWidget({super.key});

  @override
  State<LiveLocationWidget> createState() => _LiveLocationWidgetState();
}

class _LiveLocationWidgetState extends State<LiveLocationWidget> {
  @override
  void initState() {
    super.initState();
    // Start listening to locations when widget is created
    context.read<ChildLocationCubit>().listenToChildLocations();
    _loadCurrentLocation();
  }

  LocationData? _fallbackLocation;
  Future<void> _loadCurrentLocation() async {
    final loc = await LocationService().getCurrentLocation();
    if (mounted) {
      setState(() {
        _fallbackLocation = loc!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChildLocationCubit, List<ChildInfo>>(
      builder: (context, children) {
        // Extract only valid locations from the children
        final locations = children
            .where((child) => child.location != null)
            .map((child) => child.location!)
            .toList();
        print("locations: ${locations}");
        return Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: AbsorbPointer(
            absorbing: false,
            child: _fallbackLocation == null
                ? Center(child: CircularProgressIndicator())
                : GoogleMapScreen(
                    locations: locations.isEmpty
                        ? [
                            LatLng(_fallbackLocation!.latitude!,
                                _fallbackLocation!.longitude!)
                          ]
                        : locations,
                  ),
          ),
        );
      },
    );
  }
}
