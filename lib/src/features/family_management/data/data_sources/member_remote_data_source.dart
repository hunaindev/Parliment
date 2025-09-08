import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:parliament_app/src/core/config/app_constants.dart';
import 'package:parliament_app/src/core/config/local_storage.dart';
import '../models/member_model.dart';
import 'package:http_parser/http_parser.dart';

abstract class MemberRemoteDataSource {
  Future<List<MemberModel>> getMembers();
  Future<void> addMember(MemberModel member);
  Future<void> deleteMember(String memberId);
  Future<void> editMember(String memberId, MemberModel updatedMember);
}

class MemberRemoteDataSourceImpl implements MemberRemoteDataSource {
  final http.Client client;

  MemberRemoteDataSourceImpl(this.client);

  @override
  Future<List<MemberModel>> getMembers() async {
    try {
      final token = await LocalStorage.getToken();

      final response =
          await client.get(Uri.parse("$baseUrl/api/v1/family"), headers: {
        "Authorization": "Bearer $token",
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final members = (data['data'] as List)
            .map((e) => MemberModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return members;
      } else {
        final message = jsonDecode(response.body)['message'] ?? 'Unknown error';
        throw message;
      }
    } catch (e) {
      final message = e.toString().replaceFirst("Exception: ", "");
      print("❌ getMembers error: $message");
      throw message;
    }
  }

  @override
  Future<void> addMember(MemberModel member) async {
    try {
      final token = await LocalStorage.getToken();
      var request =
          http.MultipartRequest('POST', Uri.parse("$baseUrl/api/v1/family"));

      request.headers.addAll({'Authorization': 'Bearer $token'});
      request.fields.addAll({'name': member.name, 'phone': member.phone});

      if (member.image.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          member.image,
          filename: path.basename(member.image),
          contentType: MediaType('image', 'png'),
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 201) {
        final message = jsonDecode(response.body)['message'] ?? 'Add failed';
        throw message;
      }
    } catch (e) {
      final message = e.toString().replaceFirst("Exception: ", "");
      print("❌ addMember error: $message");
      throw message;
    }
  }

  @override
  Future<void> editMember(String memberId, MemberModel updatedMember) async {
    try {
      final token = await LocalStorage.getToken();
      final uri = Uri.parse('$baseUrl/api/v1/family/$memberId');
      final request = http.MultipartRequest('PUT', uri);

      request.headers.addAll({'Authorization': 'Bearer $token'});
      request.fields.addAll({
        'name': updatedMember.name,
        'phone': updatedMember.phone,
      });

      if (updatedMember.imagePath != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          updatedMember.imagePath!,
          filename: path.basename(updatedMember.imagePath!),
          contentType: MediaType('image', 'png'),
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200) {
        final message = jsonDecode(response.body)['message'] ?? 'Update failed';
        throw message;
      }
    } catch (e) {
      final message = e.toString().replaceFirst("Exception: ", "");
      print("❌ editMember error: $message");
      throw message;
    }
  }

  @override
  Future<void> deleteMember(String memberId) async {
    try {
      final token = await LocalStorage.getToken();

      final response = await client
          .delete(Uri.parse("$baseUrl/api/v1/family/$memberId"), headers: {
        "Authorization": "Bearer $token",
      });

      if (response.statusCode != 200) {
        final message = jsonDecode(response.body)['message'] ?? 'Delete failed';
        throw message;
      }
    } catch (e) {
      final message = e.toString().replaceFirst("Exception: ", "");
      print("❌ deleteMember error: $message");
      throw message;
    }
  }
}
