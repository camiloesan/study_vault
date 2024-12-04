import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:study_vault/models/category.dart';
import 'package:study_vault/models/channel.dart';
import 'package:provider/provider.dart';
import 'package:study_vault/utils/user_provider.dart';
import 'package:study_vault/utils/alert_service.dart';

class ChannelModification extends StatefulWidget {
  final Channel channel;
  const ChannelModification({Key? key, required this.channel})
      : super(key: key);

  @override
  State<ChannelModification> createState() => _ChannelModificationState();
}

class _ChannelModificationState extends State<ChannelModification> {
  late List<Category> categories = [];
  late TextEditingController nameController;
  late TextEditingController descriptionController;

  Category? selectedCategory;
  String _errorMessage = '';
  String? token;

  Future<void> updateChannel() async {
    final url = Uri.parse(
        'http://127.0.0.1:8080/channel/update/${widget.channel.channelId}');

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final body = jsonEncode({
      'name': nameController.text,
      'description': descriptionController.text,
      'category_id': selectedCategory?.categoryId,
    });

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Channel updated successfully!')),
        );
      } else if (response.statusCode == 401) {
        AlertService().showSessionExpirationAlert(context);
      } else {
        setState(() {
          _errorMessage = 'Failed to update channel';
        });
      }
    } catch (e) {
      AlertService().showDatabaseErrorAlert(context);
    }
  }

  Future<void> deleteChannel() async {
    final url = Uri.parse(
        'http://127.0.0.1:8080/channel/delete/${widget.channel.channelId}');

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 200) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Channel deleted successfully!')),
        );
      } else if (response.statusCode == 401) {
        AlertService().showSessionExpirationAlert(context);
      } else {
        setState(() {
          _errorMessage = 'Failed to delete channel';
        });
      }
    } catch (e) {
      AlertService().showDatabaseErrorAlert(context);
    }
  }

  Future<void> deleteConfirmation() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Channel'),
          content: const Text(
              'Are you sure you want to delete this channel? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await deleteChannel();
    }
  }

  Future<void> fetchCategories() async {
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8080/categories/all'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonCategories =
            json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          categories = jsonCategories
              .map((category) => Category.fromJson(category))
              .toList();
          selectedCategory = categories.firstWhere(
              (category) => category.name == widget.channel.categoryName);
        });
      } else if (response.statusCode == 401) {
        AlertService().showSessionExpirationAlert(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al recuperar las categorías")),
        );
      }
    } catch (e) {
      AlertService().showDatabaseErrorAlert(context);
    }
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.channel.name);
    descriptionController =
        TextEditingController(text: widget.channel.description);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    token = userProvider.token;
    fetchCategories();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 520,
        width: 700,
        child: Column(
          children: [
            const Text(
              'Modify Channel',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12.0),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Name'),
            ),
            TextField(
              maxLength: 32,
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 8.0),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Description'),
            ),
            Expanded(
              child: TextField(
                textAlignVertical: TextAlignVertical.top,
                expands: true,
                maxLength: 256,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                controller: descriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            const SizedBox(height: 8.0),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Select Category'),
            ),
            const SizedBox(height: 8.0),
            DropdownButtonFormField<Category>(
              value: selectedCategory,
              hint: const Text('Choose a category'),
              items: categories.map((category) {
                return DropdownMenuItem<Category>(
                  value: category,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8.0),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
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
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12.0),
                ElevatedButton.icon(
                  onPressed: deleteConfirmation,
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[200],
                  ),
                ),
                const SizedBox(width: 12.0),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        selectedCategory != null &&
                        descriptionController.text.isNotEmpty) {
                      if (nameController.text == widget.channel.name &&
                          descriptionController.text ==
                              widget.channel.description &&
                          selectedCategory?.name ==
                              widget.channel.categoryName) {
                        Navigator.pop(context, true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'No changes detected, channel is already up to date.')),
                        );
                      } else {
                        updateChannel();
                      }
                    } else {
                      setState(() {
                        _errorMessage = 'Please fill all fields';
                      });
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
