import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_vault/pages/login.dart';
import 'package:study_vault/utils/user_provider.dart';

class AlertService {
  static final AlertService _instance = AlertService._internal();

  factory AlertService() {
    return _instance;
  }

  AlertService._internal();

  void showSessionExpirationAlert(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.logoutUser();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Session Expired"),
          content: const Text("Your session has expired. Please log in again."),
          actions: [
            TextButton(
              child: const Text("Log In"),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void showDatabaseErrorAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Database Error"),
          content: const Text(
              "An error occurred with the database. Please try again later."),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
