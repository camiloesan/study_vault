import 'package:http/http.dart' as http;
import 'dart:convert';

class UsersServices {
  static Future<http.Response> updatePassword(
      Map<String, String> headers, Map<String, dynamic> body) async {
    http.Response response;
    try {
      response = await http.put(
        Uri.parse('http://127.0.0.1:8083/password/update'),
        headers: headers,
        body: jsonEncode(body),
      );
    } catch (e) {
      throw Error();
    }
    return response;
  }
}