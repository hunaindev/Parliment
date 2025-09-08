import 'dart:convert';
// import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:parliament_app/src/core/config/app_constants.dart';
import 'package:parliament_app/src/core/config/local_storage.dart';
import 'package:parliament_app/src/core/services/child_realtime_service.dart';
import 'package:parliament_app/src/core/services/notification_service.dart';
import 'package:parliament_app/src/core/utils/get_FCM_Token.dart';
import 'package:parliament_app/src/core/utils/headers.dart';
// import 'package:parliament_app/src/core/config/custom_alerts.dart';
import 'package:parliament_app/src/features/auth/data/models/user_model.dart';
import 'package:parliament_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:parliament_app/src/features/auth/presentation/blocs/role_cubit.dart';

abstract class AuthRemoteDataSource {
  Future<UserEntity> login(UserModel user);
  Future<UserEntity> signup(UserModel user);
  Future<void> logout(String userId);
  Future linkChild(String email);
  Future<UserEntity> chooseRole(String role);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final RoleCubit roleCubit;

  AuthRemoteDataSourceImpl({required this.client, required this.roleCubit});

  @override
  Future<UserEntity> login(UserModel user) async {
    try {
      print("baseUrl: $baseUrl");
      print("user: ${user.toJson()}");
      final response = await client.post(
        Uri.parse("$baseUrl/api/v1/user/login"),
        body: jsonEncode(user.toJson()),
        headers: {"Content-Type": "application/json"},
      );
      print("response.body Login data  ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 403) {
        print("dddddddd");
        final userJson = data['data']?['user'];
        final accessToken = data['data']?['accessToken'];
        final refreshToken = data['data']?['refreshToken'];

        // Save whatever you can
        if (accessToken != null) await LocalStorage.saveToken(accessToken);
        if (refreshToken != null) {
          await LocalStorage.saveRefreshToken(refreshToken);
        }
        if (userJson != null) {
          await LocalStorage.saveUser(UserModel.fromJson(userJson));
        }
      }
      if (response.statusCode != 200) {
        final errorMessage = data['message'] ?? 'Signup failed';
        throw Exception(errorMessage); // ✅ meaningful error

        // throw Exception("Login failed: ${response.body}");
      }
      final deviceToken = await getFCMToken();
      print("deviceToken: $deviceToken");
      final userJson = data['data']['user'];
      print("response.body ${userJson}");

      if (userJson == null || userJson is! Map<String, dynamic>) {
        throw Exception("Invalid user data format");
      }

      final loggedInUser = UserModel.fromJson(userJson);
      print("user: $loggedInUser");
      print(
          "loggedInUser.parentDeviceToken: ${loggedInUser.parentDeviceToken}");

      final accessToken = data['data']['accessToken'];
      final refreshToken = data['data']['refreshToken'];
      print("accessToken: ${accessToken}");
      print("refreshToken : ${refreshToken}");

      if (accessToken == null || refreshToken == null) {
        throw Exception("Tokens not found in response");
      }
      // E:\flutter_windows_3.24.4-stable\flutter\bin

      await LocalStorage.saveToken(accessToken);
      await LocalStorage.saveRefreshToken(refreshToken);

      // print("userJson['role'] ${userJson}");
      print("userJson['role'] ${userJson['role']}");
      final role = userJson['role'];
      if (role != null) {
        await roleCubit.chooseRole(role.toLowerCase());
        if (role.toLowerCase() == "child") {
          ChildRealtimeService().setChildOnline(
            loggedInUser.parentId.toString(),
            loggedInUser.userId.toString(),
          );
          await NotificationService().sendNotification(
              loggedInUser.parentDeviceToken.toString(),
              title: "Child Login",
              body: "Your child is loggedIn");
        }
      }

      await LocalStorage.saveUser(loggedInUser);
      await LocalStorage.saveRole(userJson['role']);
      return loggedInUser;
    } catch (e) {
      final message = e.toString().replaceFirst("Exception: ", "");
      print('Login Error: $message');
      print(e);
      throw message;
    }
  }

