import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  static Future<http.Response> login(
      String email, String hashedPassword) async {
    final url = Uri.parse('${dotenv.env['AUTH_URL']}/login');
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      'email': email,
      'password': hashedPassword,
    });

    http.Response response;
    try {
      response = await http.post(url, headers: headers, body: body);
    } catch (e) {
      throw Error();
    }

    return response;
  }

  static Future<http.Response> sendVerificationCode(
      Map<String, String> headers, String email) async {
    http.Response response;
    try {
      response = await http.post(
        Uri.parse('${dotenv.env['AUTH_URL']}/user/verification/request'),
        headers: headers,
        body: '"$email"',
      );
    } catch (e) {
      throw Error();
    }
    return response;
  }

  static Future<http.Response> verifyCode(
      Map<String, String> headers, Map<String, dynamic> body) async {
    http.Response response;
    try {
      response = await http.post(
        Uri.parse('${dotenv.env['AUTH_URL']}/user/verify'),
        headers: headers,
        body: jsonEncode(body),
      );
    } catch (e) {
      throw Error();
    }
    return response;
  }
}
