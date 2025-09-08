import 'dart:convert'; // for json.encode
import 'package:http/http.dart' as http;
import 'package:parliament_app/src/core/config/app_constants.dart';
import 'package:parliament_app/src/core/utils/headers.dart';
import 'package:parliament_app/src/features/safety_tools/data/models/restricted_zone_model.dart';

abstract class RestrictedZoneRemoteDatasource {
  Future<void> createRestrictedZone(RestrictedZoneModel restricted_zone);
}

class RestrictedZoneRemoteDataSourceImpl
    implements RestrictedZoneRemoteDatasource {
  final http.Client client;

  RestrictedZoneRemoteDataSourceImpl({required this.client});

  @override
  Future<void> createRestrictedZone(RestrictedZoneModel restricted_zone) async {
    try {
      print('📤 Sending: ${restricted_zone.toJson()}');

      final response = await client.post(
        Uri.parse('$baseUrl/api/v1/restricted-zone'),
        body: json.encode(restricted_zone.toJson()),
        headers: await Headers().authHeaders(),
      );

      final decoded = jsonDecode(response.body);
      print("📩 Response: $decoded");

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(decoded['message'] ?? 'Unknown server error');
      }
    } on http.ClientException catch (e) {
      print("❌ HTTP Error: ${e.message}");
      rethrow; // rethrow the original http.ClientException
    } on FormatException catch (e) {
      print("❌ JSON Format Error: ${e.message}");
      rethrow; // rethrow the original FormatException
    } catch (e) {
      print("❌ Unknown Error: $e");
      rethrow; // rethrow any other error as-is
    }
  }
}
