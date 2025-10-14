import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_vault/pages/Change_password.dart';
import 'package:study_vault/pages/channels.dart';
import 'package:study_vault/pages/edit_profile.dart';
import 'package:study_vault/pages/landing_launch.dart';
import 'package:study_vault/utils/alert_service.dart';
import 'package:study_vault/utils/constants.dart';
import 'package:study_vault/utils/user_provider.dart';
import 'package:study_vault/services/users_services.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _userName = "";
  int? _userType = 0;
  bool _isStudent = false;
  String? _userEmail = "";
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

  void _deleteUser() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final int userId = userProvider.userId!;

    final headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token",
    };

    try {
      final response = await UsersServices.deleteUser(headers, userId);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account deleted")),
        );
        userProvider.logoutUser();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LandingLaunch()),
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

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm Deletion"),
              content: const Text(
                  "Are you sure you want to delete your account? This action cannot be undone."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text("Delete"),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void fetchProfileInfo() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _userName = utf8.decode(
        ("${userProvider.name ?? ""} ${userProvider.lastName ?? ""}")
            .codeUnits);
    _userType = userProvider.userTypeId;
    _isStudent = _userType == Constants.studentType;
    _userEmail = userProvider.email;
  }

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    token = userProvider.token;
    fetchProfileInfo();
  }

  @override
  Widget build(BuildContext context) {
    late String userRole = "";

    if (_isStudent) {
      userRole = "Student";
    } else {
      userRole = "Professor";
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Name",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(_userName, style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 16),
                  const Text("Role",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(userRole, style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 16),
                  const Text("Email",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(_userEmail ?? "", style: const TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 32),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditProfile()),
                      );
                    },
                    child: const Text("Edit Profile"),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChangePassword()),
                      );
                    },
                    child: const Text("Change Password"),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      bool confirmDelete =
                          await _showDeleteConfirmationDialog();
                      if (confirmDelete) {
                        _deleteUser();
                      }
                    },
                    child: const Text("Delete Account"),
                  ),
                ],
              ),
            ],
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
