import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:parliament_app/src/core/config/app_routes.dart';
import 'package:parliament_app/src/core/config/app_theme.dart';
import 'package:parliament_app/src/core/config/local_storage.dart';
import 'package:parliament_app/src/core/di/service_locator.dart';
import 'package:parliament_app/src/core/services/child_location_service.dart';
import 'package:parliament_app/src/core/services/child_realtime_service.dart';
import 'package:parliament_app/src/core/services/location_service.dart';
import 'package:parliament_app/src/core/services/parent_firestore_service.dart';
import 'package:parliament_app/src/core/utils/dio_setup.dart';
// import 'package:parliament_app/src/core/services/unused_service/socket_client.dart';
import 'package:parliament_app/src/core/utils/screen_size.dart';
import 'package:parliament_app/src/features/auth/domain/usecase/user_usecase.dart';
import 'package:parliament_app/src/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:parliament_app/src/features/auth/presentation/blocs/role_cubit.dart';
import 'package:parliament_app/src/features/auth/presentation/blocs/user_cubit.dart';
import 'package:parliament_app/src/features/child-home/data/remote_data_source/get_children_dashboard_remote_data_source.dart';
import 'package:parliament_app/src/features/child-home/data/respositories/child_dashboard_repository_impl.dart';
import 'package:parliament_app/src/features/child-home/presentation/blocs/dashboard/child_dashboard_bloc.dart';
import 'package:parliament_app/src/features/family_management/presentations/blocs/member_bloc.dart';
import 'package:parliament_app/src/features/history_reports/domain/repositories/notification_repository.dart';
// import 'package:parliament_app/src/features/history_reports/data/repositories/report_repository_impl.dart';
// import 'package:parliament_app/src/features/history_reports/domain/repositories/report_repository.dart';
import 'package:parliament_app/src/features/history_reports/presentations/bloc/notification_bloc.dart';
import 'package:parliament_app/src/features/history_reports/presentations/bloc/notification_event.dart';
// import 'package:parliament_app/src/features/history_reports/presentations/bloc/report_bloc.dart';
// import 'package:parliament_app/src/features/history_reports/presentations/bloc/report_event.dart';
import 'package:parliament_app/src/features/home/data/data_source/get_dashboard_remote_source.dart';
import 'package:parliament_app/src/features/home/data/data_source/offender_remote_source.dart';
import 'package:parliament_app/src/features/home/data/respositories/dashboard_repository_impl.dart';
import 'package:parliament_app/src/features/home/data/respositories/offender_repository_impl.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/dashboard/dashboard_bloc.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/location/location_cubit.dart';
// import 'package:parliament_app/src/features/home/domain/repositories/offender_repository.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/navigation/navigation_cubit.dart';
// import 'package:location/location.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/offender/offender_bloc.dart';
import 'package:parliament_app/src/features/home/presentation/pages/home_screen.dart';
import 'package:parliament_app/src/features/safety_tools/domain/usecases/create_geofence_usecase.dart';
import 'package:parliament_app/src/features/safety_tools/domain/usecases/restricted_zone_usecase.dart';
import 'package:parliament_app/src/features/safety_tools/presentations/blocs/geofence_bloc.dart';
// import 'package:parliament_app/src/features/settings/domain/repositories/profile_repository.dart';
// import 'package:parliament_app/src/features/settings/presentations/blocs/profile_bloc.dart';
import 'package:parliament_app/src/core/services/notification_service.dart';
import 'package:parliament_app/src/features/safety_tools/presentations/blocs/restricted_zone_bloc.dart';
import 'package:parliament_app/src/features/settings/data/data_sources/code_link_repository_impl.dart';
import 'package:parliament_app/src/features/settings/data/data_sources/remote/code_link_remote_datasource.dart';
import 'package:parliament_app/src/features/settings/data/data_sources/remote/profile_remote_datasource.dart';
import 'package:parliament_app/src/features/settings/domain/repositories/user_repository_impl.dart';
import 'package:parliament_app/src/features/settings/domain/usercases/link_code_usecase.dart';
import 'package:parliament_app/src/features/settings/domain/usercases/verify_code_usecase.dart';
import 'package:parliament_app/src/features/settings/presentations/blocs/code_generator_cubit.dart';
import 'package:parliament_app/src/features/settings/presentations/blocs/profile_bloc.dart';
import 'package:parliament_app/src/features/settings/presentations/blocs/profile_event.dart';

