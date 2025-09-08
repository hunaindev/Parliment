// data/datasources/link_remote_datasource.dart

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:parliament_app/src/core/config/app_constants.dart';
import 'package:parliament_app/src/core/utils/headers.dart';

class LinkRemoteDataSource {
  // final http.Client client;

  // LinkRemoteDataSource({required this.client});

  Future<String> generateCode() async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/user/generate-code'),
      headers: await Headers().authHeaders(),
    );

    print("🔥 API called");
    print("📦 response.statusCode: ${response.statusCode}");
    print("📦 response.body: ${response.body}");

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['code'].toString(); // ✅ correct
    } else {
      String errorMessage = 'Failed to generate code';

      try {
        final errorData = jsonDecode(response.body);
        print("🧩 Decoded error JSON: $errorData");
        if (errorData is Map && errorData.containsKey('message')) {
          errorMessage = errorData['message'];
        } else if (errorData.containsKey('error')) {
          errorMessage = errorData['error'];
        } else {
          errorMessage = response.body;
        }
      } catch (e) {
        print("❌ JSON parsing failed: $e");
        errorMessage = response.body; // fallback to raw body
      }

      throw errorMessage; // ✅ throw plain message
    }
  }

  Future<bool> verifyCode(String code) async {
    print("api code $code");
    // final headers = await Headers().authHeaders();
    // print("📨 Headers sent: $headers");

    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/user/verify-code'),
      headers: await Headers().authHeaders(),
      body: jsonEncode({'code': code}),
    );

    print("🔥 API called");
    print("📦 response.statusCode: ${response.statusCode}");
    print("📦 response.body: ${response.body}");

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['success']; // ✅ correct
    } else {
      String errorMessage = 'Failed to Verify code';

      try {
        final errorData = jsonDecode(response.body);
        print("🧩 Decoded error JSON: $errorData");
        if (errorData is Map && errorData.containsKey('message')) {
          errorMessage = errorData['message'];
        } else if (errorData.containsKey('error')) {
          errorMessage = errorData['error'];
        } else {
          errorMessage = response.body;
        }
      } catch (e) {
        print("❌ Failed to Verify code: $e");
        errorMessage = response.body;
      }

      throw errorMessage; // ✅ throw plain message
    }
  }
}
