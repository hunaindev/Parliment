// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:parliament_app/src/features/home/presentation/blocs/location/location_cubit.dart';
// import 'package:parliament_app/src/features/home/presentation/widgets/parent_map_widget.dart';
// import 'package:parliament_app/src/core/widgets/map_search_bar.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:location/location.dart';

// class ParentMapScreen extends StatefulWidget {
//   const ParentMapScreen({super.key});

//   @override
//   State<ParentMapScreen> createState() => _ParentMapScreenState();
// }

// class _ParentMapScreenState extends State<ParentMapScreen> {
//   GoogleMapController? _mapController;
//   LatLng? _currentLatLng;
//   bool _loadingLocation = false;

//   @override
//   void initState() {
//     super.initState();
//     context.read<ChildLocationCubit>().listenToChildLocations();
//     _getCurrentLocation();
//   }

//   void _onSearchResult(LatLng latLng) {
//     _mapController?.animateCamera(
//       CameraUpdate.newLatLngZoom(latLng, 14.0),
//     );
//   }

//   /// Get user current location using `location` package
//   Future<LatLng?> _getCurrentLocation() async {
//     setState(() => _loadingLocation = true);

//     final location = Location();

//     bool serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) {
//         setState(() => _loadingLocation = false);
//         return null;
//       }
//     }

//     PermissionStatus permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) {
//         setState(() => _loadingLocation = false);
//         return null;
//       }
//     }

//     final userLocation = await location.getLocation();
//     final latLng = LatLng(userLocation.latitude!, userLocation.longitude!);

//     setState(() {
//       _currentLatLng = latLng;
//       _loadingLocation = false;
//     });

//     // 🔥 Auto move when map ready
//     if (_mapController != null) {
//       _mapController!.animateCamera(
//         CameraUpdate.newLatLngZoom(latLng, 14.0),
//       );
//     }

//     return latLng;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double topSpace = MediaQuery.of(context).padding.top + 40.0;

//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.height,
//       color: Colors.white,
//       child: GestureDetector(
//         behavior: HitTestBehavior.opaque,
//         onTap: () => FocusScope.of(context).unfocus(),
//         child: BlocBuilder<ChildLocationCubit, List<ChildInfo>>(
//           builder: (context, children) {
//             final locations = children
//                 .where((child) => child.location != null)
//                 .map((child) => child.location!)
//                 .toList();

//             return FutureBuilder<LatLng?>(
//               future: locations.isEmpty && _currentLatLng == null
//                   ? _getCurrentLocation()
//                   : Future.value(null),
//               builder: (context, snapshot) {
//                 // LatLng defaultLocation = const LatLng(33.5186, -86.8104);

