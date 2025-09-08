import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/location/location_cubit.dart';
// import 'package:parliament_app/src/features/home/presentation/widgets/child_status_section.dart';
// import 'package:parliament_app/src/features/home/presentation/widgets/child_status_section.dart'; // Assuming ChildInfo model lives here
import 'package:firebase_database/firebase_database.dart';

class ParentFirestoreService {
  final _locationUpdateController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get locationUpdateStream =>
      _locationUpdateController.stream;

  final Map<String, StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>
      _childSubscriptions = {};

  /// Listen for real-time updates to child locations under the parentId node
  Stream<List<ChildInfo>> listenToChildLocations(String parentId) {
    print("Listening to child location updates...");
    final ref = FirebaseDatabase.instance
        .ref('locations/$parentId/children')
        .orderByChild('timestamp'); // 🔥 ORDER BY TIMESTAMP

    return ref.onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null || data is! Map) return [];

      final childrenMap = Map<String, dynamic>.from(data);

      return childrenMap.entries.map((entry) {
        final childData = Map<String, dynamic>.from(entry.value);
        print("childData $childData");
        return ChildInfo(
          id: entry.key,
          name: childData['childName'] ?? '',
          image: childData['childImg'] ?? '',
          location: LatLng(
            (childData['latitude'] ?? 0.0) * 1.0,
            (childData['longitude'] ?? 0.0) * 1.0,
          ),
          isOnline: childData['isOnline'] ?? false,
        );
      }).toList();
    });
  }

  void dispose() {
    for (var sub in _childSubscriptions.values) {
      sub.cancel();
    }
    _childSubscriptions.clear();
    _locationUpdateController.close();
  }
}
