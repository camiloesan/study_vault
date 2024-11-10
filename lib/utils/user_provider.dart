import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  int? _userId;
  int? _userTypeId;
  String? _name;
  String? _lastName;
  String? _email;
  String? _token;

  int? get userId => _userId;
  int? get userTypeId => _userTypeId;
  String? get name => _name;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get token => _token;

  void loginUser(
      int userId, int userTypeId, String name, String lastName, String email, String token) {
    _userId = userId;
    _userTypeId = userTypeId;
    _name = name;
    _lastName = lastName;
    _email = email;
    _token = token;
    notifyListeners();
  }

  void logoutUser() {
    _userId = null;
    _userTypeId = null;
    _name = null;
    _lastName = null;
    _email = null;
    _token = null;
    notifyListeners();
  }

  void updateUserInfo(String name, String lastName) {
    _name = name;
    _lastName = lastName;
    notifyListeners();
  }
}
