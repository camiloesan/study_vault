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

  static Future<http.Response> fetchComments(
      Map<String, String> headers, int postId) async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8084/comment/all/$postId'),
        headers: headers,
      );
      return response;
    } catch (e) {
      throw Error();
    }
  }

  static Future<http.Response> createComment(
      Map<String, String> headers, Map<String, dynamic> body) async {
    http.Response response;
    try {
      response = await http.post(
        Uri.parse('http://127.0.0.1:8084/comment'),
        headers: headers,
        body: jsonEncode(body),
      );
    } catch (e) {
      throw Error();
    }
    return response;
  }
}