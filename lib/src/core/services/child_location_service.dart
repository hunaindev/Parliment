// lib/src/features/location/services/child_location_service.dart

import 'dart:convert';
import 'dart:math' as math; // Import math library
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:flutter/foundation.dart';
// import 'package:parliament_app/src/core/config/app_constants.dart';
import 'dart:async';

import 'package:parliament_app/src/core/config/app_constants.dart';
import 'package:parliament_app/src/core/services/child_realtime_service.dart';

class Geofence {
  final double latitude;
  final double longitude;
  final double radius;
  final bool alertOnEntry;
  final bool alertOnExit;

  Geofence({
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.alertOnEntry,
    this.alertOnExit = false,
  });
}

class ChildLocationService {
  final Location _location = Location();
  StreamSubscription<LocationData>? _locationSubscription;
  StreamSubscription<LocationData>? _notificationSubscription;
  final ChildRealtimeService _childRealtimeService = ChildRealtimeService();
  LocationData? _previousLocation;

  // State for application-level filtering
  DateTime? _lastNotificationTime;
  double? _lastLat;
  double? _lastLng;

  // --- NEW: Public getter to expose the location stream ---
  // This is what your ChildMapScreen will listen to.
  Stream<LocationData> get onLocationChanged => _location.onLocationChanged;
  final Map<Geofence, bool> _geofenceStates = {};
  bool _hasNotifiedRestrictedZone = false;

  // --- NEW: Initialization method for permissions and settings ---
  // This should be called once before listening to the stream.
  // Future<bool> initialize() async {
  //   bool serviceEnabled = await _location.serviceEnabled();
  //   if (!serviceEnabled) {
  //     serviceEnabled = await _location.requestService();
  //     if (!serviceEnabled) return false;
  //   }

  //   PermissionStatus permissionGranted = await _location.hasPermission();
  //   if (permissionGranted == PermissionStatus.denied) {
  //     permissionGranted = await _location.requestPermission();
  //     if (permissionGranted != PermissionStatus.granted) {
  //       return false;
  //     }
  //   }

  //   await _location.enableBackgroundMode(enable: true);
  //   await _location.changeSettings(
  //     accuracy: LocationAccuracy.high,
  //     interval: 10000, // 10 seconds
  //     distanceFilter: 10, // 10 meters
  //   );

  //   return true; // Indicates setup was successful
  // }

