// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/config/app_constants.dart';
import 'package:parliament_app/src/core/config/local_storage.dart';
import 'package:parliament_app/src/core/services/child_realtime_service.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';
import 'package:parliament_app/src/core/widgets/svg_picture.dart';
import 'package:parliament_app/src/features/child-home/presentation/widgets/sos_button.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import '../../../auth/domain/entities/user_entity.dart';

class ChildDashboard extends StatefulWidget {
  const ChildDashboard({super.key});

  @override
  State<ChildDashboard> createState() => _ChildDashboardState();
}

class _ChildDashboardState extends State<ChildDashboard>
    with WidgetsBindingObserver {
  late final ChildRealtimeService _childRealtimeService;
  late final Location _location;
  String _currentAddress = "Searching...";

  LocationData? _currentLocation;
  List<Map<String, dynamic>> _offenders = [];
  bool _isLoadingOffenders = false;
  StreamSubscription<LocationData>? _locationSubscription;
  // LocationData? _previousLocation;

  // String _childId = "";
  // String _parentId = "";
  // String _name = "";
  // String _child_img = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // 👈 yeh zaroori hai
    _childRealtimeService = ChildRealtimeService();
    _location = Location();
    // _initialize();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    final locationData = await _location.getLocation();
    setState(() {
      _currentLocation = locationData;
    });

    if (locationData.latitude != null && locationData.longitude != null) {
      await _getAddressFromLatLng(
        locationData.latitude!,
        locationData.longitude!,
      );
      await _getOffendersNearby(
        locationData.latitude!,
        locationData.longitude!,
      );
    }
  }

  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks.first;
      if (!mounted) return; // ✅ check before setState

      setState(() {
        _currentAddress = "${place.name} ${place.street}, ${place.locality}";
      });
    } catch (e) {
      print("Error in address: $e");
    }
  }

  Future<void> _getOffendersNearby(double lat, double lng) async {
    if (!mounted) return; // ✅ check before setState

    setState(() {
      _isLoadingOffenders = true;
    });

    try {
      final offenders = await fetchOffenders(
        lat: lat,
        lng: lng,
        page: 1,
        pageSize: 5,
      );
      if (!mounted) return; // ✅ check before setState
      setState(() {
        _offenders = offenders;
      });
    } catch (e) {
      print("❌ Error fetching offenders: $e");
    } finally {
      if (!mounted) return; // ✅ check before setState

      setState(() {
        _isLoadingOffenders = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchOffenders({
    required double lat,
    required double lng,
    required int page,
    required int pageSize,
  }) async {
    UserEntity? parentId = await LocalStorage.getUser();
    final localUrl = Uri.parse(
        "$baseUrl/api/v1/offender/get/${parentId?.userId}?lat=$lat&lng=$lng");
    // Uri.parse("${baseUrl}/api/v1/offender/get?lat=$lat&lng=$lng&radius=1");
    print("Failed to fetch offenders");
    try {
      final localResponse = await http.get(localUrl);
      if (localResponse.statusCode == 200) {
        final localData = jsonDecode(localResponse.body);
        if (localData['data'] is List) {
          final offenders = List<Map<String, dynamic>>.from(localData['data']);
          print("✅ Got offenders from local DB");
          return offenders.map((e) => e).toList();
        } else {
          throw Exception(
              'Failed to fetch offenders: ${localResponse.statusCode}');
        }
      } else {
        print("Offender API Hitted");
        throw Exception(
            'Failed to fetch offenders: ${localResponse.statusCode}');
      }
    } catch (e, stack) {
      print("Offender API Hitted");

      print('❌ Exception occurred in fetchOffenders: $e');
      print('🔍 Stack trace: $stack');
      throw Exception('Failed to fetch offenders. ${e.toString()}');
    }
    // final url = Uri.parse(
    //   "https://zylalabs.com/api/2117/offender+registry+usa+api/1908/get+offenders+by+location?lat=$lat&lng=$lng&radius=1",
    // );
    // try {
    //   final response = await http.get(
    //     url,
    //     headers: {'Authorization': 'Bearer $ApiKey'},
    //   );
    //   if (response.statusCode == 200) {
    //     final body = response.body;
    //     print("Response body: $body");
    //     final data = jsonDecode(body);
    //     if (data is List) {
    //       final offenders = List<Map<String, dynamic>>.from(data);
    //       return offenders;
    //     } else if (data is Map && data['data'] is List) {
    //       final offenders = List<Map<String, dynamic>>.from(data['data']);
    //       return offenders;
    //     } else {
    //       throw Exception('Unexpected response format');
    //     }
    //   } else {
    //     print("Offender API Hitted");

    //     throw Exception('Failed to fetch offenders: ${response.statusCode}');
    //   }
    // } catch (e, stack) {
    //   print("Offender API Hitted");

    //   print('❌ Exception occurred in fetchOffenders: $e');
    //   print('🔍 Stack trace: $stack');
    //   throw Exception('Failed to fetch offenders. ${e.toString()}');
    // }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // 👈 cleanup
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getCurrentLocation();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // ✅ Jab screen resume hogi ya wapis aayenge
      _getCurrentLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final availableHeight = (screenHeight * .7) -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: availableHeight,
        child: Column(
          children: [
            SizedBox(height: 10),

            // Safe Zone Status Card
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.primaryLightGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  SvgPictureWidget(path: "assets/icons/rocket.svg"),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'You are in the safe zone.',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Museo-Bolder",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),

            // Location Details
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 13, 94, 0),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 10),
                      TextWidget(
                        text: 'Current Location:\n$_currentAddress',
                        color: Colors.black,
                        fontSize: 15,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  SizedBox(height: 5),

                  // Row(
                  //   children: [
                  //     Container(
                  //       width: 10,
                  //       height: 10,
                  //       decoration: const BoxDecoration(
                  //         color: Color.fromARGB(255, 13, 94, 0),
                  //         shape: BoxShape.circle,
                  //       ),
                  //     ),
                  //     SizedBox(width: 10),
                  //     TextWidget(
                  //       text: 'No offenders nearby',
                  //       color: Colors.black,
                  //       fontSize: 16,
                  //       fontFamily: "Museo-Bold",
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ],
                  // )
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: _offenders.isNotEmpty
                              ? Colors.red
                              : Color.fromARGB(255, 13, 94, 0),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextWidget(
                          text: _isLoadingOffenders
                              ? 'Checking for offenders nearby...'
                              : _offenders.isNotEmpty
                                  ? 'Nearest offender: ${_offenders.first["name"] ?? "Unknown"}'
                                  : 'No offenders nearby',
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Flexible space to center the SOS button
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SosButton(),
                    SizedBox(height: 30),
                    TextWidget(
                      text: 'Emergency',
                      textAlign: TextAlign.center,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Museo-Bolder",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:parliament_app/src/core/config/app_colors.dart';
// // import 'package:parliament_app/src/core/config/app_constants.dart';
// import 'package:parliament_app/src/core/config/local_storage.dart';
// import 'package:parliament_app/src/core/services/child_socket_service.dart';
// import 'package:parliament_app/src/core/widgets/custom_text.dart';
// import 'package:parliament_app/src/core/widgets/svg_picture.dart';
// import 'package:parliament_app/src/features/child-home/presentation/widgets/sos_button.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:location/location.dart';

// class ChildDashboard extends StatefulWidget {
//   const ChildDashboard({super.key});

//   @override
//   State<ChildDashboard> createState() => _ChildDashboardState();
// }

// class _ChildDashboardState extends State<ChildDashboard> {
//   late IO.Socket socket;

//   // Use the service class instead of a raw socket
//   late final ChildSocketService _socketService;
//   late final Location _location;
//   StreamSubscription<LocationData>? _locationSubscription;

//   String _childId = "";

//   @override
//   void initState() {
//     super.initState();
//     _socketService = ChildSocketService();
//     _location = Location();
//     _initialize();
//   }

//   void _initialize() async {
//     final user = await LocalStorage.getUser();
//     final userId = user?.userId ?? "";
//     final parentId = user?.parentId ?? "";

//     if (userId.isNotEmpty) {
//       _childId = userId;
//     }

//     // Initialize the socket service
//     _socketService.init(userId: userId, parentId: parentId);

//     // Start sending location updates
//     _startSendingLocation();
//   }

//   void _startSendingLocation() async {
//     // Ensure location service is enabled
//     bool serviceEnabled = await _location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await _location.requestService();
//       if (!serviceEnabled) return;
//     }

//     // Ensure permissions are granted
//     PermissionStatus permissionGranted = await _location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await _location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) return;
//     }

//     // Send location every 20 seconds
//     _locationSubscription = Stream.periodic(Duration(seconds: 20))
//         .asyncMap(
//       (_) => _location.getLocation(),
//     )
//         .listen((currentLocation) {
//       if (_childId.isNotEmpty) {
//         _socketService.sendLocationUpdate(
//           childId: _childId,
//           location: currentLocation,
//         );
//         print(
//             "📡 Location sent: ${currentLocation.latitude}, ${currentLocation.longitude}");
//       }
//     });
//   }

//   // Example of how to use the logout function
//   void _handleLogout() {
//     _socketService.sendLogout(childId: _childId);
//     // You can also call disconnect here if you want to be immediate
//     // _socketService.disconnect();
//     // Then navigate to login screen...
//   }

//   @override
//   void dispose() {
//     _locationSubscription?.cancel(); // Stop listening to location
//     _socketService.dispose(); // Cleanly dispose the socket
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final availableHeight = (screenHeight * .7) -
//         MediaQuery.of(context).padding.top -
//         MediaQuery.of(context).padding.bottom;
//     // 50; // Account for padding

//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: SizedBox(
//         height: availableHeight,
//         child: Column(
//           children: [
//             SizedBox(height: 10),

//             // Safe Zone Status Card
//             Container(
//               padding: EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: AppColors.primaryLightGreen,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Row(
//                 children: [
//                   SvgPictureWidget(
//                     path: "assets/icons/rocket.svg",
//                   ),
//                   SizedBox(width: 10),
//                   Expanded(
//                     child: Text(
//                       'You are in the safe zone.',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: "Museo-Bolder",
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 15),

//             // Location Details
//             Container(
//               width: MediaQuery.of(context).size.width,
//               padding: EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: Colors.white10,
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(
//                   color: Colors.black,
//                   width: 1,
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         width: 10,
//                         height: 10,
//                         decoration: const BoxDecoration(
//                           color: Color.fromARGB(255, 13, 94, 0),
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       TextWidget(
//                         text: 'Current Location: "School"',
//                         color: Colors.black,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 5),
//                   Row(
//                     children: [
//                       Container(
//                         width: 10,
//                         height: 10,
//                         decoration: const BoxDecoration(
//                           color: Color.fromARGB(255, 13, 94, 0),
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       TextWidget(
//                         text: 'No offenders nearby',
//                         color: Colors.black,
//                         fontSize: 16,
//                         fontFamily: "Museo-Bold",
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),

//             // Flexible space to center the SOS button
//             Expanded(
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     SosButton(),
//                     SizedBox(height: 30),
//                     TextWidget(
//                       text: 'Emergency',
//                       textAlign: TextAlign.center,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: "Museo-Bolder",
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
