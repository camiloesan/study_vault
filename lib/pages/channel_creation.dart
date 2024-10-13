import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:study_vault/pojos/category.dart';
import 'package:provider/provider.dart';
import 'package:study_vault/utils/user_provider.dart';

class ChannelCreation extends StatefulWidget {
  const ChannelCreation({super.key});

  @override
  State<ChannelCreation> createState() => _ChannelCreationState();
}

class _ChannelCreationState extends State<ChannelCreation>{
  late List<Category> categories = [];
  Category? selectedCategory;
  String channelName = '';
  String channelDescription = '';
  String _errorMessage = ''; 

  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8080/categories/all'));

    if (response.statusCode == 200) {
      List<dynamic> jsonCategories = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        categories = jsonCategories.map((category) => Category.fromJson(category)).toList();
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> createChannel() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final int userId = userProvider.userId!;

    final url = Uri.parse('http://127.0.0.1:8080/channel/create');
    final headers = {"Content-Type": "application/json"};

    final body = jsonEncode({
      'name': channelName,
      'description': channelDescription,
      'category_id': selectedCategory?.categoryId,
      'creator_id': userId
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Channel created successfully!')),
        );
      } else {
        throw Exception('Failed to create channel');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
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
                'New Channel',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 12.0),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Name'),
              ),

              TextField(
                maxLength: 32,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                setState(() {
                  channelName = value;
                });
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
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                  setState(() {
                    channelDescription = value;
                  });
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

                  ElevatedButton(
                    onPressed: () {
                      if (channelName.isNotEmpty && selectedCategory != null && channelDescription.isNotEmpty) {
                        createChannel();
                      } else {
                        setState(() {
                        _errorMessage = 'Please fill all fields';
                        });
                      }
                    },
                    child: const Text('Create'),
                  ),
                ],
              ),
            ],
          ),
      ),
    );
  }
}
  
