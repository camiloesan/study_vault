import 'dart:convert';
import 'package:grpc/grpc.dart';
import 'package:http/http.dart' as http;
import 'package:study_vault/src/generated/studyvault.pbgrpc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChannelsServices {
  static Future<List<PostsResponse_PostInfo>> fetchChannelPosts(
      int channelId) async {
    List<PostsResponse_PostInfo> posts = [];

    final channel = ClientChannel(
      '${dotenv.env['POSTS_IP']}',
      port: 8081,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );

    final stub = PostsServiceClient(channel);

    try {
      final response = await stub
          .getPostsByChannelId(ChannelRequest()..channelId = channelId);
      posts = response.posts;
    } catch (_) {
      throw Error();
    } finally {
      await channel.shutdown();
    }

    return posts;
  }

  static Future<http.Response> getChannelsByOwnerId(
      Map<String, String> headers, int userId) async {
    http.Response ownedChannels;
    try {
      ownedChannels = await http.get(
        Uri.parse('${dotenv.env['CHANNELS_URL']}/channels/owner/$userId'),
        headers: headers,
      );
    } catch (err) {
      throw Error();
    }

    return ownedChannels;
  }

  static Future<http.Response> getSubscribedChannelsByUserId(
      Map<String, String> headers, int userId) async {
    http.Response subscribedChannels;
    try {
      subscribedChannels = await http.get(
        Uri.parse('${dotenv.env['CHANNELS_URL']}/subscriptions/user/$userId'),
        headers: headers,
      );
    } catch (err) {
      throw Error();
    }

    return subscribedChannels;
  }

  static Future<http.Response> getAllChannels(
      Map<String, String> headers, int userId) async {
    http.Response allChannels;
    try {
      allChannels = await http.get(
        Uri.parse('${dotenv.env['CHANNELS_URL']}/channels/all'),
        headers: headers,
      );
    } catch (err) {
      throw Error();
    }

    return allChannels;
  }

  static Future<http.Response> createChannel(
      Map<String, String> headers, Map<String, dynamic> body) async {
    http.Response response;
    try {
      response = await http.post(
        Uri.parse('${dotenv.env['CHANNELS_URL']}/channel/create'),
        headers: headers,
        body: jsonEncode(body),
      );
    } catch (err) {
      throw Error();
    }
    return response;
  }

  static Future<http.Response> fetchCategories(
      Map<String, String> headers) async {
    http.Response response;
    try {
      response = await http.get(
        Uri.parse('${dotenv.env['CATEGORIES_URL']}/all'),
        headers: headers,
      );
    } catch (err) {
      throw Error();
    }
    return response;
  }

  static Future<http.Response> updateChannel(Map<String, String> headers,
      Map<String, dynamic> body, int channelId) async {
    http.Response response;
    try {
      response = await http.put(
        Uri.parse('${dotenv.env['CHANNELS_URL']}/channel/update/$channelId'),
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
        Uri.parse('${dotenv.env['CHANNELS_URL']}/channel/delete/$channelId'),
        headers: headers,
      );
    } catch (err) {
      throw Error();
    }
    return response;
  }

  static Future<http.Response> fetchChannelName(
      Map<String, String> headers, int channelId) async {
    http.Response response;
    try {
      response = await http.get(
        Uri.parse('${dotenv.env['CHANNELS_URL']}/channel/name/$channelId'),
        headers: headers,
      );
    } catch (err) {
      throw Error();
    }
    return response;
  }

  static Future<http.Response> fetchChannelCreator(
      Map<String, String> headers, int channelId) async {
    http.Response response;
    try {
      response = await http.get(
        Uri.parse('${dotenv.env['CHANNELS_URL']}/creator/channel/$channelId'),
        headers: headers,
      );
    } catch (err) {
      throw Error();
    }
    return response;
  }
}