  Future<bool> initialize() async {
    // 1️⃣ Ensure location service is enabled
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        debugPrint('❌ User did not enable location services.');
        return false;
      }
    }

    // 2️⃣ Request foreground permission
    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        debugPrint('❌ Foreground location permission not granted.');
        return false;
      }
    }

    debugPrint('✅ Foreground location granted.');

    // 3️⃣ Attempt to enable background mode safely
    try {
      bool bgEnabled = await _location.enableBackgroundMode(enable: true);
      if (bgEnabled) {
        debugPrint('✅ Background mode enabled.');
      } else {
        debugPrint('⚠️ User denied background → continue with foreground.');
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint('⚠️ User denied background → continue with foreground.');
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        debugPrint(
            '⚠️ Background denied forever → open app settings for manual enable.');
        // Optionally, open settings:
        // await AppSettings.openAppSettings(type: AppSettingsType.location);
      } else {
        debugPrint('❌ Unexpected background error: ${e.code} - ${e.message}');
      }
    }

    // 4️⃣ Configure location tracking (works in foreground regardless)
    await _location.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 10000,
      distanceFilter: 10,
    );

    debugPrint('✅ Location Service Initialized and Configured.');
    return true;
  }

  /// Fetches the current location of the child once (not a stream).
  Future<LocationData> getLocation() async {
    try {
      final locationData = await _location.getLocation();

      if (locationData.latitude == null || locationData.longitude == null) {
        throw Exception("Failed to retrieve location.");
      }

      debugPrint(
          "📍 Current location fetched: ${locationData.latitude}, ${locationData.longitude}");

      return locationData;
    } catch (e) {
      debugPrint("❌ Error getting current location: $e");
      rethrow;
    }
  }

  Future<void> startTracking({
    required String childId,
    required String parentDeviceToken,
    required List<Geofence> geofences,
    required List<Geofence> restricted_zones,
    // required int radiusMeters,
    required String childName,
    required String childImage,
    required String parentId,
  }) async {
    // Ensure any previous tracking is stopped before starting a new one
    await stopTracking();
    // Initialize the state for all geofences and zones to 'false' (outside)
    for (var geofence in [...geofences, ...restricted_zones]) {
      _geofenceStates[geofence] = false;
    }

    _locationSubscription =
        _location.onLocationChanged.listen((currentLocation) async {
      // ----------------- ROBUSTNESS: Add a try-catch block -----------------
      try {
        if (childId.isEmpty) return;
        // Send location only if moved significantly
        if (_previousLocation == null ||
            _calculateDistance(
                  _previousLocation!.latitude!,
                  _previousLocation!.longitude!,
                  currentLocation.latitude!,
                  currentLocation.longitude!,
                ) >
                50) {
          _previousLocation = currentLocation;

          // Handle geofence logic here if needed

          _childRealtimeService.sendLocationToRealtimeDatabase(
            currentLocation,
            childId,
            childName,
            childImage,
            parentId,
          );

          print(
              "📡 Location sent: \${currentLocation.latitude}, \${currentLocation.longitude}");
        } else {
          print("📍 Location unchanged, not sending.");
        }

        final double currentLat = currentLocation.latitude ?? 0.0;
        final double currentLng = currentLocation.longitude ?? 0.0;

        print("currentLat: ${currentLat} \n currentLng: ${currentLng}");

        // Check for geofence violation
        for (final geofence in geofences) {
          _checkGeofenceAndNotify(
            geofence,
            currentLat,
            currentLng,
            parentDeviceToken,
            childId,
            parentId,
            isRestricted: false,
          );
        }

        // --- REFACTORED AND CORRECTED: Check restricted zones ---
        // This now uses the SAME stateful logic as the regular geofences.
        for (final zone in restricted_zones) {
          _checkGeofenceAndNotify(
            zone,
            currentLat,
            currentLng,
            parentDeviceToken,
            childId,
            parentId,
            isRestricted: true,
          );
        }
      } catch (e, stackTrace) {
        // This will catch any error inside the listener and print it,
        // without killing your stream subscription.
        debugPrint(
            "-------------------❌----------------------- An error occurred in location listener: -------------------❌----------------------- $e");
        debugPrint("Stack trace: $stackTrace");
      }
    });
    debugPrint("✅ Location tracking started.");
  }

  /// Helper method to correctly check a single geofence/zone and send notifications.
  /// This method is STATEFUL.
  Future<void> _checkGeofenceAndNotify(
      Geofence geofence,
      double currentLat,
      double currentLng,
      String parentDeviceToken,
      String childId,
      String parentId,
      {required bool isRestricted}) async {
    final distance = _calculateDistance(
      geofence.latitude,
      geofence.longitude,
      currentLat,
      currentLng,
    );

    final bool isInsideNow = distance <= geofence.radius;
    // Get the previous state from our map. Default to 'false' if not found.
    final bool wasInside = _geofenceStates[geofence] ?? false;

    // This is the correct logic: only proceed if the state has CHANGED.
    if (isInsideNow != wasInside) {
      // Update the state in our map for the next check.
      _geofenceStates[geofence] = isInsideNow;

      // Logic for entering a zone
      if (isInsideNow && geofence.alertOnEntry) {
        debugPrint(
            "📥 Entered ${isRestricted ? 'RESTRICTED' : 'geofence'} area. Firing notification.");
        await _notifyParent(
          parentDeviceToken,
          title: isRestricted ? "Restricted Zone Alert" : "Geofence Alert",
          body:
              "Your child has entered a ${isRestricted ? 'restricted' : 'monitored'} area.",
          senderId: childId,
          recieverId: parentId,
        );
      }
      // Logic for exiting a zone
      else if (!isInsideNow && geofence.alertOnExit) {
        debugPrint("📤 Exited ${'geofence'} area. Firing notification.");

        // debugPrint(
        //     "📤 Exited ${isRestricted ? 'RESTRICTED' : 'geofence'} area. Firing notification.");
        await _notifyParent(
          parentDeviceToken,
          title: "Geofence Alert",
          body: "Your child has left a geofenced area.",
          senderId: childId,
          recieverId: parentId,
        );
      }
    }
  }

  Future<void> stopTrackingForNotifications() async {
    await _notificationSubscription?.cancel();
    _notificationSubscription = null;
  }

  Future<void> stopTracking() async {
    await _locationSubscription?.cancel();
    _locationSubscription = null;
    _geofenceStates.clear();
    _hasNotifiedRestrictedZone = false;

    debugPrint("Location tracking stopped.");
  }

  Future<void> _notifyParent(String deviceToken,
      {required String title,
      required String body,
      required String senderId,
      required String recieverId}) async {
    try {
      print("deviceToken $deviceToken");
      // IMPORTANT: Use a secure way to store and access your server URL.
      // Do not hardcode IP addresses in production code.
      final response = await http.post(
        Uri.parse('$baseUrl/api/send-notification'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "deviceToken": deviceToken,
          "title": title,
          "body": body,
          "senderId": senderId,
          "recieverId": recieverId,
        }),
      );

      debugPrint("🔔 Notification sent: ${response.statusCode}");
      debugPrint("🔔 Notification Body: ${response.body.toString()}");
    } catch (e) {
      debugPrint("❌ Failed to send notification: $e");
    }
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371000; // Earth radius in meters
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = (math.sin(dLat / 2) * math.sin(dLat / 2)) +
        math.cos(_deg2rad(lat1)) *
            math.cos(_deg2rad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    print("a values the i get: $a");
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return R * c;
  }

  double _deg2rad(double deg) => deg * (math.pi / 180.0);
}
