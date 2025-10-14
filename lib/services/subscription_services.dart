import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SubscriptionServices {
   static Future<bool> onChannelUnsubscribe(int userId, int channelId, String token) async {
    final url = Uri.parse('${dotenv.env['SUBSCRIPTIONS_URL']}/unsubscribe');
    late bool result = false;
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final body = jsonEncode({
      'user_id': userId,
      'channel_id': channelId,
    });

    try {
      final response = await http.delete(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        result = true;
      } else if (response.statusCode == 401) {
        result = false;
      }
    } catch (e) {
      throw Exception('Error al procesar la solicitud');
    }

    return result;
  }

  static Future<bool> onChannelSubscribe(int userId, int channelId, String token) async {
    final url = Uri.parse('${dotenv.env['SUBSCRIPTIONS_URL']}/subscription');
    late bool result = false;
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final body = jsonEncode({
      'user_id': userId,
      'channel_id': channelId,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        result = true;
      } else if (response.statusCode == 401) {
        result = false;
      }
    } catch (e) {
      throw Exception('Error al procesar la solicitud');
    }

    return result;
  }
}