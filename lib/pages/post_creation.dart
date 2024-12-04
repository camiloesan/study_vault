import 'dart:async';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:study_vault/models/channel.dart';
import 'package:study_vault/services/posts_services.dart';

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
  Color _buttonColor = Colors.transparent;
  String? _titleErrorText;
  String? _descriptionErrorText;
  String? _fileErrorText;

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
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2.0),
                ),
                errorText: _titleErrorText,
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
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  ),
                  errorText: _descriptionErrorText,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            TextButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: _buttonColor),
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
            if (_fileErrorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _fileErrorText!,
                  style: const TextStyle(color: Colors.red),
                ),
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
                    onPressed: () async {
                      bool isValid = areFieldsValid();
                      if (!isValid) return;

                      bool uploadResult = false;
                      try {
                        uploadResult = await PostsServices.uploadPost(
                            filePath: selectedFilePath,
                            channelId: widget.channel.channelId,
                            title: _titleController.text,
                            description: _descriptionController.text,
                            filename: selectedFileName);
                      } catch (err) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Cannot create post right now, try again later')),
                          );
                        }
                      }

                      if (uploadResult) {
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Post created succesfully!')),
                          );
                        }
                      } else {
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Post could not be created, try again later'),
                                backgroundColor: Colors.redAccent),
                          );
                        }
                      }
                    },
                    child: const Text('Create')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool areFieldsValid() {
    bool result = true;

    if (selectedFilePath == "") {
      setState(() {
        _buttonColor = Colors.red.shade100;
        _fileErrorText = 'You must upload a file';
      });
      result = false;
    } else {
      setState(() {
        _buttonColor = Colors.transparent;
        _fileErrorText = null;
      });
    }

    if (_titleController.text.isEmpty) {
      setState(() {
        _titleErrorText = 'This field cannot be empty';
      });
      result = false;
    } else {
      setState(() {
        _titleErrorText = null;
      });
    }

    if (_descriptionController.text.isEmpty) {
      setState(() {
        _descriptionErrorText = 'This field cannot be empty';
      });
      result = false;
    } else {
      setState(() {
        _descriptionErrorText = null;
      });
    }

    return result;
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
