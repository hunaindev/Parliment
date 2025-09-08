import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parliament_app/src/core/services/location_service.dart';
import 'package:parliament_app/src/features/home/domain/repositories/dashboard_repository.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/dashboard/dashboard_event.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/dashboard/dashboard_state.dart';
import 'package:location/location.dart' as loc;

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository repository;

  List _childrens = [];
  List get allChildren => _childrens;

  List _geofences = [];
  List get allGeofences => _geofences;

  List _redzone = [];
  List get redzone => _redzone;

  List _notification = [];
  List get notfication => _notification;

  double _lat = 0.0;
  double _lng = 0.0;

  double get currentLat => _lat;
  double get currentLng => _lng;
  StreamSubscription? _subscription;

  DashboardBloc({required this.repository}) : super(DashboardInitial()) {
    on<FetchDasboard>(_onFetch);
  }

  Future<void> _onFetch(
    FetchDasboard event,
    Emitter<DashboardState> emit,
  ) async {
    final loc.Location location = loc.Location();
    print("Dispatching FetchDashboard with parentId: ${event.parentId}");
    print("currentLat${currentLat}");
    try {
      if (_childrens.isEmpty && currentLat == 0.0) {
        emit(DashboardLoading());
      }
      print("Checking serviceEnabled...");
      bool serviceEnabled = await location.serviceEnabled();
      print("serviceEnabled: $serviceEnabled");

      // bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          throw Exception("Location services are disabled.");
        }
      }

      print("Checking location permission...");
      loc.PermissionStatus permissionGranted = await location.hasPermission();
      print("Permission status: $permissionGranted");
      if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) {
          throw Exception("Location permission denied.");
        }
      }

      print("Getting location...");
      final service = LocationService();
      print("Getting location... $service");
      await service.warmupLocation();
      final locationData = await service.getCurrentLocation();
      print("Getting location... $locationData ");
      if (locationData == null) {
        print("ddddddddd");
        emit(OffenderError("Failed to get location."));
        return;
      }
      final location1 = await LocationService().getCurrentLocation();
      print("Getting location..3223.");
      print(
          "Location obtained: ${location1!.latitude}, ${location1.longitude}");

      _lat = locationData.latitude ?? 0.0;
      _lng = locationData.longitude ?? 0.0;

      print("Calling repository.fetchDasboard...");
      final dashboardData =
          await repository.fetchDasboard(parentId: event.parentId);
      print("Dashboard data received");
      // print("childrenswrwefer: ${dashboardData.children[0].toJson()}");
      print("_notification: ${dashboardData.notifications}");
      _childrens = dashboardData.children; // Assuming `children` is a List
      _notification = dashboardData.notifications;
      _geofences = dashboardData.geofences;
      _redzone = dashboardData.redzone;

      print("_geofences: ${dashboardData.redzone}");

      emit(DashboardLoaded(
          children: _childrens,
          geofences: dashboardData.geofences,
          redZone: dashboardData.redzone,
          currentLocation: LatLng(_lat, _lng)));
    } catch (e) {
      print(e);
      emit(OffenderError(e.toString()));
    }
  }

  // Future<void> _onFetch(
  //   FetchDasboard event,
  //   Emitter<DashboardState> emit,
  // ) async {
  //   final loc.Location location = loc.Location();
  //   print("Dispatching FetchDashboard with parentId: ${event.parentId}");

  //   try {
  //     if (_childrens.isEmpty) {
  //       emit(DashboardLoading());
  //     }

  //     // ✅ Ensure service enabled
  //     bool serviceEnabled = await location.serviceEnabled();
  //     if (!serviceEnabled) {
  //       serviceEnabled = await location.requestService();
  //     }

  //     // ✅ Ensure permission
  //     var permissionGranted = await location.hasPermission();
  //     if (permissionGranted == loc.PermissionStatus.denied) {
  //       permissionGranted = await location.requestPermission();
  //     }

  //     if (permissionGranted != loc.PermissionStatus.granted) {
  //       print("⚠️ Location permission denied → proceeding without location");
  //     }

  //     // ✅ Try to get location with timeout
  //     final service = LocationService();
  //     final locationData = await service
  //         .getCurrentLocation()
  //         .timeout(const Duration(seconds: 10), onTimeout: () => null);

  //     if (locationData != null) {
  //       _lat = locationData.latitude ?? 0.0;
  //       _lng = locationData.longitude ?? 0.0;
  //       print("✅ Location obtained: $_lat, $_lng");
  //     } else {
  //       // Fallback default
  //       _lat = 0.0;
  //       _lng = 0.0;
  //       print("⚠️ Location not available → using default (0.0, 0.0)");
  //     }

  //     // ✅ Always fetch dashboard (location success or fail)
  //     print("Calling repository.fetchDasboard...");
  //     final dashboardData =
  //         await repository.fetchDasboard(parentId: event.parentId);

  //     _childrens = dashboardData.children;
  //     _notification = dashboardData.notifications;
  //     _geofences = dashboardData.geofences;
  //     _redzone = dashboardData.redzone;

  //     print("✅ Dashboard data received successfully");

  //     emit(DashboardLoaded(
  //       children: _childrens,
  //       geofences: dashboardData.geofences,
  //       redZone: dashboardData.redzone,
  //     ));
  //   } catch (e) {
  //     print("❌ Error in _onFetch: $e");
  //     emit(OffenderError(e.toString()));
  //   }
  // }
}
