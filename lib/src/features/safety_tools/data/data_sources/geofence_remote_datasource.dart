import 'dart:convert'; // for json.encode
import 'package:http/http.dart' as http;
import 'package:parliament_app/src/core/config/app_constants.dart';
import 'package:parliament_app/src/core/config/local_storage.dart';
import '../models/geofence_model.dart';

abstract class GeofenceRemoteDataSource {
  Future<void> createGeofence(GeofenceModel geofence);
}

class GeofenceRemoteDataSourceImpl implements GeofenceRemoteDataSource {
  final http.Client client;

  GeofenceRemoteDataSourceImpl({required this.client});

  @override
  Future<void> createGeofence(GeofenceModel geofence) async {
    try {
      print("geofence.toJson(): ${geofence.toJson()}");

      final token = await LocalStorage.getToken();

      final response = await client.post(
        Uri.parse('$baseUrl/api/v1/geofence'),
        body: json.encode(geofence.toJson()), // ✅ encode body to JSON
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print("response: ${response.body}");

      if (response.statusCode != 200 && response.statusCode != 201) {
        final body = json.decode(response.body);
        final errorMessage = body['message'] ?? 'Unknown error occurred';
        throw errorMessage;
      }
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      print("❌ Error while creating geofence: $message");
      throw message; // ✅ Rethrow clean error message
    }
  }
}