  @override
  Future<UserEntity> signup(UserModel user) async {
    try {
      print("user ${user.toJson()}");

      final response = await http.post(
        Uri.parse("$baseUrl/api/v1/user/signup"),
        body: jsonEncode(user.toJson()),
        headers: {"Content-Type": "application/json"},
      );

      print("response.body ${response.body}");
      print("response.statusCode ${response.statusCode}");

      final data = jsonDecode(response.body);

      // If request failed, throw user-friendly message
      if (response.statusCode != 201) {
        final errorMessage = data['message'] ?? 'Signup failed';
        throw Exception(errorMessage); // ✅ meaningful error
      }

      final accessToken = data['accessToken'];
      final refreshToken = data['refreshToken'];
      print("accessToken: ${accessToken}");
      print("refreshToken : ${refreshToken}");

      if (accessToken == null || refreshToken == null) {
        throw Exception("Tokens not found in response");
      }
      // E:\flutter_windows_3.24.4-stable\flutter\bin

      await LocalStorage.saveToken(accessToken);
      await LocalStorage.saveRefreshToken(refreshToken);

      final userJson = data['user'];
      print("response.body ${userJson}");

      if (userJson == null || userJson is! Map<String, dynamic>) {
        throw Exception("Invalid user data format");
      }

      final resUser = UserModel.fromJson(userJson);
      print("user: $resUser");
      // print("token: ${data['data']['token']}");
      // return signedupUser;

      // If backend doesn't return user info, use what we already have
      final signedupUser = UserModel(
        email: user.email,
        name: user.name,
        role: user.role,
        deviceToken: user.deviceToken,
        parentEmail: user.parentEmail,
        password: user.password,
        lat: user.lat,
        lng: user.lng,
      );

      await LocalStorage.saveUser(signedupUser);
      // await LocalStorage.saveToken(token);
      await LocalStorage.saveRole(user.role);

      return resUser;
    } catch (e) {
      final message = e.toString().replaceFirst("Exception: ", "");
      print("❌ Signup error: $message");
      throw message;
    }
  }

  @override
  Future<UserEntity> chooseRole(String role) async {
    try {
      print("role: ${role}");

      final response = await client.post(
        Uri.parse("$baseUrl/api/v1/user/choose-role"),
        body: jsonEncode({"role": role}),
        headers: await Headers().authHeaders(),
      );

      print("response.body ${response.body}");
      print("response.statusCode ${response.statusCode}");

      final data = jsonDecode(response.body);

      // If request failed, throw user-friendly message
      if (response.statusCode != 200) {
        final errorMessage = data['message'] ?? 'Role selection failed';
        print("errorMessage: $errorMessage");
        throw Exception(
            errorMessage.toString().replaceFirst("Exception: ", ""));
        // ✅ meaningful error
      }

      final userJson = data['user'];
      final token = data['token'];
      await LocalStorage.saveToken(token);
      print("response.body ${userJson}");

      if (userJson == null || userJson is! Map<String, dynamic>) {
        throw Exception("Invalid user data format");
      }

      final selectedUser = UserModel.fromJson(userJson);
      print("user: $selectedUser");

      print("userJson['role'] ${userJson}");
      print("userJson['role'] ${userJson['role']}");

      await LocalStorage.saveUser(selectedUser);
      await LocalStorage.saveRole(userJson['role']);

      return selectedUser;
    } catch (e) {
      final message = e.toString().replaceFirst("Exception: ", "");
      print("❌ Role selection error: $message");
      throw message;
    }
  }

  @override
  Future<void> logout(String userId) async {
    try {
      final token = await LocalStorage.getToken();

      // print("parent ${parent}");

      final response = await client.post(
        Uri.parse("$baseUrl/api/v1/user/logout"),
        body: jsonEncode({"userId": userId}),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("response.body ${response.body}");
      print("response.statusCode ${response.statusCode}");

      final data = jsonDecode(response.body);

      // If request failed, throw user-friendly message
      if (response.statusCode != 200) {
        final errorMessage = data['message'] ?? 'Signup failed';
        throw Exception(errorMessage); // ✅ meaningful error
      }

      // return signedupUser;
    } catch (e) {
      final message = e.toString().replaceFirst("Exception: ", "");
      print("❌ Logout error: $message");
      throw message;
    }
  }

  @override
  Future linkChild(String parent) async {
    try {
      final token = await LocalStorage.getToken();

      print("parent ${parent}");

      final response = await client.post(
        Uri.parse("$baseUrl/api/v1/user/link-child"),
        body: jsonEncode({"email": parent}),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("response.body ${response.body}");
      print("response.statusCode ${response.statusCode}");

      final data = jsonDecode(response.body);

      // If request failed, throw user-friendly message
      if (response.statusCode != 200) {
        final errorMessage = data['message'] ?? 'Signup failed';
        throw Exception(errorMessage); // ✅ meaningful error
      }

      final resToken = data['token'];
      if (resToken == null) {
        throw Exception("Token not found in response");
      }

      await LocalStorage.saveToken(resToken);
    } catch (e) {
      final message = e.toString().replaceFirst("Exception: ", "");
      print("❌ Link Child error: $message");
      throw message;
    }
  }
}
