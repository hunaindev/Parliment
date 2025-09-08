// lib/features/history_reports/data/data_sources/notification_remote_data_source.dart

import 'package:http/http.dart' as http;
import 'package:parliament_app/src/core/config/app_constants.dart';
import 'package:parliament_app/src/core/utils/headers.dart';
import 'dart:convert';
import '../models/notification_model.dart'; // Import the correct model

class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/notify/get-notification'),
      headers: await Headers().authHeaders(),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      final List notificationsJson = decoded['notifications'];

      // Map the JSON list to a list of NotificationModel objects
      return notificationsJson.map((json) => NotificationModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load notifications from API');
    }
  }
}