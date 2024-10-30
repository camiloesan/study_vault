import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_vault/pages/channels.dart';
import 'package:study_vault/pages/profile.dart';
import 'package:study_vault/utils/constants.dart';
import 'package:study_vault/utils/user_provider.dart';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Channels()),
        );
        break;
      case 1:
      default:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Profile()),
        );
    }
  }

  void _updaterUser() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final int? userId = userProvider.userId;

    final response = await http.put(
      Uri.parse('http://127.0.0.1:8083/update/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': userId,
        'name': _nameController.text,
        'last_name': _lastNameController.text
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registro exitoso")),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Profile()),
      );
    } else {
      final errorResponse = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Error: ${errorResponse['message'] ?? 'Error al registrarse'}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Name",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    TextField(
                        controller: _nameController,
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 16),
                    const Text("Last Name",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    TextField(
                        controller: _lastNameController,
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 16),
                  ],
                ),
                const SizedBox(height: 32),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _updaterUser();
                      },
                      child: const Text("Save Changes"),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Profile()),
                        );
                      },
                      child: const Text("Cancelar"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.collections_bookmark_outlined),
            label: 'Channels',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
