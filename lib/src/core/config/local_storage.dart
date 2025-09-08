import 'dart:convert';

import 'package:parliament_app/src/core/utils/get_FCM_Token.dart';
import 'package:parliament_app/src/features/auth/data/models/user_model.dart';
import 'package:parliament_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'user', jsonEncode(user.toJson())); // Ensure `toJson()` is available
  }

  static Future<void> clear() async {
    await _prefs.clear();
  }

  static Future<UserEntity?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString('user');
    print("prefs $userStr");
    if (userStr != null) {
      final Map<String, dynamic> userMap = jsonDecode(userStr);
      return UserModel.fromJson(userMap); // or your appropriate class
    }
    return null;
  }

  static Future<void> clearUser() async {
    print("clear user called");
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'token', jsonEncode(token)); // Ensure `toJson()` is available
  }

  static Future getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) return jsonDecode(token);
    return null;
    // prefs.setString('token', jsonEncode(token)); // Ensure `toJson()` is available
  }

  static Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'refreshToken', jsonEncode(token)); // Ensure `toJson()` is available
  }

  static Future getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('refreshToken');
    if (token != null) return jsonDecode(token);
    return null;
    // prefs.setString('token', jsonEncode(token)); // Ensure `toJson()` is available
  }

  static Future<void> setNew() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'isNew', jsonEncode(true)); // Ensure `toJson()` is available
  }

  static Future getNew() async {
    final prefs = await SharedPreferences.getInstance();
    final isNew = prefs.getString('isNew');
    if (isNew != null) return jsonDecode(isNew);
    return null;
    // prefs.setString('token', jsonEncode(token)); // Ensure `toJson()` is available
  }

  static Future<void> setDeviceToken() async {
    final deviceToken = await getFCMToken();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('deviceToken',
        jsonEncode(deviceToken)); // Ensure `toJson()` is available
  }

  static Future getDeviceToken() async {
    final prefs = await SharedPreferences.getInstance();
    final deviceToken = prefs.getString('deviceToken');
    print("deviceToken: $deviceToken");
    if (deviceToken != null) return jsonDecode(deviceToken);
    return null;
    // prefs.setString('token', jsonEncode(token)); // Ensure `toJson()` is available
  }

  static Future<void> saveRole(String? role) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('role', jsonEncode(role)); // Ensure `toJson()` is available
  }

  static Future getRole() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role');
    if (role != null) return jsonDecode(role);
    return null;
  }

  static Future<void> deleteRole() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('role');
  }

  static Future<void> setValue(String key, String value) async {
    await _prefs.setString(key, value);
  }

  static Future<String?> getValue(String key) async {
    return _prefs.getString(key);
  }

  static Future<void> remove(String key) async {
    await _prefs.remove(key);
  }
}
