import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parliament_app/src/core/config/app_constants.dart';
import 'package:parliament_app/src/core/config/local_storage.dart';

class ResetPasswordRemoteDatasource {
  Future<String> resetPassword({
    required String newPassowrd,
  }) async {
    final token = await LocalStorage.getToken();
    final url = Uri.parse('$baseUrl/api/v1/user/reset-password');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'password': newPassowrd,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("data: $data");
      return data['message'] ?? 'Password updated successfully';
    } else {
      final errorBody = json.decode(response.body);
      final errorMessage =
          errorBody['message'] ?? errorBody['error'] ?? 'Failed to update password. Please try again.';
      throw errorMessage;
    }
  }
}
