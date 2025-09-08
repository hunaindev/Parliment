// import 'package:location/location.dart';
// import 'package:parliament_app/src/core/services/unused_service/socket_client.dart'; // Or whichever location package you use

// class ChildSocketService extends BaseSocketService {
//   // --- SINGLETON SETUP ---
//   // Private constructor
//   ChildSocketService._internal();

//   // The single, static instance
//   static final ChildSocketService _instance = ChildSocketService._internal();

//   // The factory constructor that returns the instance
//   factory ChildSocketService() {
//     return _instance;
//   }
//   // --- END SINGLETON SETUP ---

//   @override
//   void init({required String userId, String? parentId}) {
//     if (parentId == null || parentId.isEmpty) {
//       print("❌ Cannot initialize child socket without a parentId.");
//       return;
//     }

//     createSocketInstance();
//     socket.connect();

//     // --- FIX IS HERE ---
//     socket.on('connect', (_) {
//       print('✅ Child connected to socket, registering...');
//       socket.emit('register', {
//         'userId': userId,
//         'role': 'child',
//         'parentId': parentId,
//       });
//     });

//     // --- AND HERE ---
//     socket.on('disconnect', (_) => print('❌ Child socket disconnected'));

//     // (Optional but Recommended) Handle connection errors for debugging
//     socket.on('connect_error', (data) => print('Connection Error: $data'));
//   }

//   void sendLocationUpdate(
//       {required String childId, required LocationData location}) {
//     if (socket.connected) {
//       socket.emit("location_update", {
//         "childId": childId,
//         "location": {"lat": location.latitude, "lng": location.longitude}
//       });
//     }
//   }

//   void sendLogout({required String childId}) {
//     if (socket.connected) {
//       print("🚀 Emitting logout event for user: $childId");
//       socket.emit('logout', {'userId': childId});
//     }
//   }
// }