import 'firebase_options.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.requestPermission();
  await NotificationService().initialize();
  NotificationService().setupFirebaseHandlers();
  await LocalStorage.init();

  await LocationService().initialize();
  await ChildLocationService().initialize();

  await setupLocator();
  setupDio(); // ✅ Set up interceptors here

  // await LocalStorage.clear();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavigationCubit()),
        BlocProvider<RoleCubit>.value(value: getIt<RoleCubit>()),
        BlocProvider(
            create: (_) => GeofenceBloc(
                  createGeofenceUseCase: getIt<CreateGeofenceUseCase>(),
                )),
        BlocProvider(
          create: (_) => RestrictedZoneBloc(
            createRestrictedZoneUseCase: getIt<CreateRestrictedZoneUseCase>(),
          ),
        ),

        BlocProvider(
          create: (_) => AuthBloc(
            loginUseCase: getIt<LoginUseCase>(),
            signupUseCase: getIt<SignupUseCase>(),
            linkChildUseCase: getIt<LinkChildUseCase>(),
            logoutUseCase: getIt<LogoutUseCase>(),
            chooseRoleUseCase: getIt<ChooseRoleUseCase>(),
          ),
        ),
        BlocProvider<UserCubit>(create: (_) => UserCubit()),
        BlocProvider(create: (_) => getIt<MemberBloc>()),
        // ✅ OffenderBloc with direct repo instance
        BlocProvider(
          create: (_) => OffenderBloc(
              repository:
                  OffenderRepositoryImpl(getIt<OffenderRemoteDataSource>())),
        ),
        BlocProvider(
          create: (_) => DashboardBloc(
              repository:
                  DashboardRepositoryImpl(getIt<GetDashboardRemoteSource>())),
        ),
        BlocProvider(
          create: (_) => ChildDashboardBloc(
              repository: ChildDashboardRepositoryImpl(
                  getIt<GetChildrenDashboardRemoteDataSource>())),
        ),

        BlocProvider(
          create: (_) => ChildLocationCubit(ParentFirestoreService())
            ..listenToChildLocations(),
          child: ParentHomeScreen(),
        ),
        BlocProvider(
          create: (_) => ProfileBloc(
            UserRepositoryImpl(ProfileRemoteDataSource()),
          )..add(LoadUserProfile()),
        ),
        BlocProvider(
          create: (_) => LinkCubit(
            generateCodeUseCase:
                GenerateCodeUseCase(LinkRepositoryImpl(LinkRemoteDataSource())),
            verifyCodeUseCase:
                VerifyCodeUseCase(LinkRepositoryImpl(LinkRemoteDataSource())),
          ),
        ),
        BlocProvider(
          create: (context) => NotificationBloc(getIt<NotificationRepository>())
            ..add(FetchNotifications()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

// Future<void> _initializeFirebase() async {
//   await Firebase.initializeApp();
// }

// final Location location = Location();

// Future<void> initializeLocation() async {
//   bool serviceEnabled;
//   PermissionStatus permissionGranted;

//   serviceEnabled = await location.serviceEnabled();
//   if (!serviceEnabled) {
//     serviceEnabled = await location.requestService();
//     if (!serviceEnabled) {
//       debugPrint('❌ Location services are disabled.');
//       return;
//     }
//   }

//   permissionGranted = await location.hasPermission();
//   if (permissionGranted == PermissionStatus.denied) {
//     permissionGranted = await location.requestPermission();
//     if (permissionGranted != PermissionStatus.granted) {
//       debugPrint('❌ Location permission not granted.');
//       return;
//     }
//   }

//   // final loc = await location.getLocation();
//   // debugPrint('📍 Initial location: ${loc.latitude}, ${loc.longitude}');

//   // Start listening to location changes
//   // location.onLocationChanged.listen((LocationData currentLocation) {
//   //   final latitude = currentLocation.latitude?.toStringAsFixed(5);
//   //   final longitude = currentLocation.longitude?.toStringAsFixed(5);

//   //   final notificationTitle = "📍 Location Updated";
//   //   final notificationBody = "Lat: $latitude, Lng: $longitude";

//   //   debugPrint('$notificationTitle - $notificationBody');

//   //   // // Show local notification when location changes
//   //   // flutterLocalNotificationsPlugin.show(
//   //   //   DateTime.now().millisecondsSinceEpoch ~/ 1000, // Unique ID
//   //   //   notificationTitle,
//   //   //   notificationBody,
//   //   //   const NotificationDetails(
//   //   //     android: AndroidNotificationDetails(
//   //   //       'location_channel',
//   //   //       'Location Updates',
//   //   //       channelDescription: 'Notifies when user location changes',
//   //   //       importance: Importance.high,
//   //   //       priority: Priority.high,
//   //   //       icon: '@mipmap/ic_launcher',
//   //   //     ),
//   //   //   ),
//   //   // );
//   // });
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("dfsfetrgtfr");
    });
    WidgetsBinding.instance.addObserver(this); // ✅ Add this
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App has returned from background (e.g., settings)
      print("✅ App resumed from settings");
      // Recheck permissions or refresh the state
      LocationService().initialize(); // or rebuild UI
      setState(() {}); // trigger rebuild
    }
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      final user = context.read<UserCubit>().state;
      if (user != null) {
        ChildRealtimeService().setChildOffline(
          user.parentId.toString(),
          user.userId.toString(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.initialize(context);
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: '1Parliament1 App',
      theme: AppTheme.lightTheme,
    );
  }
}

// import 'package:flutter/material.dart';

// void main() {
//   runApp(MaterialApp());
// }
