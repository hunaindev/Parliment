import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parliament_app/src/core/config/app_constants.dart';
import 'package:parliament_app/src/core/config/local_storage.dart';
import 'package:parliament_app/src/core/utils/headers.dart';
import 'package:parliament_app/src/features/child-home/data/models/child_dashboard_model.dart';
import 'package:parliament_app/src/features/child-home/data/remote_data_source/get_children_dashboard_remote_data_source.dart';

// import 'offender_remote_source.dart';
class GetChildrenDashboardRemoteDataSourceImpl
    implements GetChildrenDashboardRemoteDataSource {
  @override
  Future<ChildDashboardModel> fetchDasboard({required String userId}) async {
    final url = Uri.parse("$baseUrl/api/v1/user/get-child-dashboard");

    try {
      final response = await http.get(
        url,
        headers: await Headers().authHeaders(),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is Map &&
            decoded['data'] is Map &&
            decoded['data']['geofences'] is List &&
            decoded['data']['restricted_zone'] is List) {
          final data = decoded['data'];

          return ChildDashboardModel.fromJson({
            "geofences": data['geofences'],
            "restricted_zone": data['restricted_zone']
          });
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception(
          'Failed to fetch dashboard data: ${response.statusCode}',
        );
      }
    } catch (e, stack) {
      refreshToken(userId: userId);
      print('❌ Exception occurred in child fetchDashboard: $e');
      print('🔍 Stack trace: $stack');
      throw Exception('Failed to fetch child  dashboard data. ${e.toString()}');
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
        await fetchDasboard(userId: userId);
      } else {
        throw Exception(
            'Failed to fetch dashboard data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch dashboard data. ${e.toString()}');
    }
  }
}
