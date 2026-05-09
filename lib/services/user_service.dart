import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hit_api/models/user.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String url = dotenv.get("BASE_URL");

  Future<bool> createUser(UserRequest request) async {
    try {
      final response = await http.post(
        Uri.parse("$url/user"),
        body: jsonEncode(request.toJson()),
        headers: {"accept": "application/json"},
      );

      final jsonResponse = await jsonDecode(response.body);
      debugPrint("Hit Api: $jsonResponse");

      if (response.statusCode != 201) {
        debugPrint("samting wong");
        return false;
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> updateUser(UserRequest request, String id) async {
    try {
      final response = await http.put(
        Uri.parse("$url/user/$id"),
        body: jsonEncode(request.toJson()),
        headers: {"accept": "application/json"},
      );

      final jsonResponse = await jsonDecode(response.body);
      debugPrint("Hit Api: $jsonResponse");

      if (response.statusCode != 200) {
        debugPrint("samting wong");
        return false;
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<List<UserResponse>?> getDataUser() async {
    try {
      final response = await http.get(Uri.parse("$url/user"));

      if (response.statusCode == 200) {
        final jsonResponse = await jsonDecode(response.body);

        debugPrint("Hit Api: $jsonResponse");
        final List<UserResponse> data = (jsonResponse as List)
            .map((e) => UserResponse.fromJson(e))
            .toList();

        return data;
      }
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> deleteData(String id) async {
    final response = await http.delete(Uri.parse("$url/user/$id"));

    if (response.statusCode != 200) {
      throw Exception("Failed to delete data");
    }
  }
}
