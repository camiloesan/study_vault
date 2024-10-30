import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_vault/pages/channels.dart';
import 'package:study_vault/pages/profile.dart';
import 'package:study_vault/utils/constants.dart';
import 'package:study_vault/utils/user_provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
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

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String userName =
        "${userProvider.name ?? ""} ${userProvider.lastName ?? ""}";
    final int? userType = userProvider.userTypeId;
    final bool isStudent = userType == Constants.studentType;
    final String? userEmail = userProvider.email;
    late String userRole = "";

    if (isStudent) {
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
                  TextField(
                      controller: TextEditingController(text: userName),
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 16),
                  const Text("Role",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  TextField(
                      controller: TextEditingController(text: userRole),
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 16),
                  const Text("Email",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  TextField(
                      controller: TextEditingController(text: userEmail),
                      style: const TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 32),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Acción para guardar cambios
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
