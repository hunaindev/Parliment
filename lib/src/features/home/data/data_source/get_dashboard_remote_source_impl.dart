import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parliament_app/src/core/config/app_constants.dart';
import 'package:parliament_app/src/core/config/local_storage.dart';
import 'package:parliament_app/src/core/utils/headers.dart';
import 'package:parliament_app/src/features/home/data/data_source/get_dashboard_remote_source.dart';
import 'package:parliament_app/src/features/home/data/model/dashboard_data_model.dart';
// import 'offender_remote_source.dart';

class GetDashboardRemoteSourceImpl implements GetDashboardRemoteSource {
  @override
  Future<DashboardDataModel> fetchDasboard({
    required String parentId,
  }) async {
    print("get dashoard data parent $parentId");
    final url = Uri.parse("$baseUrl/api/v1/user/get-dashboard");

    try {
      final response = await http.get(
        url,
        headers: await Headers().authHeaders(),
      );
      print("decoded: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        print("decoded: ${decoded}");
        if (decoded is Map && decoded['data'] is Map) {
          return DashboardDataModel.fromJson(decoded['data']);
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        await refreshToken(userId: parentId);
        throw Exception(
            'Failed to fetch dashboard data: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Failed to fetch dashboard data: $e');
      await refreshToken(userId: parentId);
      throw Exception('Failed to fetch dashboard data. ${e.toString()}');
    }
  }

  @override
  Future<void> refreshToken({required String userId}) async {
    final url = Uri.parse("$baseUrl/api/v1/user/refreshLogin/${userId}");

    try {
      final response = await http.get(
        url,
        headers: await Headers().authHeaders(),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final accessToken = decoded['data']['accessToken'];
        final refreshToken = decoded['data']['refreshToken'];
        if (accessToken == null || refreshToken == null) {
          throw Exception("Tokens not found in response");
        }
        await LocalStorage.saveToken(accessToken);
        await LocalStorage.saveRefreshToken(refreshToken);
        await fetchDasboard(parentId: userId);
      } else {
        throw Exception(
            'Failed to fetch dashboard data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch dashboard data. ${e.toString()}');
    }
  }
}

// refreshLogin
