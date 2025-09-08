// lib/core/services/location_service.dart

import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:app_settings/app_settings.dart';
import 'package:geolocator/geolocator.dart' as geo;

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  final Location _location = Location();
  bool _isServiceInitialized = false;

  /// Exposes the stream of location updates from the 'location' package.
  Stream<LocationData> get onLocationChanged => _location.onLocationChanged;

  /// Initializes the service, requests all permissions, and configures tracking.
  /// Returns `true` if successful, `false` otherwise.
  Future<bool> initialize() async {
    if (_isServiceInitialized) {
      return true;
    }

    // --- 1. Ensure Location Service is ON ---
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        debugPrint('❌ User did not enable location services.');
        return false;
      }
    }

    // --- 2. Foreground Permission ---
    PermissionStatus permissionStatus = await _location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await _location.requestPermission();
    }

    if (permissionStatus == PermissionStatus.deniedForever) {
      debugPrint('❌ Foreground location denied forever → opening settings...');
      await AppSettings.openAppSettings(type: AppSettingsType.location);
      return false;
    }

    if (permissionStatus != PermissionStatus.granted) {
      debugPrint('❌ Foreground location permission not granted.');
      return false;
    }

    debugPrint('✅ Foreground location granted.');

    // --- 3. Try Background Permission (Android only) ---
    await _configureTrackingAndRequestBackground();

    _isServiceInitialized = true;
    debugPrint("✅ Location Service Initialized and Configured.");
    return true;
  }

  /// Configures tracking settings and handles background permission safely.
  Future<void> _configureTrackingAndRequestBackground() async {
    if (Platform.isAndroid) {
      try {
        // 1️⃣ Check if background permission is available (Android 10+)
        PermissionStatus bgPermission = await _location.hasPermission();

        // Only request background mode if the user has granted foreground
        if (bgPermission == PermissionStatus.granted) {
          debugPrint('Attempting to enable background mode...');
          bool bgEnabled = await _location.enableBackgroundMode(enable: true);

          if (bgEnabled) {
            debugPrint('✅ Background mode enabled.');
          } else {
            debugPrint('⚠️ Background not enabled → foreground only.');
          }
        } else {
          debugPrint(
              '⚠️ Background permission denied → using foreground only.');
        }
      } on PlatformException catch (e) {
        if (e.code == 'PERMISSION_DENIED') {
          debugPrint('⚠️ User denied background → continue with foreground.');
        } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
          debugPrint(
              '⚠️ Background denied forever → opening settings for manual enable.');
          await AppSettings.openAppSettings(type: AppSettingsType.location);
        } else {
          debugPrint('❌ Unexpected background error: ${e.code} - ${e.message}');
        }
      }
    }

    // ✅ Common config (foreground always works)
    await _location.changeSettings(
      accuracy: LocationAccuracy.balanced,
      interval: 10000, // 10 sec
      distanceFilter: 20, // 20 meters
    );

    // ✅ Android 14+ requires persistent notification for background
    await _location.changeNotificationOptions(
      channelName: 'Location Tracking',
      title: 'Safety Tracking Active',
      subtitle: 'Monitoring location for safety alerts.',
      iconName: 'mipmap/ic_launcher',
    );
  }

  /// One-time location fetch
  // Future<LocationData?> getCurrentLocation() async {
  //   try {
  //     PermissionStatus permissionStatus = await _location.hasPermission();
  //     if (permissionStatus == PermissionStatus.denied) {
  //       permissionStatus = await _location.requestPermission();
  //       if (permissionStatus != PermissionStatus.granted) {
  //         debugPrint("❌ Location permission denied.");
  //         return null;
  //       }
  //     }

  //     bool serviceEnabled = await _location.serviceEnabled();
  //     if (!serviceEnabled) {
  //       serviceEnabled = await _location.requestService();
  //       if (!serviceEnabled) {
  //         debugPrint("❌ Location service not enabled.");
  //         return null;
  //       }
  //     }

  //     debugPrint("📍 Getting current location...");
  //     final locationData = await _location.getLocation();
  //     debugPrint(
  //         "✅ Got location: ${locationData.latitude}, ${locationData.longitude}");
  //     return locationData;
  //   } catch (e) {
  //     debugPrint("❌ Error in getCurrentLocation(): $e");
  //     return null;
  //   }
  // }

  Future<void> warmupLocation() async {
    try {
      await _location.onLocationChanged.first
          .timeout(const Duration(seconds: 10));
      debugPrint("🌍 Location warmup done.");
    } catch (e) {
      debugPrint("⚠️ Warmup failed: $e");
    }
  }

  // Future<LocationData?> getCurrentLocation() async {
  //   try {
  //     PermissionStatus permissionStatus = await _location.hasPermission();
  //     if (permissionStatus == PermissionStatus.denied) {
  //       permissionStatus = await _location.requestPermission();
  //       if (permissionStatus != PermissionStatus.granted) {
  //         debugPrint("❌ Location permission denied.");
  //         return null;
  //       }
  //     }

  //     bool serviceEnabled = await _location.serviceEnabled();
  //     if (!serviceEnabled) {
  //       serviceEnabled = await _location.requestService();
  //       if (!serviceEnabled) {
  //         debugPrint("❌ Location service not enabled.");
  //         return null;
  //       }
  //     }

  //     debugPrint("📍 Getting current location...");
  //     LocationData? locationData;

  //     try {
  //       locationData =
  //           await _location.getLocation().timeout(const Duration(seconds: 5));
  //     } catch (_) {
  //       debugPrint("⚠️ getLocation() timeout, trying stream...");
  //       locationData = await _location.onLocationChanged.first
  //           .timeout(const Duration(seconds: 5));
  //     }

  //     debugPrint(
  //         "✅ Got location: ${locationData.latitude}, ${locationData.longitude}");
  //     return locationData;
  //   } catch (e) {
  //     debugPrint("❌ Error in getCurrentLocation(): $e");
  //     return null;
  //   }
  // }

  Future<LocationData?> getCurrentLocation() async {
    try {
      // Check permission
      geo.LocationPermission permission =
          await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
        if (permission == geo.LocationPermission.denied) {
          debugPrint("❌ Location permission denied.");
          return null;
        }
      }

      if (permission == geo.LocationPermission.deniedForever) {
        debugPrint("❌ Location permissions are permanently denied.");
        return null;
      }

      // Check service
      bool serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint("❌ Location services are disabled.");
        return null;
      }

      debugPrint("📍 Getting current location...");

      // Try with timeout + fallback to last known location
      try {
        final position = await geo.Geolocator.getCurrentPosition(
          desiredAccuracy: geo.LocationAccuracy.high,
          timeLimit: const Duration(seconds: 5),
        );

        debugPrint(
            "✅ Got location: ${position.latitude}, ${position.longitude}");
        return LocationData.fromMap(positionToMap(position));
      } catch (_) {
        debugPrint("⚠️ getCurrentPosition() timeout, trying last known...");
        geo.Position? position = await geo.Geolocator.getLastKnownPosition();
        return LocationData.fromMap(positionToMap(position!));
      }
    } catch (e) {
      debugPrint("❌ Error in getCurrentLocation(): $e");
      return null;
    }
  }

  Map<String, dynamic> positionToMap(geo.Position position) {
    return {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'accuracy': position.accuracy,
      'altitude': position.altitude,
      'speed': position.speed,
      'speed_accuracy': position.speedAccuracy,
      'heading': position.heading,
      'time': position.timestamp.millisecondsSinceEpoch.toDouble(),
      'isMock': position.isMocked ? 1 : 0,
      'verticalAccuracy': null, // geolocator me abhi direct nahi milta
      'headingAccuracy': null, // geolocator me direct nahi milta
      'elapsedRealtimeNanos': null,
      'elapsedRealtimeUncertaintyNanos': null,
      'satelliteNumber': null,
      'provider': "geolocator",
    };
  }
}
