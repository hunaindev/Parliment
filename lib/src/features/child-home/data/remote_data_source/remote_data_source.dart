import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parliament_app/src/core/config/app_constants.dart';
import 'package:parliament_app/src/core/config/local_storage.dart';
import 'package:parliament_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:parliament_app/src/features/child-home/data/models/offender_model.dart';

class OffenderService {
  Future<List<ChildOffenderModel>> getNearbyOffenders({
    required double lat,
    required double lng,
  }) async {
    UserEntity? parentId = await LocalStorage.getUser();
    final localUrl = Uri.parse(
        "$baseUrl/api/v1/offender/get/${parentId?.userId}?lat=$lat&lng=$lng");
    // Uri.parse("${baseUrl}/api/v1/offender/get?lat=$lat&lng=$lng&radius=1");
    final localResponse = await http.get(localUrl);
    if (localResponse.statusCode == 200) {
      final localData = jsonDecode(localResponse.body);
      if (localData['data'] is List) {
        final offenders = List<Map<String, dynamic>>.from(localData['data']);
        print("✅ Got offenders from local DB");
        return offenders
            .map((json) => ChildOffenderModel.fromJson(json))
            .toList();
      }
    }
    final url = Uri.parse(
        'https://zylalabs.com/api/2117/offender+registry+usa+api/1908/get+offenders+by+location?lat=$lat&lng=$lng&radius=1');

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $ApiKey',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // --- THE FIX IS HERE ---
        // Check if the decoded JSON is a list.
        if (data is List) {
          // If it's a list, we can process it directly.
          final offendersList = List<Map<String, dynamic>>.from(data);
          saveOffender(offendersList);
          return offendersList
              .map((json) => ChildOffenderModel.fromJson(json))
              .toList();
        }
        // We can also keep the old check in case the API format is inconsistent.
        else if (data is Map && data['data'] is List) {
          final offendersList = List<Map<String, dynamic>>.from(data['data']);
          saveOffender(offendersList);
          return offendersList
              .map((json) => ChildOffenderModel.fromJson(json))
              .toList();
        }
        // If it's neither of the expected formats, then we throw an error.
        else {
          print(
              'Unexpected response format: The response is not a List or a Map with a "data" key.');
          throw Exception('Unexpected response format');
        }
      } else {
        print(
            'Failed to fetch offenders. Status: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to fetch offenders: ${response.statusCode}');
      }
    } catch (e, stack) {
      print('❌ Exception occurred in getNearbyOffenders: $e');
      print('🔍 Stack trace: $stack');
      // Rethrow to allow the UI to handle the error (e.g., show a snackbar)
      rethrow;
    }
  }

  Future<void> saveOffender(List<dynamic> data) async {
    try {
      final mongoUrl = Uri.parse("${baseUrl}/api/v1/offender/create");
      final saveResponse = await http.post(
        mongoUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data.map((e) => e).toList()),
      );
      if (saveResponse.statusCode == 201) {
        print("✅ Offenders saved successfully in MongoDB!");
      } else {
        print("❌ Failed to save offenders: ${saveResponse.body}");
      }
    } catch (e) {
      print(e);
    }
  }
}
