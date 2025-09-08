import 'package:http/http.dart' as http;
import 'package:parliament_app/src/core/config/app_constants.dart';
import 'package:parliament_app/src/core/utils/headers.dart';
import 'dart:convert';
import '../models/report_model.dart';

class ReportRemoteDataSource {
  Future<List<ReportModel>> getReports() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/notify/get-notification'),
      headers: await Headers().authHeaders(),
    );

    print("response: ${response.body.toString()}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      final List notifications = decoded['notifications'];

      return notifications.map((e) => ReportModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load reports');
    }
  }
}
