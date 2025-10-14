import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UsersServices {
  static Future<http.Response> updatePassword(
      Map<String, String> headers, Map<String, dynamic> body) async {
    http.Response response;
    try {
      response = await http.put(
        Uri.parse('${dotenv.env['USERS_URL']}/password/update'),
        headers: headers,
        body: jsonEncode(body),
      );
    } catch (e) {
      throw Error();
    }
    return response;
  }

  static Future<http.Response> registerUser(
      Map<String, String> headers, Map<String, dynamic> body) async {
    http.Response response;
    try {
      response = await http.post(
        Uri.parse('${dotenv.env['USERS_URL']}/register'),
        headers: headers,
        body: jsonEncode(body),
      );
    } catch (e) {
      throw Error();
    }
    return response;
  }

  static Future<http.Response> updateUser(Map<String, String> headers,
      Map<String, dynamic> body, int userId) async {
    http.Response response;
    try {
      response = await http.put(
        Uri.parse('${dotenv.env['USERS_URL']}/update/$userId'),
        headers: headers,
        body: jsonEncode(body),
      );
    } catch (e) {
      throw Error();
    }
    return response;
  }

  static Future<http.Response> getUserName(
      Map<String, String> headers, int userId) async {
    http.Response response;
    try {
      response = await http.get(
        Uri.parse('${dotenv.env['USERS_URL']}/user/name/$userId'),
        headers: headers,
      );
    } catch (e) {
      throw Error();
    }
    return response;
  }

  static Future<http.Response> deleteUser(
      Map<String, String> headers, int userId) async {
    http.Response response;
    try {
      response = await http.delete(
        Uri.parse('${dotenv.env['USERS_URL']}/delete/$userId'),
        headers: headers,
        body: userId.toString(),
      );
    } catch (e) {
      throw Error();
    }
    return response;
  }

  static Future<http.Response> fetchEmails() async {
    http.Response response;
    try {
      response = await http.get(
        Uri.parse('${dotenv.env['USERS_URL']}/user/email/all'),
      );
    } catch (e) {
      throw Error();
    }
    return response;
  }
}
