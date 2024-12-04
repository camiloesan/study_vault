import 'dart:async';
import 'dart:io';

import 'package:grpc/grpc.dart';
import 'package:study_vault/src/generated/studyvault.pbgrpc.dart';

class PostsServices {
  Future<bool> uploadPost({
    required String filePath,
    required int channelId,
    required String title,
    required String description,
    required String filename,
    int chunkSize = 64 * 1024,
  }) async {
    bool isSuccess = false;

    final channel = ClientChannel(
      'localhost',
      port: 8081,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );

    final stub = PostsServiceClient(channel);
    final file = File(filePath);

    try {
      final fileStream = StreamController<FileChunk>();
      final inputStream = file.openRead();

      inputStream.listen(
        (data) {
          final chunk = FileChunk(
            content: data,
            filename: filename,
            channelId: channelId,
            title: title,
            description: description,
          );
          fileStream.add(chunk);
        },
        onDone: () => fileStream.close(),
        onError: (error) => fileStream.addError(error),
      );

      final response = await stub.uploadPost(fileStream.stream);

      if (response.success) {
        isSuccess = true;
      }
      
    } finally {
      await channel.shutdown();
    }

    return isSuccess;
  }
}