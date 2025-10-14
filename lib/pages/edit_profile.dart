import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_vault/pages/channels.dart';
import 'package:study_vault/pages/profile.dart';
import 'package:study_vault/utils/alert_service.dart';
import 'package:study_vault/utils/user_provider.dart';
import 'package:study_vault/services/users_services.dart';


class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  final int _selectedIndex = 1;
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
    final int userId = userProvider.userId!;

    final headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token",
    };

    final body = {
      'id': userId,
      'name': _nameController.text,
      'last_name': _lastNameController.text,
    };

    try {
      final response = await UsersServices.updateUser(headers, body, userId);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated")),
        );
        _setUserName(userId);
      } else if (response.statusCode == 401) {
        AlertService().showSessionExpirationAlert(context);
      } else {
        AlertService().showDatabaseErrorAlert(context);
      }
    } catch (e) {
      AlertService().showDatabaseErrorAlert(context);
    }
  }

  Future<void> _setUserName(int? userId) async {
    if (userId == null) {
      return;
    }

    final headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token",
    };

    try {
      final response = await UsersServices.getUserName(headers, userId);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        String name = jsonResponse['name'] as String;
        String last_name = jsonResponse['last_name'] as String;

        setState(() {
          name = name;
          last_name = last_name;
        });

        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.updateUserInfo(name, last_name);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Profile()),
        );
      } else if (response.statusCode == 401) {
        AlertService().showSessionExpirationAlert(context);
      } else {
        AlertService().showDatabaseErrorAlert(context);
      }
    } catch (e) {
      AlertService().showDatabaseErrorAlert(context);
    }
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
