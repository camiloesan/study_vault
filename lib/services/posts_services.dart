import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:study_vault/src/generated/studyvault.pbgrpc.dart';

class PostsServices {
  static Future<bool> uploadPost({
    required String filePath,
    required int channelId,
    required String title,
    required String description,
    required String filename,
    int chunkSize = 64 * 1024,
  }) async {
    bool isSuccess = false;

    final channel = ClientChannel(
      '192.168.1.104',
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

  static Future<String> fetchFileNameByFileId(String fileId) async {
    final channel = ClientChannel(
      '192.168.1.104',
      port: 8081,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    final stub = PostsServiceClient(channel);

    try {
      final response =
          await stub.getFileNameByFileId(FileId()..fileId = fileId);
      return response.filename;
    } catch (e) {
      rethrow;
    } finally {
      await channel.shutdown();
    }
  }

  static Future<void> downloadFile({
    required int channelId,
    required String fileId,
    required String folderPath,
    required String filename,
    required BuildContext context,
  }) async {
    final channel = ClientChannel(
      '192.168.1.104',
      port: 8081,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    final stub = PostsServiceClient(channel);

    try {
      final responseStream = stub.downloadFile(FileDownloadRequest()
        ..channelId = channelId
        ..fileId = fileId);

      final filePath = '$folderPath/$filename';
      final file = File(filePath);
      final fileSink = file.openWrite();

      await for (var chunk in responseStream) {
        fileSink.add(chunk.content);
      }

      await fileSink.close();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Archivo descargado en $filePath")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al descargar el archivo")),
      );
      rethrow;
    } finally {
      await channel.shutdown();
    }
  }
}
