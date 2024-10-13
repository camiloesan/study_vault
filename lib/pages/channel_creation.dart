import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:study_vault/pojos/category.dart';

class ChannelCreation extends StatefulWidget {
  const ChannelCreation({super.key});

  @override
  State<ChannelCreation> createState() => _ChannelCreationState();
}

class _ChannelCreationState extends State<ChannelCreation>{
  late List<Category> categories = [];
  Category? selectedCategory; 

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

              const TextField(
                maxLength: 32,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 8.0),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Description'),
              ),

              const Expanded(
                child: TextField(
                  textAlignVertical: TextAlignVertical.top,
                  expands: true,
                  maxLength: 256,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
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
                      // Lógica para crear el canal
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
  
