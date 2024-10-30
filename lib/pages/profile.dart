import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_vault/pages/channels.dart';
import 'package:study_vault/utils/user_provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Channels()),
        );
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
    final int? userType = userProvider.userTypeId;
    final int? userId = userProvider.userId;

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
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
