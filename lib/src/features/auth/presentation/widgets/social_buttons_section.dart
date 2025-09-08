import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:parliament_app/src/core/config/app_constants.dart';
import 'package:parliament_app/src/core/config/app_routes.dart';
import 'package:parliament_app/src/core/config/local_storage.dart';
import 'package:parliament_app/src/core/services/child_realtime_service.dart';
import 'package:parliament_app/src/core/services/notification_service.dart';
import 'package:parliament_app/src/core/utils/get_FCM_Token.dart';
import 'package:parliament_app/src/features/auth/data/models/user_model.dart';
import 'package:parliament_app/src/features/auth/presentation/blocs/role_cubit.dart';
import 'package:parliament_app/src/features/auth/presentation/blocs/user_cubit.dart';
// import 'package:parliament_app/src/features/auth/presentation/blocs/role_cubit.dart';
import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:parliament_app/src/features/auth/presentation/widgets/social_button.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialButtonsSection extends StatefulWidget {
  const SocialButtonsSection({super.key});

  @override
  State<SocialButtonsSection> createState() => _SocialButtonsSectionState();
}

class _SocialButtonsSectionState extends State<SocialButtonsSection> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  // final RoleCubit roleCubit;

  // Future<void> handleGoogleLogin() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     if (googleUser == null) return; // Login cancelled

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;
  //     final deviceToken = await getFCMToken();
  //     final accessToken = googleAuth.accessToken;

  //     print("accessToken: $accessToken");

  //     final response = await http.post(
  //       Uri.parse('${baseUrl}/api/v1/google/auth'),
  //       headers: {
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode({
  //         'access_token': accessToken,
  //         'deviceToken': deviceToken,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       print("✅ Logged in: $data");

  //       final user = data['user'];
  //       final accessToken = data['accessToken'];
  //       final refreshToken = data['refreshToken'];
  //       print("accessToken: ${accessToken}");
  //       print("refreshToken : ${refreshToken}");

  //       if (accessToken == null || refreshToken == null) {
  //         throw Exception("Tokens not found in response");
  //       }
  //       // E:\flutter_windows_3.24.4-stable\flutter\bin

  //       await LocalStorage.saveToken(accessToken);
  //       await LocalStorage.saveRefreshToken(refreshToken);

  //       print("user: $user");
  //       final loggedInUser = UserModel.fromJson(user);
  //       await LocalStorage.saveUser(loggedInUser);
  //       // await LocalStorage.saveToken(token);
  //       await LocalStorage.saveRole(user['role']);
  //       context.read<RoleCubit>().chooseRole(user['role']);
  //       context.read<UserCubit>().setUser(loggedInUser);

  //       if (mounted) {
  //         final userRole = user['role']?.toString().toLowerCase();

  //         if (userRole == null || userRole.isEmpty) {
  //           return context.go(AppRoutes.role);
  //         }

  //         if (userRole == "child") {
  //           if (userRole.toLowerCase() == "child") {
  //             ChildRealtimeService().setChildOnline(
  //               loggedInUser.parentId.toString(),
  //               loggedInUser.userId.toString(),
  //             );
  //             await NotificationService().sendNotification(
  //                 loggedInUser.parentDeviceToken.toString(),
  //                 title: "Child Login",
  //                 body: 'Your "${loggedInUser.name}" is loggedIn');
  //           }

  //           return context.go(AppRoutes.childHome);
  //         } else if (userRole == "parent") {
  //           return context.go(AppRoutes.parentHome);
  //         }
  //       }
  //     } else {
  //       final body = response.body;
  //       String message;

  //       try {
  //         final error = jsonDecode(body);
  //         message = error['message'] ?? 'Unknown error';
  //       } catch (_) {
  //         if (body.contains("Path `role` is required")) {
  //           message = "Role is required";
  //           print("❌❌❌❌ ROLE IS REQUIRED ❌❌❌");
  //           if (context.mounted) {
  //             context.go(AppRoutes.role);
  //             return; // ✅ Prevents fallback snackbar
  //           }
  //         } else {
  //           message = "Unexpected server error";
  //         }
  //       }

  //       print("❌ Server error: $message");
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Login failed: $message")),
  //       );
  //     }
  //   } catch (e) {
  //     print("❌ Google login exception: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Google login error: $e")),
  //     );
  //   }
  // }

  Future<void> handleGoogleLogin() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // user cancelled

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final deviceToken = await getFCMToken();
      final accessToken = googleAuth.accessToken;

      print("Google accessToken: $accessToken");

      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/google/auth'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'access_token': accessToken,
          'deviceToken': deviceToken,
        }),
      );

      final body = response.body;
      final data = jsonDecode(body);

      if (response.statusCode == 200) {
        // ✅ Backend ka response normalize karo
        final userJson = data['data']?['user'] ?? data['user'];
        final accessToken = data['data']?['accessToken'] ?? data['accessToken'];
        final refreshToken =
            data['data']?['refreshToken'] ?? data['refreshToken'];

        if (accessToken == null || refreshToken == null || userJson == null) {
          throw Exception("Invalid response: missing tokens or user");
        }

        // ✅ Local storage me persist karo
        await LocalStorage.saveToken(accessToken);
        await LocalStorage.saveRefreshToken(refreshToken);

        final loggedInUser = UserModel.fromJson(userJson);
        await LocalStorage.saveUser(loggedInUser);
        await LocalStorage.saveRole(userJson['role']);

        // ✅ Cubits update
        context.read<RoleCubit>().chooseRole(userJson['role']);
        context.read<UserCubit>().setUser(loggedInUser);

        // ✅ Role based navigation
        final userRole = userJson['role']?.toString().toLowerCase();
        if (userRole == null || userRole.isEmpty) {
          return context.go(AppRoutes.role);
        }

        if (userRole == "child") {
          ChildRealtimeService().setChildOnline(
            loggedInUser.parentId.toString(),
            loggedInUser.userId.toString(),
          );

          await NotificationService().sendNotification(
            loggedInUser.parentDeviceToken.toString(),
            title: "Child Login",
            body: 'Your "${loggedInUser.name}" is logged in',
          );

          return context.go(AppRoutes.childHome);
        } else if (userRole == "parent") {
          return context.go(AppRoutes.parentHome);
        }
      } else {
        // ❌ Error handling
        String message;
        try {
          final error = jsonDecode(body);
          message = error['message'] ?? 'Unknown error';
        } catch (_) {
          message = "Unexpected server error";
        }
        print("❌ Server error: $message");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Login failed: $message")),
          );
        }
      }
    } catch (e) {
      print("❌ Google login exception: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Google login error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SocialButton(
          iconPath: 'assets/icons/apple.svg',
          label: 'Apple ID',
          onPressed: () {
            // TODO: Implement Facebook logic or hide if not used
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Apple ID login not implemented")),
            );
          },
        ),
        SocialButton(
          iconPath: 'assets/icons/google.svg',
          label: 'Google',
          onPressed: () async {
            await handleGoogleLogin();
          },
        ),
      ],
    );
  }
}
