// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:parliament_app/src/core/config/app_colors.dart';
// // import 'package:parliament_app/src/core/config/app_routes.dart';
// import 'package:parliament_app/src/core/config/local_storage.dart';
// import 'package:parliament_app/src/core/widgets/custom_text.dart';
// import 'package:parliament_app/src/features/auth/presentation/widgets/custom_text_button.dart';
// import 'package:parliament_app/src/features/home/presentation/blocs/dashboard/dashboard_bloc.dart';
// import 'package:parliament_app/src/features/home/presentation/blocs/dashboard/dashboard_event.dart';
// import 'package:parliament_app/src/features/home/presentation/blocs/dashboard/dashboard_state.dart';
// import 'package:parliament_app/src/features/home/presentation/blocs/location/location_cubit.dart';
// import 'package:parliament_app/src/features/home/presentation/blocs/offender/offender_bloc.dart';
// import 'package:parliament_app/src/features/home/presentation/blocs/offender/offender_event.dart';
// import 'package:parliament_app/src/features/home/presentation/blocs/offender/offender_state.dart';
// import 'package:parliament_app/src/features/home/presentation/pages/notification_screen.dart';
// import 'package:parliament_app/src/features/home/presentation/widgets/child_status_section.dart';
// import 'package:parliament_app/src/features/home/presentation/widgets/home_offender_card.dart';
// import 'package:parliament_app/src/features/home/presentation/widgets/live_location.dart';
// import 'package:parliament_app/src/features/home/presentation/widgets/recent_alerts.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class DashboardScreen extends StatefulWidget {
//   final onItemTapped;
//   const DashboardScreen({super.key, required this.onItemTapped});

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   // List<Offender> offenders = [
//   //   Offender(name: "Mike Peterson", age: "34", lastLocation: "School"),
//   //   Offender(name: "John Doe", age: "42", lastLocation: "Playground"),
//   //   Offender(name: "Charlie Smith", age: "29", lastLocation: "Mall"),
//   // ];

//   // Future<void> _getLocationAndFetchOffenders() async {
//   //   if (!mounted) return;
//   //   // final location = await LocationService().getCurrentLocation();
//   //   // final lat = location?.latitude ?? 0.0;
//   //   // final lng = location?.longitude ?? 0.0;
//   //   // final data = await DashboardCubit().fetchDashboard();
//   //   // print("data: $data");
//   //   // context.read<DashboardCubit;
//   // }

//   void getDashboard() async {
//     print("getdashboard data for parent");
//     final user = await LocalStorage.getUser();
//     print("parent user: ${user.toString()}");
//     if (user != null) {
//       print("user.userId.toString() ${user.userId.toString()}");
//       context.read<DashboardBloc>().add(
//             FetchDasboard(parentId: user.userId.toString()),
//           );
//       Timer(Duration(seconds: 3), () {
//         _fetchOffendersFromChildren();
//       });
//     } else {
//       print("User is null — wait before dispatching dashboard fetch.");
//     }
//   }

//   // Future<void> _fetchOffendersFromChildren() async {
//   //   // Ensure the widget is still mounted before accessing context.
//   //   if (!mounted) return;

//   //   // A microtask delay ensures that the context is fully available.
//   //   await Future.microtask(() {});

//   //   final children = context.read<ChildLocationCubit>().state;
//   //   final childrenWithLocation =
//   //       children.where((child) => child.location != null).toList();

//   //   if (childrenWithLocation.isNotEmpty) {
//   //     for (final child in childrenWithLocation) {
//   //       final lat = child.location!.latitude;
//   //       final lng = child.location!.longitude;
//   //       context.read<OffenderBloc>().add(FetchOffenders(lat: lat, lng: lng));
//   //     }
//   //   } else {
//   //     // Fallback: no live location found
//   //     context.read<OffenderBloc>().add(FetchOffenders(lat: 0.0, lng: 0.0));
//   //   }
//   // }

//   Future<void> _fetchOffendersFromChildren() async {
//     // Ensure the widget is still mounted before accessing context.
//     if (!mounted) return;

//     final prefs = await SharedPreferences.getInstance();

//     // Get last fetch timestamp
//     final lastFetchMillis = prefs.getInt('lastFetchOffenders') ?? 0;
//     final lastFetch = DateTime.fromMillisecondsSinceEpoch(lastFetchMillis);

//     // Agar 7 din purane se zyada ho gaya hai tabhi fetch karna hai
//     final now = DateTime.now();
//     final oneWeekAgo = now.subtract(const Duration(days: 7));

