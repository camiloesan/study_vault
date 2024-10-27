import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:grpc/grpc.dart';
import 'package:study_vault/pojos/channel.dart';
import 'package:study_vault/src/generated/studyvault.pbgrpc.dart';

class PostCreation extends StatefulWidget {
  const PostCreation({super.key, required this.channel});

  final Channel channel;

  @override
  State<PostCreation> createState() => _PostCreationState();
}

class _PostCreationState extends State<PostCreation> {
  String selectedFilePath = "";
  String selectedFileName = "";
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 520,
        width: 700,
        child: Column(
          children: [
            const Text('Create new post',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12.0),
            const Align(alignment: Alignment.centerLeft, child: Text('Title')),
            TextField(
              controller: _titleController,
              maxLength: 32,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8.0),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Description'),
            ),
            Expanded(
              child: TextField(
                controller: _descriptionController,
                textAlignVertical: TextAlignVertical.top,
                expands: true,
                maxLength: 256,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            TextButton.icon(
              icon: Icon(
                selectedFilePath == "" ? Icons.attach_file : Icons.check_circle,
                color: selectedFilePath == "" ? null : Colors.green,
              ),
              label: Text(
                selectedFilePath == ""
                    ? 'Add Attachment'
                    : 'File Selected: ${selectedFilePath.split('/').last}',
              ),
              onPressed: pickFile,
            ),
            const SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel')),
                const SizedBox(width: 12.0),
                ElevatedButton(
                    onPressed: () {
                      uploadPost(
                          filePath: selectedFilePath,
                          channelId: widget.channel.channelId,
                          title: _titleController.text,
                          description: _descriptionController.text,
                          filename: selectedFileName);
                    },
                    child: const Text('Create')),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
      // Create a stream controller to manage the file chunks
      final controller = StreamController<FileChunk>();

      // Start reading the file in chunks
      final fileStream = file.openRead();

      // Process the file stream
      fileStream
          .cast<List<int>>()
          .asyncMap((chunk) => FileChunk()
            ..content = chunk
            ..filename = filename
            ..channelId = channelId
            ..title = title
            ..description = description)
          .listen((chunk) => controller.add(chunk),
              onDone: () => controller.close(),
              onError: (error) {
                print('Error reading file: $error');
                controller.close();
              });

      // Send the stream to the server
      final response = await stub.uploadPost(controller.stream);

      if (response.success) {
        isSuccess = true;
        print('Upload successful: ${response.message}');
      } else {
        print('Upload failed: ${response.message}');
      }
    } catch (e) {
      print('Caught error: $e');
    } finally {
      await channel.shutdown();
    }

    return isSuccess;
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        selectedFilePath = result.files.single.path.toString();
        selectedFileName = result.files.single.name.toString();
      });
    }
  }
}
