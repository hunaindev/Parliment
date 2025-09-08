import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:parliament_app/src/core/config/local_storage.dart';
import 'package:permission_handler/permission_handler.dart';

getFCMToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permissions (required on iOS)
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    String? token = await messaging.getToken();
    print("Device Token: $token");
    return token;
    // You can now send this token to your backend
  } else {
    print("Permission declined");
  }
}

Future<void> requestNotificationPermission() async {
  final status = await Permission.notification.status;

  if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
    final result = await Permission.notification.request();

    if (result.isGranted) {
      await LocalStorage.setDeviceToken();
      print("🔔 Notification permission granted");
    } else {
      print("❌ Notification permission denied");
    }
  } else {
    // await LocalStorage.setDeviceToken();
    print("✅ Notification permission already granted");
  }
}

Future<void> requestPermissions() async {
  await Permission.location.request();
  await Permission.locationAlways.request();
}
