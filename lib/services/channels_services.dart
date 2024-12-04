import 'package:grpc/grpc.dart';
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
}
