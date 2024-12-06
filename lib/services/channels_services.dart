import 'dart:convert';
import 'package:grpc/grpc.dart';
import 'package:http/http.dart' as http;
import 'package:study_vault/src/generated/studyvault.pbgrpc.dart';

class ChannelsServices {
  static Future<List<PostsResponse_PostInfo>> fetchChannelPosts(int channelId) async {
    List<PostsResponse_PostInfo> posts = [];

    final channel = ClientChannel(
      'localhost',
      port: 8081,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );

    final stub = PostsServiceClient(channel);

    try {
      final response = await stub
          .getPostsByChannelId(ChannelRequest()..channelId = channelId);
      posts = response.posts;
    } catch(_) {
      throw Error();
    } finally {
      await channel.shutdown();
    }

    return posts;
  }

  static Future<http.Response> getChannelsByOwnerId(Map<String, String> headers, int userId) async {
    http.Response ownedChannels;
    try {
      ownedChannels = await http.get(
        Uri.parse('http://127.0.0.1:8080/channels/owner/$userId'),
        headers: headers,
      );
    } catch(err) {
      throw Error();
    }

    return ownedChannels;
  }

  static Future<http.Response> getSubscribedChannelsByUserId(Map<String, String> headers, int userId) async {
    http.Response subscribedChannels;
    try {
      subscribedChannels = await http.get(
          Uri.parse('http://127.0.0.1:8080/subscriptions/user/$userId'),
          headers: headers,
        );
    } catch(err) {
      throw Error();
    }

    return subscribedChannels;
  }

  static Future<http.Response> getAllChannels(Map<String, String> headers, int userId) async {
    http.Response allChannels;
    try {
      allChannels = await http.get(
          Uri.parse('http://127.0.0.1:8080/channels/all'),
          headers: headers,
        );
    } catch(err) {
      throw Error();
    }

    return allChannels;
  }

  static Future<http.Response> createChannel(Map<String, String> headers, Map<String, dynamic> body) async {
    http.Response response;
    try {
      response = await http.post(
        Uri.parse('http://127.0.0.1:8080/channel/create'),
        headers: headers,
        body: jsonEncode(body),
      );
    } catch (err) {
      throw Error();
    }
    return response;
  }

  static Future<http.Response> fetchCategories(Map<String, String> headers) async {
    http.Response response;
    try {
      response = await http.get(
        Uri.parse('http://127.0.0.1:8080/categories/all'),
        headers: headers,
      );
    } catch (err) {
      throw Error();
    }
    return response;
  }

  static Future<http.Response> updateChannel(
      Map<String, String> headers, Map<String, dynamic> body, int channelId) async {
    http.Response response;
    try {
      response = await http.put(
        Uri.parse('http://127.0.0.1:8080/channel/update/$channelId'),
        headers: headers,
        body: jsonEncode(body),
      );
    } catch (err) {
      throw Error();
    }
    return response;
  }

  static Future<http.Response> deleteChannel(
      Map<String, String> headers, int channelId) async {
    http.Response response;
    try {
      response = await http.delete(
        Uri.parse('http://127.0.0.1:8080/channel/delete/$channelId'),
        headers: headers,
      );
    } catch (err) {
      throw Error();
    }
    return response;
  }
}
