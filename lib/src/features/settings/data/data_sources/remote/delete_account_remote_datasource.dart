import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parliament_app/src/core/config/app_constants.dart';
import 'package:parliament_app/src/core/config/local_storage.dart';

class DeleteAccountRemoteDatasource {
  Future<String> deleteAccount({
    required String password,
  }) async {
    final token = await LocalStorage.getToken();
    final url = Uri.parse('$baseUrl/api/v1/user/delete-account');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("✅ Delete account response data: $data");
      return data['message'] ?? 'Account deleted successfully';
    } else {
      String errorMessage = "Failed to delete account. Please try again.";

      try {
        final errorBody = json.decode(response.body);
        errorMessage =
            errorBody['message'] ?? errorBody['error'] ?? response.body;
      } catch (e) {
        print("❌ Could not parse error response JSON: $e");
        errorMessage = response.body; // fallback to raw error
      }

      throw errorMessage; // ✅ throw plain message
    }
  }
}