//                 final initialLocation = locations.isNotEmpty
//                     ? locations.first
//                     : _currentLatLng ?? snapshot.data;
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (locations.isEmpty &&
//                     _currentLatLng == null &&
//                     initialLocation != null) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 return Stack(
//                   children: [
//                     ParentMapWidget(
//                       locations:
//                           locations.isEmpty ? [initialLocation!] : locations,
//                       onMapCreated: (controller) {
//                         _mapController = controller;

//                         // 🔥 ensure move to current location after map created
//                         if (_currentLatLng != null) {
//                           _mapController!.animateCamera(
//                             CameraUpdate.newLatLngZoom(_currentLatLng!, 14.0),
//                           );
//                         }
//                       },
//                     ),
//                     Positioned(
//                       top: topSpace,
//                       left: 16,
//                       right: 16,
//                       child: MapSearchBar(onResult: _onSearchResult),
//                     ),
//                   ],
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/dashboard/dashboard_bloc.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/dashboard/dashboard_state.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/location/location_cubit.dart';
import 'package:parliament_app/src/features/home/presentation/widgets/parent_map_widget.dart';
import 'package:parliament_app/src/core/widgets/map_search_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';

class ParentMapScreen extends StatefulWidget {
  const ParentMapScreen({super.key});

  @override
  State<ParentMapScreen> createState() => _ParentMapScreenState();
}

class _ParentMapScreenState extends State<ParentMapScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentLatLng;
  bool _loadingLocation = false;
  Set<Circle> _zoneCircles = {};

  final LatLng _defaultLocation = const LatLng(28.6139, 77.2090); // fallback

  @override
  void initState() {
    super.initState();
    final geofences = context.read<DashboardBloc>();

    context.read<ChildLocationCubit>().listenToChildLocations();
    _fetchCurrentLocation(geofences); // ✅ ek hi dafa call hoga
  }

  void _onSearchResult(LatLng latLng) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(latLng, 14.0),
    );
  }

  Future<void> _fetchCurrentLocation(geofences) async {
    setState(() => _loadingLocation = true);

    final location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        setState(() => _loadingLocation = false);
        return;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        setState(() => _loadingLocation = false);
        return;
      }
    }

    final userLocation = await location.getLocation();
    final latLng = LatLng(userLocation.latitude!, userLocation.longitude!);

    setState(() {
      _currentLatLng = latLng;
      _loadingLocation = false;
    });

    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(latLng, 14.0),
      );
      // _renderZones(geofences.allGeofences, []);
      print(geofences.allGeofences);
    }
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

  @override
  Widget build(BuildContext context) {
    final double topSpace = MediaQuery.of(context).padding.top + 40.0;
    print(context.read<DashboardBloc>().redzone);

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: MultiBlocListener(
          listeners: [
            // ✅ Geofence listener
            BlocListener<DashboardBloc, DashboardState>(
              listenWhen: (previous, current) {
                // sirf tab chale jab geofences change ho
                if (previous is DashboardLoaded && current is DashboardLoaded) {
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
          child: BlocBuilder<ChildLocationCubit, List<ChildInfo>>(
            builder: (context, children) {
              final locations = children
                  .where((child) => child.location != null)
                  .map((child) => child.location!)
                  .toList();

              if (_loadingLocation &&
                  _currentLatLng == null &&
                  locations.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              final initialLocation = locations.isNotEmpty
                  ? locations.first
                  : _currentLatLng ?? _defaultLocation;

              return Stack(
                children: [
                  ParentMapWidget(
                    locations:
                        locations.isEmpty ? [initialLocation] : locations,
                    circles: _zoneCircles,
                    onMapCreated: (controller) {
                      _mapController = controller;
                      if (_currentLatLng != null) {
                        _mapController!.animateCamera(
                          CameraUpdate.newLatLngZoom(_currentLatLng!, 14.0),
                        );
                      }
                      // ✅ initial render when map created
                      final dashboardState = context.read<DashboardBloc>();
                      print(dashboardState.redzone);
                      _renderZones(
                          dashboardState.allGeofences, dashboardState.redzone);
                    },
                  ),
                  Positioned(
                    top: topSpace,
                    left: 16,
                    right: 16,
                    child: MapSearchBar(onResult: _onSearchResult),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   final double topSpace = MediaQuery.of(context).padding.top + 40.0;
  //   final geofences = context.read<DashboardBloc>();
  //   print(geofences.allGeofences);
  //   return Scaffold(
  //     body: GestureDetector(
  //       behavior: HitTestBehavior.opaque,
  //       onTap: () => FocusScope.of(context).unfocus(),
  //       child: BlocBuilder<ChildLocationCubit, List<ChildInfo>>(
  //         builder: (context, children) {
  //           final locations = children
  //               .where((child) => child.location != null)
  //               .map((child) => child.location!)
  //               .toList();

  //           if (_loadingLocation &&
  //               _currentLatLng == null &&
  //               locations.isEmpty) {
  //             return const Center(child: CircularProgressIndicator());
  //           }

  //           final initialLocation = locations.isNotEmpty
  //               ? locations.first
  //               : _currentLatLng ?? _defaultLocation;

  //           return Stack(
  //             children: [
  //               ParentMapWidget(
  //                 locations: locations.isEmpty ? [initialLocation] : locations,
  //                 circles: _zoneCircles,
  //                 onMapCreated: (controller) {
  //                   _mapController = controller;
  //                   if (_currentLatLng != null) {
  //                     _mapController!.animateCamera(
  //                       CameraUpdate.newLatLngZoom(_currentLatLng!, 14.0),
  //                     );
  //                   }
  //                 },
  //               ),
  //               Positioned(
  //                 top: topSpace,
  //                 left: 16,
  //                 right: 16,
  //                 child: MapSearchBar(onResult: _onSearchResult),
  //               ),
  //             ],
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }
}
