import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_vault/pages/channels.dart';
import 'package:study_vault/pages/profile.dart';
import 'package:study_vault/pages/login.dart';
import 'package:study_vault/utils/user_provider.dart';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  int _selectedIndex = 1;
  String? token;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Channels()),
      );
    }
  }

  void _updaterUser() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final int? userId = userProvider.userId;

    final response = await http.put(
      Uri.parse('http://127.0.0.1:8083/update/$userId'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: json.encode({
        'id': userId,
        'name': _nameController.text,
        'last_name': _lastNameController.text
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated")),
      );
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final int? userId = userProvider.userId;
      _setUserName(userId);
    } else if (response.statusCode == 401) {
      handleSessionExpiration(context);
    } else {
      final errorResponse = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Error: ${errorResponse['message'] ?? 'Error al actualizarse'}")),
      );
    }
  }

  Future<void> _setUserName(int? userId) async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:8083/user/name/$userId'), headers: {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token",
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String _name = "";
      String _last_name = "";
      setState(() {
        _name = jsonResponse['name'] as String;
        _last_name = jsonResponse['last_name'] as String;
      });
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.updateUserInfo(_name, _last_name);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Profile()),
      );
    } else if (response.statusCode == 401) {
      handleSessionExpiration(context);
    } else {
      throw Exception('Error al obtener nombre de usuario');
    }
  }

  void handleSessionExpiration(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.logoutUser();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Session Expired"),
          content: Text("Your session has expired. Please log in again."),
          actions: [
            TextButton(
              child: Text("Log In"),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    token = userProvider.token;
    final String userName = utf8.decode((userProvider.name ?? "").codeUnits);
    final String userLastName =
        utf8.decode((userProvider.lastName ?? "").codeUnits);
    _nameController = TextEditingController(text: userName);
    _lastNameController = TextEditingController(text: userLastName);
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
                    TextFormField(
                      controller: _nameController,
                      style: const TextStyle(fontSize: 18),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu nombre';
                        } else if (value.length > 32) {
                          return 'Ingresa un nombre de menos de 32 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text("Last Name",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _lastNameController,
                      style: const TextStyle(fontSize: 18),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu apellido';
                        } else if (value.length > 64) {
                          return 'Ingresa un apellido de menos de 64 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
                const SizedBox(height: 32),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _updaterUser();
                        }
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
