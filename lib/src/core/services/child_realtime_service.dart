// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:location/location.dart';

class ChildRealtimeService {
  Future<void> sendLocationToRealtimeDatabase(
    LocationData location,
    String childId,
    String childName,
    String childImg,
    String parentId,
  ) async {
    print("📡 Sending update to Firebase Realtime Database...");

    // if (childId.isEmpty || parentId.isEmpty) return;
    // if (location.isEmpty || parentId.isEmpty) return;
    if (location.toString().isEmpty ||
        childId.isEmpty ||
        childName.isEmpty ||
        // childImg.isEmpty ||
        parentId.isEmpty) {
      print("required fields");
      return;
    }

    try {
      final childRef = await FirebaseDatabase.instance
          .ref('locations/$parentId/children/$childId');

      await childRef.set({
        'childId': childId,
        'parentId': parentId,
        'childName': childName,
        'childImg': childImg,
        'latitude': location.latitude,
        'longitude': location.longitude,
        'timestamp': DateTime.now().toIso8601String(),
        'isOnline': true,
      });

      print(
          "✅ Realtime DB Location saved: ${location.latitude}, ${location.longitude}");
    } catch (e) {
      print("❌ Error saving to Realtime DB: $e");
    }
  }

  Future<void> setChildOnline(String parentId, String childId) async {
    final DatabaseReference ref =
        FirebaseDatabase.instance.ref('locations/$parentId/children/$childId');

    await ref.update({
      'isOnline': true,
      'lastSeen': DateTime.now().toIso8601String(),
    });

    // This will set 'isOnline' to false when the connection is lost unexpectedly
    ref.onDisconnect().update({
      'isOnline': false,
      'lastSeen': DateTime.now().toIso8601String(),
    });
  }

  void setChildOffline(String parentId, String childId) {
    if (childId.isEmpty || parentId.isEmpty) return;

    FirebaseDatabase.instance
        .ref('locations/$parentId/children/$childId/isOnline')
        .set(false);
  }
}