//     if (lastFetch.isAfter(oneWeekAgo)) {
//       print("⏳ Offenders already fetched within last 7 days, skipping...");
//       return;
//     }
//     // A microtask delay ensures that the context is fully available.
//     await Future.microtask(() {});
//     final children = context.read<ChildLocationCubit>().state;
//     final childrenWithLocation =
//         children.where((child) => child.location != null).toList();

//     if (childrenWithLocation.isNotEmpty) {
//       for (final child in childrenWithLocation) {
//         final lat = child.location!.latitude;
//         final lng = child.location!.longitude;
//         context.read<OffenderBloc>().add(FetchOffenders(lat: lat, lng: lng));
//       }
//     } else {
//       // Fallback: no live location found
//       // context.read<OffenderBloc>().add(FetchOffenders(lat: 0.0, lng: 0.0));
//     }

//     // Update last fetch timestamp
//     await prefs.setInt('lastFetchOffenders', now.millisecondsSinceEpoch);
//   }

//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       final state = context.read<DashboardBloc>().state;
//       if (state is! DashboardLoaded) {
//         getDashboard();
//       }
//     });
//     Timer.periodic(Duration(seconds: 10), (timer) {
//       getDashboard();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<DashboardBloc, DashboardState>(
//         builder: (context, state) {
//       if (state is DashboardLoading) {
//         return Center(
//             child: CircularProgressIndicator(
//           color: AppColors.primaryLightGreen,
//         ));
//       } else if (state is DashboardLoaded) {
//         // final children = state.children;

//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextWidget(
//                 text: 'Where is everyone right now?',
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: "Museo-Bolder",
//                 color: AppColors.darkBrown,
//               ),
//               const SizedBox(height: 16),
//               ChildStatusSection(),
//               // Status Cards
//               const SizedBox(height: 16),
//               // Live Location

//               Column(
//                 children: [
//                   Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         TextWidget(
//                           text: 'Live Location',
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           fontFamily: "Museo-Bolder",
//                           color: AppColors.darkBrown,
//                         ),
//                         CustomTextButton(
//                           text: 'View All',
//                           onTap: () {
//                             widget.onItemTapped(1);
//                             // context.go(ParentMapScreen());
//                           },
//                           // fontWeight: FontWeight.bold,
//                         ),
//                       ]),
//                   const SizedBox(height: 8),
//                   LiveLocationWidget()
//                 ],
//               ),
//               const SizedBox(height: 16),
//               // const SizedBox(height: 16),
//               // Recent Alerts
//               Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       TextWidget(
//                         text: 'Recent Alerts',
//                         fontSize: 18,
//                         fontWeight: FontWeight.w900,
//                         fontFamily: "Museo-Bolder",
//                         color: AppColors.darkBrown,
//                       ),
//                       CustomTextButton(
//                         text: 'View All',
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => NotificationScreen()),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   // const SizedBox(height: 16),
//                   RecentAlerts(),
//                 ],
//               ),

