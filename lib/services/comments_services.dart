import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CommentsServices {
  static Future<http.Response> updateComment(Map<String, String> headers,
      Map<String, dynamic> body, int commentId) async {
    http.Response response;
    try {
      response = await http.put(
        Uri.parse('${dotenv.env['COMMENTS_URL']}/comment/update/$commentId'),
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
        Uri.parse('${dotenv.env['COMMENTS_URL']}/comment/delete/$commentId'),
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
        Uri.parse('${dotenv.env['COMMENTS_URL']}/comment/all/$postId'),
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
        Uri.parse('${dotenv.env['COMMENTS_URL']}/comment'),
        headers: headers,
        body: jsonEncode(body),
      );
    } catch (e) {
      throw Error();
    }
    return response;
  }

  static Future<http.Response> getAverageRating(
      Map<String, String> headers, int postId) async {
    http.Response response;
    try {
      response = await http.get(
          Uri.parse('${dotenv.env['COMMENTS_URL']}/rating/$postId'),
          headers: headers);
    } catch (e) {
      throw Error();
    }
    return response;
  }
}
