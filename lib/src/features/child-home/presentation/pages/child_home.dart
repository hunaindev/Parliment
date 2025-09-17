// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:location/location.dart';
import 'package:parliament_app/main.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/config/local_storage.dart';
// import 'package:parliament_app/src/core/services/child_firestore_service.dart';
import 'package:parliament_app/src/core/services/child_location_service.dart';
import 'package:parliament_app/src/core/widgets/main_scaffold.dart';
import 'package:parliament_app/src/features/auth/presentation/blocs/user_cubit.dart';
// import 'package:parliament_app/src/features/child-home/data/models/child_dashboard_model.dart';
import 'package:parliament_app/src/features/child-home/domain/repositories/child_dashboard_repository.dart';
// import 'package:parliament_app/src/features/child-home/data/repositories/child_dashboard_repository.dart';
import 'package:parliament_app/src/features/child-home/presentation/pages/child_dashboard.dart';
import 'package:parliament_app/src/features/child-home/presentation/pages/child_map_screen.dart';
import 'package:parliament_app/src/features/child-home/presentation/pages/child_profile.dart';
import 'package:parliament_app/src/features/child-home/presentation/widgets/child_bottom_widget.dart';

class ChildHomeScreen extends StatefulWidget {
  final bool refreshDashboard;
  const ChildHomeScreen({super.key, this.refreshDashboard = false});

  @override
  State<ChildHomeScreen> createState() => _ChildHomeScreenState();
}

class _ChildHomeScreenState extends State<ChildHomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int selectedIndex = 0;
  // late final ChildRealtimeService _childRealtimeService;
  List geofences = [];
  List restrictedZones = [];
  // late final Location _location;
  // StreamSubscription<LocationData>? _locationSubscription;
  // StreamSubscription<LocationData>? _locationSubscription;
  // LocationData? _previousLocation;

  // String _childId = "";
  String _parentId = "";
  String _name = "";
  String _child_img = "";
  bool isReadZone = false;

  onTap(index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    // _childRealtimeService = ChildRealtimeService();
    // _location = Location();
    _initialize();
  }

  void _initialize() async {
    print("child home initliazed");
    final user = await LocalStorage.getUser();
    final userId = user?.userId ?? "";
    final parentId = user?.parentId ?? "";
    final child_img = user?.image ?? "";
    final name = user?.name ?? "";

    if (userId.isNotEmpty) {
      // _childId = userId;
      _parentId = parentId;
      _child_img = child_img;
      _name = name;
    }

    // If refreshDashboard is true, always fetch dashboard and start tracking
    if (!_isDashboardLoaded || widget.refreshDashboard) {
      await _initializeDashboardAndTracking();
    }
  }

  bool _isDashboardLoaded = false;

  Future<void> _initializeDashboardAndTracking() async {
    final user = await LocalStorage.getUser();
    if (user == null) return;

    context.read<UserCubit>().setUser(user);

    final userId = user.userId;
    final parentDeviceToken = user.parentDeviceToken;

    try {
      final repo = getIt<ChildDashboardRepository>();
      final dashboardData = await repo.fetchDasboard(userId: userId.toString());
      setState(() {
        geofences = dashboardData.geofences.toList();
        restrictedZones = dashboardData.restricted_zones.toList();
        _isDashboardLoaded = true; // mark as loaded
      });

      await getIt<ChildLocationService>()
          .startTracking(
              childId: userId.toString(),
              parentDeviceToken: parentDeviceToken.toString(),
              geofences: geofences
                  .map((g) => Geofence(
                      latitude: g['center']?['lat'] ?? 0.0,
                      longitude: g['center']?['lng'] ?? 0.0,
                      radius: (g['radius'] ?? 0).toDouble(),
                      alertOnEntry: g['alertOnEntry'],
                      alertOnExit: g['alertOnExit']))
                  .toList(),
              restricted_zones: restrictedZones
                  .map((g) => Geofence(
                      latitude: g['latitude'] ?? 0.0,
                      longitude: g['longitude'] ?? 0.0,
                      radius: (g['radius'] ?? 0).toDouble(),
                      alertOnEntry: g['alertOnEntry']))
                  .toList(),
              childName: _name,
              childImage: _child_img,
              parentId: _parentId,
              onCallBack: (isReadZone1) {
                if (isReadZone1) {
                  setState(() {
                    isReadZone = isReadZone1;
                  });
                } else {
                  setState(() {
                    isReadZone = false;
                  });
                }
              })
          .then((j) {});
    } catch (e) {
      print("Error initializing dashboard and tracking: $e");
    }
  }

  // double _calculateDistance(
  //     double lat1, double lon1, double lat2, double lon2) {
  //   const earthRadius = 6371000; // in meters

  //   final dLat = _degreesToRadians(lat2 - lat1);
  //   final dLon = _degreesToRadians(lon2 - lon1);

  //   final a = sin(dLat / 2) * sin(dLat / 2) +
  //       cos(_degreesToRadians(lat1)) *
  //           cos(_degreesToRadians(lat2)) *
  //           sin(dLon / 2) *
  //           sin(dLon / 2);
  //   final c = 2 * atan2(sqrt(a), sqrt(1 - a));

  //   return earthRadius * c;
  // }

  // double _degreesToRadians(double degree) {
  //   return degree * pi / 180;
  // }

  @override
  void dispose() {
    _controller.dispose();
    // _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      isMapScreen: selectedIndex == 1,
      body: _buildBody(),
      bottomNavigationBar: ChildBottomNavigationWidget(
        selectedIndex: selectedIndex,
        onTap: onTap,
      ),
    );
  }

  Widget _buildBody() {
    if (!_isDashboardLoaded) {
      return const Center(
          child: CircularProgressIndicator(
        color: AppColors.primaryLightGreen,
      ));
    }
    switch (selectedIndex) {
      case 0:
        return ChildDashboard(isReadZone: isReadZone);
      case 1:
        return ChildMapScreen(
          geofences: geofences,
          restrictedZones: restrictedZones,
        );
      case 2:
        return ChildProfileScreen();
      default:
        return ChildDashboard(isReadZone: isReadZone);
    }
  }
}
