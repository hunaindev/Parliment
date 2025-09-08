// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:parliament_app/src/core/config/app_colors.dart';
// import 'package:parliament_app/src/core/widgets/custom_text.dart';
// import 'package:parliament_app/src/core/widgets/main_scaffold.dart';
// import 'package:parliament_app/src/features/home/presentation/blocs/dashboard/dashboard_bloc.dart';
// import 'package:parliament_app/src/features/home/presentation/blocs/dashboard/dashboard_state.dart';

// class MainNotification extends StatefulWidget {
//   const MainNotification({super.key});

//   @override
//   State<MainNotification> createState() => _MainNotificationState();
// }

// class _MainNotificationState extends State<MainNotification> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final TextEditingController _searchController = TextEditingController();
//   List<dynamic> _filteredNotifications = [];

//   @override
//   void initState() {
//     super.initState();
//     // Wait for the dashboard state to be loaded before filtering
//     Future.microtask(() {
//       final notifications = context.read<DashboardBloc>().notfication;
//       setState(() {
//         _filteredNotifications = notifications;
//       });
//     });
//   }

//   void _onSearchChanged(String query) {
//     final notifications = context.read<DashboardBloc>().notfication;

//     setState(() {
//       _filteredNotifications = notifications
//           .where((notification) =>
//               notification.title.toLowerCase().contains(query.toLowerCase()) ||
//               notification.body.toLowerCase().contains(query.toLowerCase()) ||
//               notification.sender.name
//                   .toLowerCase()
//                   .contains(query.toLowerCase()))
//           .toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MainScaffold(
//       key: _scaffoldKey,
//       body:
//           BlocBuilder<DashboardBloc, DashboardState>(builder: (context, state) {
//         final dashboardBloc = context.read<DashboardBloc>();
//         final notifications = dashboardBloc.notfication;
//         if (notifications.isEmpty) {
//           return SizedBox(
//             height: 100,
//             child: Center(child: Text("No alerts available")),
//           );
//         }
//         return Column(
//           children: [
//             // Search bar here
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//               child: TextField(
//                 controller: _searchController,
//                 onChanged: _onSearchChanged,
//                 style:
//                     const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                 decoration: InputDecoration(
//                   hintText: 'Search Notifications',
//                   prefixIcon: const Icon(Icons.search),
//                   filled: true,
//                   fillColor: Colors.white,
//                   hintStyle: const TextStyle(fontWeight: FontWeight.bold),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8)),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: const BorderSide(
//                         color: AppColors.primaryLightGreen, width: 1),
//                   ),
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                 ),
//               ),
//             ),

//             // Expanded for ListView
//             Container(
//               width: MediaQuery.of(context).size.width,
//               // height: MediaQuery.of(context).size.height * 0.8,
//               child: _filteredNotifications.isEmpty
//                   ? const Center(
//                       child: Padding(
//                         padding: EdgeInsets.only(top: 32),
//                         child: Text(
//                           "No alerts found.",
//                           style: TextStyle(fontSize: 16, color: Colors.grey),
//                         ),
//                       ),
//                     )
//                   : ListView.builder(
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       padding: const EdgeInsets.all(16),
//                       itemCount: _filteredNotifications.length,
//                       itemBuilder: (context, index) {
//                         final notify = _filteredNotifications[index];
//                         return Card(
//                           color: Colors.white,
//                           margin: const EdgeInsets.symmetric(vertical: 8),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           elevation: 2,
//                           child: Padding(
//                             padding: const EdgeInsets.all(16),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 TextWidget(
//                                   text: notify.title,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: AppColors.darkGray,
//                                 ),
//                                 const SizedBox(height: 8),
//                                 TextWidget(
//                                   text: notify.body,
//                                   fontSize: 14,
//                                   color: Colors.black87,
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     TextWidget(
//                                       text: "From: ${notify.sender.name}",
//                                       fontSize: 12,
//                                       color: Colors.grey,
//                                     ),
//                                     TextWidget(
//                                       text: _formatTime(notify.sentAt),
//                                       fontSize: 12,
//                                       color: Colors.grey,
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ],
//         );
//       }),
//     );
//   }

//   String _formatTime(String dateTimeString) {
//     try {
//       final dateTime = DateTime.parse(dateTimeString)
//           .toLocal(); // optional: to convert to local time
//       return DateFormat('MMM d, y – hh:mm a').format(dateTime);
//       // int hour = dateTime.hour;
//       // final minute = dateTime.minute.toString().padLeft(2, '0');
//       // final period = hour >= 12 ? 'PM' : 'AM';
//       // hour = hour % 12;
//       // if (hour == 0) hour = 12; // handle midnight and noon
//       // return '${hour.toString().padLeft(2, '0')}:$minute $period'; // e.g., 02:24 PM
//     } catch (e) {
//       return "";
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';
import 'package:parliament_app/src/core/widgets/main_scaffold.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/dashboard/dashboard_bloc.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/dashboard/dashboard_state.dart';

class MainNotification extends StatefulWidget {
  const MainNotification({super.key});

  @override
  State<MainNotification> createState() => _MainNotificationState();
}

class _MainNotificationState extends State<MainNotification> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> _filteredNotifications = [];

  void _onSearchChanged(String query, List<dynamic> notifications) {
    setState(() {
      if (query.isEmpty) {
        _filteredNotifications = notifications;
      } else {
        _filteredNotifications = notifications
            .where((notification) =>
                notification.title
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                notification.body.toLowerCase().contains(query.toLowerCase()) ||
                notification.sender.name
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      key: _scaffoldKey,
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          final dashboardBloc = context.read<DashboardBloc>();
          final notifications = dashboardBloc.notfication;

          // agar search text empty hai to list sync karo
          if (_searchController.text.isEmpty) {
            _filteredNotifications = notifications;
          } else {
            _filteredNotifications = notifications
                .where((notification) =>
                    notification.title
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()) ||
                    notification.body
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()) ||
                    notification.sender.name
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()))
                .toList();
          }

          if (notifications.isEmpty) {
            return const SizedBox(
              height: 100,
              child: Center(child: Text("No alerts available")),
            );
          }

          return Column(
            children: [
              // 🔍 Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (query) => _onSearchChanged(query, notifications),
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'Search Notifications',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.primaryLightGreen,
                        width: 1,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                  ),
                ),
              ),

              // 📋 Notifications list
              Container(
                width: MediaQuery.of(context).size.width,
                child: _filteredNotifications.isEmpty
                    ? const Center(
                        child: Text(
                          "No alerts found.",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredNotifications.length,
                        itemBuilder: (context, index) {
                          final notify = _filteredNotifications[index];
                          return Card(
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    text: notify.title,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkGray,
                                  ),
                                  const SizedBox(height: 8),
                                  TextWidget(
                                    text: notify.body,
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextWidget(
                                        text: "From: ${notify.sender.name}",
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      TextWidget(
                                        text: _formatTime(notify.sentAt),
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString).toLocal();
      return DateFormat('MMM d, y – hh:mm a').format(dateTime);
    } catch (e) {
      return "";
    }
  }
}
