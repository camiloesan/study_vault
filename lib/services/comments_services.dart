import 'package:http/http.dart' as http;
import 'dart:convert';

class CommentsServices {
 static Future<http.Response> updateComment(
      Map<String, String> headers, Map<String, dynamic> body, int commentId) async {
    http.Response response;
    try {
      response = await http.put(
        Uri.parse('http://127.0.0.1:8084/comment/update/$commentId'),
        headers: headers,
        body: jsonEncode(body),
      );
    } catch (e) {
      throw Error();
    }
    return response;
  }

  static Future<http.Response> deleteComment(
      Map<String, String> headers, int commentId) async {
    http.Response response;
    try {
      response = await http.delete(
        Uri.parse('http://127.0.0.1:8084/comment/delete/$commentId'),
        headers: headers,
      );
    } catch (e) {
      throw Error();
    }
    return response;
  }
}