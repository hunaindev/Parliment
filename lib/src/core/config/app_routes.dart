import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Import all screens
import 'package:parliament_app/src/features/auth/presentation/pages/choose_role.dart';
import 'package:parliament_app/src/features/auth/presentation/pages/forget_password.dart';
import 'package:parliament_app/src/features/auth/presentation/pages/link_child.dart';
import 'package:parliament_app/src/features/auth/presentation/pages/link_to_parent.dart';
import 'package:parliament_app/src/features/auth/presentation/pages/login.dart';
import 'package:parliament_app/src/features/auth/presentation/pages/reset_password.dart';
import 'package:parliament_app/src/features/auth/presentation/pages/signup.dart';
import 'package:parliament_app/src/features/auth/presentation/pages/verify_otp.dart';
import 'package:parliament_app/src/features/child-home/presentation/pages/child_home.dart';
import 'package:parliament_app/src/features/child-home/presentation/pages/child_profile.dart';
import 'package:parliament_app/src/features/child-home/presentation/pages/crash_detect/crash_detected_screen.dart';
import 'package:parliament_app/src/features/child-home/presentation/pages/crash_detect/emergency_number.dart';
import 'package:parliament_app/src/features/child-home/presentation/pages/crash_detect/glad_ok_screen.dart';
import 'package:parliament_app/src/features/family_management/presentations/pages/family_management.dart';
import 'package:parliament_app/src/features/history_reports/presentations/pages/history_reports.dart';
import 'package:parliament_app/src/features/home/presentation/pages/home_screen.dart';
import 'package:parliament_app/src/features/home/presentation/pages/main_notification.dart';
import 'package:parliament_app/src/features/home/presentation/pages/notification_screen.dart';
import 'package:parliament_app/src/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:parliament_app/src/features/safety_tools/presentations/pages/emergency_contact.dart';
import 'package:parliament_app/src/features/safety_tools/presentations/pages/geofence_setup.dart';
import 'package:parliament_app/src/features/safety_tools/presentations/pages/nearby_offenders.dart';
import 'package:parliament_app/src/features/safety_tools/presentations/pages/restricted_zone.dart';
import 'package:parliament_app/src/features/safety_tools/presentations/pages/safety_tools.dart';
import 'package:parliament_app/src/features/settings/presentations/pages/settings.dart';
import 'package:parliament_app/src/features/splash/presentation/pages/splash_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (BuildContext context, GoRouterState state) =>
          const SplashScreen(),
      pageBuilder: (BuildContext context, GoRouterState state) =>
          NoTransitionPage(child: SplashScreen()),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (BuildContext context, GoRouterState state) =>
          const OnboardingScreen(),
      pageBuilder: (BuildContext context, GoRouterState state) =>
          const NoTransitionPage(child: OnboardingScreen()),
    ),
    GoRoute(
      path: AppRoutes.login,
      pageBuilder: (BuildContext context, GoRouterState state) =>
          NoTransitionPage(child: LoginScreen()),
    ),
    GoRoute(
      path: AppRoutes.signup,
      builder: (BuildContext context, GoRouterState state) => SignupScreen(),
      pageBuilder: (BuildContext context, GoRouterState state) =>
          NoTransitionPage(child: SignupScreen()),
    ),
    GoRoute(
      path: AppRoutes.forgetPassword,
      builder: (BuildContext context, GoRouterState state) =>
          ForgetPasswordScreen(),
      pageBuilder: (BuildContext context, GoRouterState state) =>
          NoTransitionPage(child: ForgetPasswordScreen()),
    ),
    GoRoute(
      path: AppRoutes.otpVerify,
      pageBuilder: (BuildContext context, GoRouterState state) {
        final token = state.uri.queryParameters['token'] ?? '';
        final email = state.uri.queryParameters['email'] ?? '';
        return NoTransitionPage(
          child: VerifyOtpScreen(
            email: email,
            token: token,
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.resetPassword,
      pageBuilder: (BuildContext context, GoRouterState state) {
        final token = state.uri.queryParameters['token'] ?? '';
        // final email = state.uri.queryParameters['email'] ?? '';
        return NoTransitionPage(
          child: ResetPasswordScreen(
            accessToken: token,
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.linkToParent,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return NoTransitionPage(
          child: LinkToParent(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.role,
      builder: (BuildContext context, GoRouterState state) =>
          ChooseRoleScreen(),
      pageBuilder: (BuildContext context, GoRouterState state) =>
          NoTransitionPage(child: ChooseRoleScreen()),
    ),
    GoRoute(
      path: AppRoutes.parentHome,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: ParentHomeScreen()),

      /// Defines the page builder for the parent home screen route with no transition animation.
      ///
      /// Uses [NoTransitionPage] to create a page without any transition effect when
      /// navigating to the parent home screen.
      // pageBuilder: (BuildContext context, GoRouterState state) =>
      //     buildPageWithoutAnimation<void>(
      //   context: context,
      //   state: state,
      //   child: ParentHomeScreen(),
      // ),
    ),
    GoRoute(
      path: AppRoutes.safetyTools,
      // builder: (BuildContext context, GoRouterState state) =>
      //     const SafetyTools(),
      pageBuilder: (BuildContext context, GoRouterState state) =>
          const NoTransitionPage(child: SafetyTools()),
    ),
    GoRoute(
      path: AppRoutes.familyManagement,
      builder: (BuildContext context, GoRouterState state) =>
          const FamilyManagementScreen(),
      pageBuilder: (BuildContext context, GoRouterState state) =>
          const NoTransitionPage(child: FamilyManagementScreen()),
    ),
    GoRoute(
      path: AppRoutes.notification,
      builder: (BuildContext context, GoRouterState state) =>
          const MainNotification(),
      pageBuilder: (BuildContext context, GoRouterState state) =>
          const NoTransitionPage(child: MainNotification()),
    ),
    GoRoute(
      path: AppRoutes.historyReports,
      builder: (BuildContext context, GoRouterState state) =>
          const HistoryAndReports(),
      pageBuilder: (BuildContext context, GoRouterState state) =>
          const NoTransitionPage(child: HistoryAndReports()),
    ),
    GoRoute(
      path: AppRoutes.childHome,
      builder: (BuildContext context, GoRouterState state) =>
          const ChildHomeScreen(),
      pageBuilder: (BuildContext context, GoRouterState state) =>
          const NoTransitionPage(child: ChildHomeScreen()),
    ),
    GoRoute(
      path: AppRoutes.childProfile,
      builder: (BuildContext context, GoRouterState state) =>
          const ChildProfileScreen(),
      pageBuilder: (BuildContext context, GoRouterState state) =>
          const NoTransitionPage(child: ChildProfileScreen()),
    ),
    GoRoute(
      path: AppRoutes.geofenceSetup,
      builder: (BuildContext context, GoRouterState state) =>
          const GeoFenceSetupScreen(),
      pageBuilder: (BuildContext context, GoRouterState state) =>
          const NoTransitionPage(child: GeoFenceSetupScreen()),
    ),
    GoRoute(
      path: AppRoutes.emergencyContact,
      builder: (BuildContext context, GoRouterState state) =>
          const EmergencyScreen(),
      pageBuilder: (BuildContext context, GoRouterState state) =>
          const NoTransitionPage(child: EmergencyScreen()),
    ),
    GoRoute(
      path: AppRoutes.nearbyOffenders,
      builder: (BuildContext context, GoRouterState state) =>
          const NearbyOffendersScreen(),
      pageBuilder: (BuildContext context, GoRouterState state) =>
          const NoTransitionPage(child: NearbyOffendersScreen()),
    ),
    GoRoute(
      path: AppRoutes.restrictedZone,
      builder: (BuildContext context, GoRouterState state) =>
          const RestrictedZonesScreen(),
      pageBuilder: (BuildContext context, GoRouterState state) =>
          const NoTransitionPage(child: RestrictedZonesScreen()),
    ),
    GoRoute(
      path: AppRoutes.carCrash,
      builder: (BuildContext context, GoRouterState state) =>
          CrashDetectedScreen(),
      pageBuilder: (BuildContext context, GoRouterState state) =>
          NoTransitionPage(child: CrashDetectedScreen()),
    ),
    GoRoute(
      path: AppRoutes.gladYoureOkScreen,
      builder: (BuildContext context, GoRouterState state) =>
          GladYoureOkScreen(),
      pageBuilder: (BuildContext context, GoRouterState state) =>
          NoTransitionPage(child: GladYoureOkScreen()),
    ),
    GoRoute(
      path: AppRoutes.emergencyNumber,
      builder: (BuildContext context, GoRouterState state) =>
          EmergencyNumberScreen(),
      pageBuilder: (BuildContext context, GoRouterState state) =>
          NoTransitionPage(child: EmergencyNumberScreen()),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (BuildContext context, GoRouterState state) => Settings(),
      pageBuilder: (BuildContext context, GoRouterState state) =>
          NoTransitionPage(child: Settings()),
    ),
    GoRoute(
      path: AppRoutes.notification,
      builder: (BuildContext context, GoRouterState state) =>
          NotificationScreen(),
      pageBuilder: (BuildContext context, GoRouterState state) =>
          NoTransitionPage(child: NotificationScreen()),
    ),
    GoRoute(
      path: AppRoutes.linkChild,
      builder: (BuildContext context, GoRouterState state) => LinkChild(),
      pageBuilder: (BuildContext context, GoRouterState state) =>
          NoTransitionPage(child: LinkChild()),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('No route defined for ${state.uri.toString()}'),
    ),
  ),
);

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String linkChild = '/link-child';
  static const String forgetPassword = '/forget-password';
  static const String otpVerify = '/verify-otp';
  static const String resetPassword = '/reset-password';
  static const String linkToParent = '/link-to-parent';
  static const String role = '/role';
  static const String parentHome = '/parent-home';
  static const String safetyTools = '/safety-tools';
  static const String restrictedZone = '/restricted-zone';
  static const String geofenceSetup = '/geofence-setup';
  static const String emergencyContact = '/emergency-contact';
  static const String nearbyOffenders = '/nearby-offenders';
  static const String familyManagement = '/family-management';
  static const String historyReports = '/history-reports';
  static const String childHome = '/child-home';
  static const String childProfile = '/child-profile';
  static const String carCrash = '/car-crash';
  static const String gladYoureOkScreen = '/glad-youre-ok';
  static const String emergencyNumber = '/emergency-number';
  static const String settings = '/settings';
  static const String notification = '/notification';
}
