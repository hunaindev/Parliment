import 'package:flutter/material.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
// import 'package:parliament_app/src/core/config/app_constants.dart';
import 'package:parliament_app/src/core/config/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:parliament_app/src/core/config/local_storage.dart';
import 'package:parliament_app/src/core/utils/get_FCM_Token.dart';
// import 'package:parliament_app/src/core/widgets/custom_button.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkIsNew();
  }

  void _checkIsNew() async {
    final isNew = await LocalStorage.getNew();
    print("isNew $isNew");

    Future.delayed(const Duration(seconds: 6), () async {
      if (!mounted) return;

      if (isNew.toString().isNotEmpty) {
        context.go(AppRoutes.login);
      } else {
        await LocalStorage.setNew();
        context.go(AppRoutes.onboarding);
      }
    });

    requestNotificationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        // <- this centers its child both vertically and horizontally
        child: Column(
          mainAxisSize: MainAxisSize
              .min, // <- makes column wrap its content instead of filling all space
          children: [
            //             Lottie.asset("assets/animations/dashboard_animation.json", height: 220),
            // Lottie.asset("assets/animations/warning_animation.json", height: 220),
            // Lottie.asset("assets/animations/smart_geolocation_animation.json", height: 220),
            // Lottie.asset("assets/animations/secure_animation.json", height: 220),
            // Lottie.asset("assets/animations/gps_tracking_animation.json", height: 220),

            Image.asset("assets/icons/onlyLogo.png", height: 220),
            Text(
              "1Parliament1",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryLightGreen,
                fontFamily: 'Museo-Bolder',
              ),
            ),
            // CustomButton(
            //   text: "Get Deivce token push notification",
            //   onPressed: () async {
            //     try {
            //       String? token =
            //           await getFCMToken(); // Ensure this returns the token
            //       if (token == null) {
            //         throw Exception("FCM Token is null");
            //       }

            //       final response = await http.post(
            //         Uri.parse(
            //             '$baseUrl/api/send-notification'), // replace with your local or hosted API
            //         headers: {'Content-Type': 'application/json'},
            //         body: jsonEncode({
            //           'deviceToken': token,
            //           'title': 'Test Push',
            //           'body': 'This is a test push from Flutter app',
            //         }),
            //       );

            //       if (response.statusCode == 200) {
            //         if (!context.mounted) return;
            //         ScaffoldMessenger.of(context).showSnackBar(
            //           SnackBar(content: Text('✅ Notification sent!')),
            //         );
            //       } else {
            //         throw Exception('Failed: ${response.body}');
            //       }
            //     } catch (e) {
            //       print(e.toString());
            //       if (!context.mounted) return;
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         SnackBar(content: Text('❌ Error: ${e.toString()}')),
            //       );
            //     }
            //   },
            // )
          ],
        ),
      ),
    );
  }
}
