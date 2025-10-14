import 'package:http/http.dart' as http;
import 'dart:convert';

class UsersServices {
  static Future<http.Response> updatePassword(
      Map<String, String> headers, Map<String, dynamic> body) async {
    http.Response response;
    try {
      response = await http.put(
        Uri.parse('http://192.168.1.112:8083/password/update'),
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
        Uri.parse('http://192.168.1.112:8083/register'),
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
        Uri.parse('http://192.168.1.112:8083/update/$userId'),
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
        Uri.parse('http://192.168.1.112:8083/user/name/$userId'),
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
        Uri.parse('http://192.168.1.112:8083/delete/$userId'),
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
        Uri.parse('http://192.168.1.112:8083/user/email/all'),
      );
    } catch (e) {
      throw Error();
    }
    return response;
  }
}
