import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _callbackUrl =
      'http://localhost:5000/serp/api/auth/callback';

  static Future<Map<String, dynamic>> authenticateWithBackend(
      String accessToken) async {
    final res = await http.post(
      Uri.parse(_callbackUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (res.statusCode != 200) {
      throw Exception('Backend auth failed: ${res.body}');
    }

    final data = json.decode(res.body);
    if (data['status'] != 'ok') {
      throw Exception('Auth error: $data');
    }

    return data;
  }
}
