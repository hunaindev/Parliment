import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:parliament_app/src/core/config/app_constants.dart';
import 'package:parliament_app/src/core/config/local_storage.dart';
import 'package:parliament_app/src/features/auth/data/models/user_model.dart';
import 'package:http_parser/http_parser.dart';

class ProfileRemoteDataSource {
  Future<UserModel> getUser() async {
    final token =
        await LocalStorage.getToken(); // or however you get your token

    final res = await http.get(
      Uri.parse('$baseUrl/api/v1/user/get-id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print("response: ${res.body.toString()}");
    if (res.statusCode == 200) {
      final data = json.decode(res.body)['data'];
      return UserModel.fromJson(data);
    } else {
      // Also improve error handling here
      String errorMessage = "Failed to load user";
      try {
        final errorBody = json.decode(res.body);
        errorMessage = errorBody['message'] ?? errorMessage;
      } catch (_) {
        // Fallback if the body isn't valid JSON
      }
      throw Exception(errorMessage);
    }
  }

  Future<UserModel> updateUserProfile({
    required String name,
    required String email,
    required String phone,
    String? imagePath,
    XFile? imageFile,
  }) async {
    try {
      print("Updating user profile...");
      print("Image path: $imagePath");

      final token = await LocalStorage.getToken();
      print("Token: $token");

      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/api/v1/user/edit-profile'),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      request.fields.addAll({
        'name': name,
        'phone': phone,
        'email': email,
      });

      if (imagePath != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          imagePath,
          filename: path.basename(imagePath),
          contentType: MediaType('image', 'png'),
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final updatedUser = UserModel.fromJson(data['user']);
        await LocalStorage.saveUser(updatedUser);
        print(
            "User updated: ${updatedUser.userId}, ${updatedUser.name}, ${updatedUser.image}, ${updatedUser.parentId}");
        return updatedUser;
      } else {
        String errorMessage = "Failed to update profile. Please try again.";
        try {
          final errorBody = json.decode(response.body);
          errorMessage =
              errorBody['message'] ?? errorBody['error'] ?? response.body;
        } catch (e) {
          print("❌ Could not parse error response JSON: $e");
          errorMessage = response.body;
        }
        throw errorMessage; // ✅ plain message
      }
    } catch (e) {
      print("Exception occurred while updating profile: $e");
      rethrow;
    }
  }
}
