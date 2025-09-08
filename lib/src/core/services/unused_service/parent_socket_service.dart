// import 'dart:async';

// import 'package:parliament_app/src/core/services/unused_service/socket_client.dart';
// import 'package:parliament_app/src/features/home/presentation/widgets/child_status_section.dart';
// // import 'package:flutter_app/core/services/socket_client.dart'; // Adjust import
// // Import your ChildInfo model from the data layer
// // import 'package:flutter_app/features/tracking/data/models/child_info_model.dart';

// class ParentSocketService extends BaseSocketService {
//   static final ParentSocketService _instance = ParentSocketService._internal();

//   factory ParentSocketService() => _instance;

//   ParentSocketService._internal();

//   // StreamControllers to push data to the UI layer
//   final _onlineChildrenController =
//       StreamController<List<ChildInfo>>.broadcast();
//   final _childStatusController = StreamController<ChildInfo>.broadcast();
//   final _childOfflineController = StreamController<String>.broadcast();
//   final _locationUpdateController =
//       StreamController<Map<String, dynamic>>.broadcast();

//   // Public streams that the app can listen to
//   Stream<List<ChildInfo>> get onlineChildrenStream =>
//       _onlineChildrenController.stream;
//   Stream<ChildInfo> get childOnlineStream => _childStatusController.stream;
//   Stream<String> get childOfflineStream => _childOfflineController.stream;
//   Stream<Map<String, dynamic>> get locationUpdateStream =>
//       _locationUpdateController.stream;

//   final List<ChildInfo> _currentOnlineChildren = [];

//   @override
//   void init({required String userId, String? parentId}) {
//     createSocketInstance();
//     socket.connect();

//     // --- FIX IS HERE ---
//     socket.on('connect', (_) {
//       print('✅ Parent connected to socket, registering...');
//       socket.emit('register', {'userId': userId, 'role': 'parent'});
//       _listenToEvents(); // This should be called AFTER connection
//     });

//     // --- AND HERE ---
//     socket.on('disconnect', (_) => print('❌ Parent socket disconnected'));

//     // (Optional but Recommended) Handle connection errors for debugging
//     socket.on('connect_error', (data) => print('Connection Error: $data'));
//   }

//   void _listenToEvents() {
//     // Initial list of online children
//     socket.on('online_children', (data) {
//       final childrenList = (data['children'] as List)
//           .map((childJson) => ChildInfo.fromJson(childJson))
//           .toList();
//       _currentOnlineChildren.clear();
//       _currentOnlineChildren.addAll(childrenList);
//       _onlineChildrenController.add(List.from(_currentOnlineChildren));
//       print(
//           "RECEIVED Initial online children: ${_currentOnlineChildren.map((c) => c.name)}");
//     });

//     // A new child comes online
//     socket.on('child_online', (data) {
//       final newChild = ChildInfo.fromJson(data['child']);
//       _currentOnlineChildren
//           .removeWhere((c) => c.id == newChild.id); // Avoid duplicates
//       _currentOnlineChildren.add(newChild);
//       _childStatusController.add(newChild); // Emit the new child info
//       _onlineChildrenController
//           .add(List.from(_currentOnlineChildren)); // Emit updated full list
//       print("RECEIVED Child online: ${newChild.name}");
//     });

//     // A child goes offline
//     socket.on('child_offline', (data) {
//       final childId = data['childId'] as String;
//       _currentOnlineChildren.removeWhere((c) => c.id == childId);
//       _childOfflineController.add(childId);
//       _onlineChildrenController
//           .add(List.from(_currentOnlineChildren)); // Emit updated full list
//       print("RECEIVED Child offline: $childId");
//     });

//     // Location update from a child
//     socket.on('location_update', (data) {
//       print("data: $data");
//       _locationUpdateController.add(data as Map<String, dynamic>);
//       print(locationUpdateStream);
//     });
//     // _startListeningForDebug();
//   }

//   // StreamSubscription? _locationDebugSubscription;

//   // void _startListeningForDebug() {
//   //   // Ensure we don't create multiple listeners
//   //   _locationDebugSubscription?.cancel();

//   //   // Listen to the stream and print every data event
//   //   _locationDebugSubscription = locationUpdateStream.listen((locationData) {
//   //     print("✅ [DEBUG] Location data received on stream: $locationData");
//   //   });
//   // }

//   @override
//   void dispose() {
//     _onlineChildrenController.close();
//     _childStatusController.close();
//     _childOfflineController.close();
//     _locationUpdateController.close();
//     super.dispose();
//   }
// }
