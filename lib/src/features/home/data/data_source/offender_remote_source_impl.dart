import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parliament_app/src/core/config/app_constants.dart';
import 'package:parliament_app/src/core/config/local_storage.dart';
import 'package:parliament_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:parliament_app/src/features/home/data/model/offender_model.dart';
import 'offender_remote_source.dart';

class OffenderRemoteDataSourceImpl implements OffenderRemoteDataSource {
  @override
  Future<List<OffenderModel>> fetchOffenders({
    required double lat,
    required double lng,
    required int page,
    required int pageSize,
  }) async {
    UserEntity? parentId = await LocalStorage.getUser();
    final localUrl = Uri.parse(
        "$baseUrl/api/v1/offender/get/${parentId?.userId}?lat=$lat&lng=$lng");
    // Uri.parse("${baseUrl}/api/v1/offender/get?lat=$lat&lng=$lng&radius=1");
    print("Failed to fetch offenders");
    try {
      final localResponse = await http.get(localUrl);
      if (localResponse.statusCode == 200) {
        final localData = jsonDecode(localResponse.body);
        if (localData['data'] is List) {
          final offenders = List<Map<String, dynamic>>.from(localData['data']);
          print("✅ Got offenders from local DB");
          return offenders.map((e) => OffenderModel.fromJson(e)).toList();
        } else {
          throw Exception(
              'Failed to fetch offenders: ${localResponse.statusCode}');
        }
      } else {
        print("Offender API Hitted");
        return [];
      }
    } catch (e, stack) {
      print("Offender API Hitted");

      print('❌ Exception occurred in fetchOffenders: $e');
      print('🔍 Stack trace: $stack');
      throw Exception('Failed to fetch offenders. ${e.toString()}');
    }
  }
  // final url = Uri.parse(
  //     "https://zylalabs.com/api/2117/offender+registry+usa+api/1908/get+offenders+by+location?lat=$lat&lng=$lng&radius=1");
  // try {
  //   final response = await http.get(url, headers: {
  //     'Authorization': 'Bearer $ApiKey',
  //   });
  //   print("Offender API Hitted");
  //   if (response.statusCode == 200) {
  //     final body = response.body;
  //     print("Response body: $body");

  //     final data = jsonDecode(body);

  //     // Ensure the data is a list
  //     if (data is List) {
  //       final offenders = List<Map<String, dynamic>>.from(data);
  //       saveOffender(offenders);
  //       return offenders.map((e) => OffenderModel.fromJson(e)).toList();
  //     } else if (data is Map && data['data'] is List) {
  //       final offenders = List<Map<String, dynamic>>.from(data['data']);
  //       saveOffender(offenders);
  //       return offenders.map((e) => OffenderModel.fromJson(e)).toList();
  //     } else {
  //       throw Exception('Unexpected response format');
  //     }
  //   } else {
  //     print("Offender API Hitted");

  //     throw Exception('Failed to fetch offenders: ${response.statusCode}');
  //   }

  // Future<void> saveOffender(List<dynamic> data) async {
  //   try {
  //     final mongoUrl = Uri.parse("${baseUrl}/api/v1/offender/create");
  //     final saveResponse = await http.post(
  //       mongoUrl,
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode(data.map((e) => e).toList()),
  //     );
  //     if (saveResponse.statusCode == 201) {
  //       print("✅ Offenders saved successfully in MongoDB!");
  //     } else {
  //       print("❌ Failed to save offenders: ${saveResponse.body}");
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
