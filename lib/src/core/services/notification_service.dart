import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:parliament_app/src/core/config/app_constants.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  void setupFirebaseHandlers() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      final android = message.notification?.android;

      debugPrint("📥 Foreground message received!");
      debugPrint("Title: ${notification?.title}");
      debugPrint("Body: ${notification?.body}");

      if (notification != null && android != null) {
        _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'channel_id',
              'channel_name',
              channelDescription: 'Your notification channel',
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });
  }

  Future<void> sendNotification(
    String deviceToken, {
    required String title,
    required String body,
  }) async {
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
        }),
      );

      debugPrint("🔔 Notification sent: ${response.statusCode}");
    } catch (e) {
      debugPrint("❌ Failed to send notification: $e");
    }
  }
}
// Subscribe to location changes
// _locationSubscription = _location.onLocationChanged.listen(
//   (LocationData currentLocation) async {
//     final lat = currentLocation.latitude;
//     final lng = currentLocation.longitude;

//     if (lat == null || lng == null) return;

//     debugPrint('📍 Tracked: $lat, $lng');

//     final distance = _calculateDistance(lat, lng, geofenceLat, geofenceLng);
//     debugPrint("📏 Distance to geofence: ${distance.toStringAsFixed(2)}m");

//     // Notify on every location change
//     await _notifyParent(
//       parentDeviceToken,
//       title: "Child Location Updated",
//       body:
//           "Lat: $lat, Lng: $lng (distance: ${distance.toStringAsFixed(1)}m)",
//     );
//   },
//   onError: (e) {
//     debugPrint("❌ Location error: $e");
//   },
// );