//               const SizedBox(height: 16),
//               // Nearby Offenders
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   TextWidget(
//                     text: 'Nearby Offenders',
//                     fontSize: 18,
//                     fontWeight: FontWeight.w900,
//                     fontFamily: "Museo-Bolder",
//                     color: AppColors.darkBrown,
//                   ),
//                   CustomTextButton(
//                     text: 'View All',
//                     onTap: () {
//                       widget.onItemTapped(2);
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               BlocBuilder<OffenderBloc, OffenderState>(
//                 builder: (context, state) {
//                   if (state is OffenderLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   if (state is OffenderLoaded) {
//                     if (state.offenders.isEmpty) {
//                       return const Center(child: Text("No offenders found."));
//                     }
//                     final offenderList = state.offenders
//                         .map((e) => Offender.fromEntity(e))
//                         .toList();

//                     return HomeOffenderCard(offenders: offenderList);
//                   }

//                   return const Center(
//                       child: CircularProgressIndicator(
//                     color: AppColors.primaryLightGreen,
//                   ));
//                 },
//               ),
//               // ),
//               const SizedBox(height: 16),
//             ],
//           ),
//         );
//       } else {
//         // ✅ Fallback to avoid null return
//         return Center(child: Text("No data available or an error occurred."));
//       }
//     });
//   }
// }

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/config/local_storage.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';
import 'package:parliament_app/src/features/auth/presentation/widgets/custom_text_button.dart';
import 'package:parliament_app/src/features/history_reports/presentations/bloc/notification_bloc.dart';
import 'package:parliament_app/src/features/history_reports/presentations/bloc/notification_event.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/dashboard/dashboard_bloc.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/dashboard/dashboard_event.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/dashboard/dashboard_state.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/location/location_cubit.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/offender/offender_bloc.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/offender/offender_event.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/offender/offender_state.dart';
import 'package:parliament_app/src/features/home/presentation/pages/notification_screen.dart';
import 'package:parliament_app/src/features/home/presentation/widgets/child_status_section.dart';
import 'package:parliament_app/src/features/home/presentation/widgets/home_offender_card.dart';
import 'package:parliament_app/src/features/home/presentation/widgets/live_location.dart';
import 'package:parliament_app/src/features/home/presentation/widgets/recent_alerts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  final Function(int) onItemTapped;
  const DashboardScreen({super.key, required this.onItemTapped});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Timer? _dashboardTimer;

  void getDashboard() async {
    if (!mounted) return;

    print("getdashboard data for parent");
    final user = await LocalStorage.getUser();

    if (!mounted) return;

    if (user != null) {
      print("user.userId.toString() ${user.userId.toString()}");
      context
          .read<DashboardBloc>()
          .add(FetchDasboard(parentId: user.userId.toString()));

      context.read<NotificationBloc>().add(FetchNotifications());

      Timer(const Duration(seconds: 3), () {
        if (mounted) {
          _fetchOffendersFromChildren();
        }
      });
    } else {
      print("User is null — wait before dispatching dashboard fetch.");
    }
  }

  Future<void> _fetchOffendersFromChildren() async {
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    final lastFetchMillis = prefs.getInt('lastFetchOffenders') ?? 0;
    final lastFetch = DateTime.fromMillisecondsSinceEpoch(lastFetchMillis);

    final now = DateTime.now();
    final oneWeekAgo = now.subtract(const Duration(days: 7));

    // if (lastFetch.isAfter(oneWeekAgo)) {
    //   print("⏳ Offenders already fetched within last 7 days, skipping...");
    //   return;
    // }

    await Future.microtask(() {});
    if (!mounted) return;

    final children = context.read<ChildLocationCubit>().state;
    final childrenWithLocation =
        children.where((child) => child.location != null).toList();

    if (childrenWithLocation.isNotEmpty) {
      for (final child in childrenWithLocation) {
        final lat = child.location!.latitude;
        final lng = child.location!.longitude;
        if (mounted) {
          context.read<OffenderBloc>().add(FetchOffenders(lat: lat, lng: lng));
        }
      }
    }

    await prefs.setInt('lastFetchOffenders', now.millisecondsSinceEpoch);
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;
      final state = context.read<DashboardBloc>().state;
      if (state is! DashboardLoaded) {
        getDashboard();
      }
    });

    _dashboardTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        getDashboard();
      }
    });
  }

  @override
  void dispose() {
    _dashboardTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryLightGreen,
            ),
          );
        } else if (state is DashboardLoaded) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: 'Where is everyone right now?',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Museo-Bolder",
                  color: AppColors.darkBrown,
                ),
                const SizedBox(height: 16),
                ChildStatusSection(),
                const SizedBox(height: 16),

                /// Live Location
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          text: 'Live Location',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Museo-Bolder",
                          color: AppColors.darkBrown,
                        ),
                        CustomTextButton(
                          text: 'View All',
                          onTap: () => widget.onItemTapped(1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LiveLocationWidget(),
                  ],
                ),

                const SizedBox(height: 16),

                /// Recent Alerts
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          text: 'Recent Alerts',
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          fontFamily: "Museo-Bolder",
                          color: AppColors.darkBrown,
                        ),
                        CustomTextButton(
                          text: 'View All',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotificationScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    RecentAlerts(),
                  ],
                ),

                const SizedBox(height: 16),

                /// Nearby Offenders
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: 'Nearby Offenders',
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      fontFamily: "Museo-Bolder",
                      color: AppColors.darkBrown,
                    ),
                    CustomTextButton(
                      text: 'View All',
                      onTap: () => widget.onItemTapped(2),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                BlocBuilder<OffenderBloc, OffenderState>(
                  builder: (context, state) {
                    if (state is OffenderLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is OffenderLoaded) {
                      if (state.offenders.isEmpty) {
                        return const Center(child: Text("No offenders found."));
                      }
                      final offenderList = state.offenders
                          .map((e) => Offender.fromEntity(e))
                          .toList();

                      return HomeOffenderCard(offenders: offenderList);
                    }

                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryLightGreen,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        } else {
          return Center(child: Text("No data available or an error occurred."));
        }
      },
    );
  }
}
