import 'package:parliament_app/src/core/config/local_storage.dart';

class Headers {
  Future<Map<String, String>> authHeaders() async {
    final token = await LocalStorage.getToken();
    if (token == null) throw Exception("Authorization token not found");
    print("token: ${token}");
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }
}
