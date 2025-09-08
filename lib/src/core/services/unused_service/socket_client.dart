// // import 'package:parliament_app/src/core/config/app_constants.dart';
// import 'package:parliament_app/src/core/config/app_constants.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:meta/meta.dart';

// // Your base URL constant
// // const String baseUrl = "http://your.server.ip:port";

// abstract class SocketService {
//   void init({required String userId, String? parentId});
//   void disconnect();
//   void dispose();
// }

// class BaseSocketService implements SocketService {

//   late IO.Socket _socket;
//   bool _isInitialized = false;
//   IO.Socket get socket => _socket;

//   @protected
//   void createSocketInstance() {
//     if (_isInitialized) return;
//     _socket = IO.io(baseUrl, <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': false,
//     });
//     _socket.connect();
//     _isInitialized = true;
//   }

//   // This method will be overridden by child classes
//   @override
//   void init({required String userId, String? parentId}) {
//     // Intentionally empty, to be implemented by subclasses
//   }

//   @override
//   void disconnect() {
//     print("🔌 Disconnecting socket...");
//     try {
//       if (_isInitialized && _socket.connected) {
//         _socket.disconnect();
//       }
//     } catch (e) {
//       print("⚠️ Socket not initialized: $e");
//     }
//   }

//   bool get isInitialized => _isInitialized;


//   @override
//   void dispose() {
//     print("🗑️ Disposing socket instance...");
//     _socket.dispose();
//   }
// }
